# TP4 无交换机环状部署（4× DGX Spark · Ring · NFS from head）

本集群 4 台 DGX Spark（spark-1/2/3/4），**无 RoCE 交换机**，每台 2 个 ConnectX-7
物理口。TP=4 下的唯一连通拓扑是**环（ring）**：head→w2→w3→w4→head。本文给出
接线、IP、NFS 与运维约定（2026-09-19 实测落地的方案）。**先读 README 与 .env.tp4.example。**

> 注意：每台 Spark 的每个 QSFP 物理笼在系统里呈现 **2 个 netdev**（同一 index 的
> `enp1s0f*n*` 与 `enP2p1s0f*n*` 处在同一二层域，实测 LLDP 互见）。接线以
> `enp1s0f0np0 / enp1s0f1np1`（卡 A）为准即可，另一组 netdev 留 `optional: true`。

## 1. 拓扑与 IP 规划（2026-09-19 实际接线）

```
        S1 (HEAD) ──100.1  ⇄  100.2──  S2 ──102.2 ⇄ 102.3── S3
          │               (A1)    (A1)   (A0)   (A0)      │
          │ 101.1                                          │ 103.3
          │ (A0)                                           │ (A1)
          └──────────────⇄ S4 ⇄───────────────────────────┘
                   101.4 (A0)      103.4 (A1)
```

| 链路 | 端 A | 端 B | 网段 |
|---|---|---|---|
| S1↔S2 | S1 `enp1s0f1np1` = 192.168.100.1/24 | S2 `enp1s0f1np1` = 192.168.100.2/24 | 100 |
| S2↔S3 | S2 `enp1s0f0np0` = 192.168.102.2/24 | S3 `enp1s0f0np0` = 192.168.102.3/24 | 102 |
| S3↔S4 | S3 `enp1s0f1np1` = 192.168.103.3/24 | S4 `enp1s0f1np1` = 192.168.103.4/24 | 103 |
| S4↔S1 | S4 `enp1s0f0np0` = 192.168.101.4/24 | S1 `enp1s0f0np0` = 192.168.101.1/24 | 101 |

- 每条 200G 直连独立 /24，全部 `mtu 9000`，持久化在每台 `/etc/netplan/01-qsfp.yaml`。
- **环上只有 S2、S4 与 head 直连**；S3 与 head 相距两跳（经 S4）。NCCL RING 只做
  相邻通信，数据面不受影响；**NFS（加载期）**需要 S3 能到达 head —— 见 §3。
- 管理面：spark-1 `192.168.123.103` / spark-2 `.109` / spark-3 `.232` / spark-4 `.65`
  （Gloo/TCPStore 与 SSH 全部走管理面；SSH 免密仅需 head→各 worker）。

## 2. .env.tp4 关键项（与环网对应）

```bash
# rank0 = HEAD_IP；Gloo/TCPStore 要求全员可达 → 用管理面（与 TP3 验证一致）
HEAD_IP=192.168.123.103
WORKER_IPS="192.168.123.109 192.168.123.232 192.168.123.65"   # 管理面
WORKER_HOSTS="192.168.123.109 192.168.123.232 192.168.123.65" # SSH
WORKER_USER=root
SSH_IDENTITY=$HOME/.ssh/id_ed25519
WORKER_DIR=/root/dsv41-4x-spark
FABRIC_IFACE=enp1s0f0np0
GLOO_SOCKET_IFNAME=enP7s7
NCCL_SOCKET_IFNAME=enP7s7
IB_HCA=rocep1s0f0,rocep1s0f1,roceP2p1s0f0,roceP2p1s0f1   # GB10 全部 4 个 RoCE 设备
NCCL_ALGO=RING                                 # 显式锁定 ring（默认同值）
NCCL_IB_GID_INDEX=3                            # 对端断电会导致 GID 全零
NCCL_NET_PLUGIN=none
NCCL_TUNER_THRESHOLD=40960
# NFS 路径（见 §3，按 WORKER_IPS 顺序每 worker 一个 head 地址）：
NFS_SERVER_IPS="192.168.100.1 192.168.101.1 192.168.101.1"
NFS_CLIENTS=192.168.100.0/24,192.168.101.0/24,192.168.102.0/24,192.168.103.0/24,192.168.123.0/24
NCCL_HOST_DIR=/usr/local/lib                   # head 侧 host NCCL 2.30.7
READY_TIMEOUT=1200                             # 首次加载给足 20 分钟
```

- `DSV41_MODEL_VARIANT=ablit`（默认）→ head 上先经 `./start-tp4.sh prepare` 生成
  去审查权重；`native` 关闭。
- 每机时钟锁 2000MHz（本集群固定，无过热/时钟 latch 问题）——基准口径低于
  LuZ(2400/2200MHz) 与 Mia README，对比时请按约 -10~-20% 预期。

## 3. NFS（权重在 head spark-1，worker 全走 NFS 加载）

Mia 默认：head 导出 `$MODEL_DIR`（选 ablit 时导出 ablit 目录），worker 用
`NFS_SERVER_IPS`（每 worker 一个 head 地址）创建 `dsv41-weights` 卷挂载。
环上（2026-09-19 实测全部通过）：

- **S2**：直连 head（100.1），挂 `192.168.100.1`（快）。
- **S4**：直连 head（101.1），挂 `192.168.101.1`（快）。
- **S3**：与 head 两跳，经 **S4 桥接**（S4 同时持有 103.4 与 101.4）：
  ```bash
  # spark-4（桥节点）：
  sysctl -w net.ipv4.ip_forward=1                      # + /etc/sysctl.d/99-dsv41-forward.conf
  # 关键：docker 把 FORWARD policy 置 DROP，必须放行两 RoCE 口互转（已持久化 dsv41-forward.service）：
  iptables -I DOCKER-USER 1 -i enp1s0f1np1 -o enp1s0f0np0 -j ACCEPT
  iptables -I DOCKER-USER 1 -i enp1s0f0np0 -o enp1s0f1np1 -j ACCEPT
  # spark-3（两跳节点）+ spark-1（回程）：静态路由，已写入各自 01-qsfp.yaml
  #   spark-3: ip route add 192.168.101.0/24 via 192.168.103.4
  #   spark-1: ip route add 192.168.103.0/24 via 192.168.101.4   ← 回程（易漏！）
  ```
  之后 S3 挂 `192.168.101.1`（NFS TCP 经 S4 转发；实测挂载/读 config.json 正常）。
- 兜底：S3 临时改挂管理面 `192.168.123.103`（千兆，476G 加载 ≈1h，仅启动期）。

## 4. GID 预检（每次起服前，尤其断电/重启后）

对端断电会把 RoCE 的 GID 清成全零，NCCL 表现为 `ibv_modify_qp errno 61`（**不是** NCCL
或驱动故障）。检查每个带 IP 的口：
`cat /sys/class/infiniband/rocep1s0f0/ports/1/gids/3` 应为 `::ffff:<本机对口 IP>` 非全零
（2026-09-19 实测：S1 `::ffff:192.168.101.1`、S3 `::ffff:192.168.103.3`、S4 `::ffff:192.168.101.4/103.4`）。
修复：`nmcli device disconnect <if> && nmcli device connect <if>` 硬复位（reapply 无效）。
`./start-tp4.sh doctor` 已内置 HCA/GID/端口检查。

## 5. 镜像分发（新机/新版本，**禁止 pull**）

```bash
# 任一已有目标镜像的节点（实测 spark-4，33.5GB / 约 4 分钟；dockerd 先在
# /var/lib/docker/tmp/docker-export-* 暂存，随后 ~0.5GB/s 落盘）：
docker save dsv41-4x-spark:local -o /root/dsv41-img.tar
# 分发（head 有全部 worker 的 SSH 信任；走 200G 环网最快，实测 ~800MB/s）：
scp /root/dsv41-img.tar root@<fabric-ip>:/root/
ssh root@<host> "docker load -i /root/dsv41-img.tar && docker images dsv41-4x-spark:local && rm -f /root/dsv41-img.tar"
# 校验 ID 一致（本集群应为 594bb1ac3983）；失败严禁 `docker pull` 兜底（网络慢）
```

按需补分发：`eugr-gb10-nvfp4kv:a4q2`（keys 对照）、`dspark-vllm-gx10:ib-v2`（现役 V4
Flash 回滚栈），同法 save/load。

## 6. 一次完整上线顺序（实测流程）

1. 接线成环 + 按 §1 配 IP + **§3 路由/转发** + 每台 GID 预检通过
2. 镜像 save/load 分发（§5）→ worker `git clone` 仓库 + head 写 `.env.tp4`
3. `./start-tp4.sh doctor` 全绿 → `./start-tp4.sh share`（NFS 卷 3 worker 全部可见）
4. `./start-tp4.sh pack`（每机本地产 Engram 分片 ~48GiB；实测 head~2分钟/层）
5. `./dspark.sh --tp4` 或 `./start-tp4.sh serve` → smoke → 1M needle(C4) → 基准
6. 失败回滚：`./start-tp4.sh stop`；现役 V4 Flash 栈在 `dgx-spark-deploy`
   （`git checkout main` 即回稳）

## 7. 已知注意事项（继承 LuZ0.4.5 / Mia 经验）

- `--max-num-batched-tokens`（LuZ 的 4096 红线是 V4 Flash + FlashInfer 0.6.18 的上限；
  **本栈对应项是 `CHUNKED_PREFILL_SIZE=1024`**，1M 下别调大，见 .env.tp4.example）。
- `expandable_segments:False` 不可改 True（>64 query tokens 的 prefill 出 NaN）。
- GPU 慢态（时钟 latch）本集群已通过锁 2000MHz 规避；仍建议基准前 `nvidia-smi
  --query-gpu=clocks.sm --format=csv,noheader` 确认 ~2000。
