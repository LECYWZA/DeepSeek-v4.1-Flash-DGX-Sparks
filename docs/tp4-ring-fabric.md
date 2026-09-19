# TP4 无交换机环状部署（4× DGX Spark · Ring · NFS from head）

本集群 4 台 DGX Spark（spark-1/2/3/4），**无 RoCE 交换机**，每台仅有 2 个 ConnectX-7
200G 口。TP=4 下的唯一连通拓扑是**环（ring）**：head→w1→w2→w3→head。本文给出
接线、IP、NFS 与运维约定。**先读 README（上游 TP4 profile 说明）与 .env.tp4.example。**

> 注意：spark-4 为新机，接入前确认已安装 ConnectX-7 模块（`lspci | grep -i mellanox`
> 有输出、`ls /sys/class/infiniband` 非空）。没装 RDMA 卡时只能走 2.5G 管理口，环上
> NCCL 会被拖垮（88 次 all-reduce/步全部要经以太网）。

## 1. 拓扑与 IP 规划（模板，按实际接线调整）

```
          rocep1s0f1np1                     rocep1s0f0np0
   ┌──────────────┐  192.168.100.1/24   ┌──────────────┐  192.168.104.1/24  ┌──────────────┐
   │  spark-1     │◄──────────────────►│  spark-4     │◄──────────────────►│  spark-1     │
   │  (HEAD)      │     400G 直连        │  (ring node) │     400G 直连        │              │
   └──────────────┘                    └──────────────┘                    └──────────────┘
          │ 192.168.100.2/24                                                   ▲
          │                                                                   │ 192.168.103.3/24
          ▼                                                                   │
   ┌──────────────┐  192.168.102.2/24   ┌──────────────┐  192.168.103.4/24
   │  spark-2     │◄──────────────────►│  spark-3     │
   └──────────────┘                    └──────────────┘
```

- 每条 200G 直连独立子网（/24），每台用 2 口、每口只连一个邻居，形成
  `S1(100.1)–S2(100.2)`、`S2(102.2)–S3(102.3)`、`S3(103.3)–S4(103.4)`、`S4(104.4)–S1(104.1)`。
- **环上只有 S2、S4 与 head 直连**；S3 与 head 相距两跳（经 S4 或 S2）。推理不受影响
  （NCCL RING 只做相邻通信），**NFS（加载期）**需要 S3 能到达 head —— 见 §3。
- 管理面：spark-1 `192.168.1.153` / spark-2 `.118` / spark-3 `.128` / spark-4 `.196`
  （`GLOO_SOCKET_IFNAME=enP7s7`，仅 bootstrap 与 SSH 用）。

## 2. .env.tp4 关键项（与环网对应）

```bash
HEAD_IP=192.168.100.1                        # rank0，API+NFS（head 对 S2 的口）
WORKER_IPS="192.168.100.2 192.168.102.3 192.168.103.4"
WORKER_HOSTS="spark2 spark3 spark4"
FABRIC_IFACE=enp1s0f1np1
GLOO_SOCKET_IFNAME=enP7s7
NCCL_SOCKET_IFNAME=enP7s7
IB_HCA=rocep1s0f0,rocep1s0f1,roceP2p1s0f0,roceP2p1s0f1   # GB10 全部 4 个 RoCE 设备
NCCL_ALGO=RING                                 # 显式锁定 ring（默认同值）
NCCL_IB_GID_INDEX=3                            # 关键：对端断电会导致 GID 全零
NCCL_NET_PLUGIN=none
NCCL_TUNER_THRESHOLD=40960
# NFS 路径（见 §3）：
NFS_SERVER_IPS="192.168.100.1 192.168.104.1 192.168.104.1"
NFS_CLIENTS=192.168.100.0/24,192.168.101.0/24,192.168.102.0/24,192.168.103.0/24,192.168.104.0/24
```

- `DSV41_MODEL_VARIANT=ablit`（默认）→ head 上先经 `./start-tp4.sh prepare` 生成
  去审查权重；`native` 关闭。
- 每机时钟锁 2000MHz（本集群固定，无过热/时钟 latch 问题）——基准口径低于
  LuZ(2400/2200MHz) 与 Mia README，对比时请按约 -10~-20% 预期。

## 3. NFS（权重在 head spark-1，worker 全走 NFS 加载）

Mia 默认：head 导出 `$MODEL_DIR`（选 ablit 时导出 ablit 目录），worker 用
`NFS_SERVER_IPS`（每 worker 一个 head 地址）创建 `dsv41-weights` 卷挂载。
环上：

- **S2**：直连 head（100.1），挂 `192.168.100.1`（快）。
- **S4**：直连 head（104.1），挂 `192.168.104.1`（快）。
- **S3**：与 head 两跳，需要桥接。**方案 A（一次配置，永久生效）**：让 S4 作为
  S3↔head 的桥（S4 同时持有 103.4 与 104.4 两个网段，天然中转）：
  ```bash
  # 在 spark-4（桥接节点）：
  sysctl -w net.ipv4.ip_forward=1
  # 在 spark-3（两跳节点）：
  ip route add 192.168.104.0/24 via 192.168.103.4
  ```
  之后 S3 挂 `192.168.104.1`（NFS TCP 经 S4 转发；速度比直连略低但远快于管理面）。
- 兜底：S3 临时改挂管理面 `192.168.1.153`（千兆，476G 加载 ≈1h，仅启动期）。
- **权重本地化备选**（若想彻底绕开 NFS）：`NFS_SHARE=0` + 每机本地放模型
  （`rsync` 从 spark-2 的 HF 缓存或 head 的 `/models` 副本，走管理面或相邻 200G 口）。

## 4. GID 预检（每次起服前，尤其断电/重启后）

对端断电会把 RoCE 的 GID 清成全零，NCCL 表现为 `ibv_modify_qp errno 61`（**不是** NCCL
或驱动故障）。检查每台 `cat /sys/class/infiniband/rocep1s0f1/ports/1/gids/3` 应为
`fe80::...<本机对口 IP>` 非全零；`./start-tp4.sh doctor` 已内置 HCA/GID/端口检查。

## 5. 镜像分发（spark-4 全新，**禁止 pull**）

```bash
# spark-1（head 侧，一次性）：
docker tag dsv41-3x-spark:local dsv41-4x-spark:local        # 对齐 .env.tp4 的 IMAGE 名
docker save dsv41-4x-spark:local -o /models/dsv41-4x-spark.tar   # ~33GB, 不动运行容器
# 传输（管理面 2.5G 约 2-3 分钟；或等 S4 接入后走 200G 秒级）：
rsync -avP /models/dsv41-4x-spark.tar root@192.168.1.196:/models/
# spark-4：
docker load -i /models/dsv41-4x-spark.tar
docker images   # 校验 ID 与 spark-1 一致；失败严禁 `docker pull` 兜底（网络慢）
rm /models/dsv41-4x-spark.tar
```

按需补分发：`eugr-gb10-nvfp4kv:a4q2`（keys 对照）、`dspark-vllm-gx10:ib-v2`
（现役 V4 Flash，回滚用），同法 save/load。

## 6. 一次完整上线顺序（线到后）

1. 接线成环 + 按 §1 配 IP + **§3 静态路由** + 每台 `gid_preflight` 通过
2. spark-4：docker 镜像 `load`（§5）+ 复刻本仓库（`git clone gitlab` 或 rsync）
3. `./dspark.sh --tp4` → 1) doctor 全绿 → 2) build（head 已构建过可跳过，S4 用成品镜像）→
   3) share → 4) pack（每机本地产 Engram 分片 ~48G）→ 5) serve → 6) status/7) logs
4. 验收：`./start-tp4.sh smoke`（三选一）+ 1M needle（C4）+ decode/prefill 基准
   （sparkDash 或手跑，注意 2000MHz 口径）
5. 失败回滚：`./dspark.sh --tp4` 9) stop；现役 V4 Flash 栈在 `dgx-spark-deploy`
   （`git checkout main` 即回稳，spark-1/2 两个容器仍在）。

## 7. 已知注意事项（继承 LuZ0.4.5 / Mia 经验）

- `--max-num-batched-tokens`（LuZ 的 4096 红线是 V4 Flash + FlashInfer 0.6.18 的上限；
  **本栈对应项是 `CHUNKED_PREFILL_SIZE=1024`**，1M 下别调大，见 .env.tp4.example）。
- `expandable_segments:False` 不可改 True（>64 query tokens 的 prefill 出 NaN）。
- GPU 慢态（时钟 latch）本集群已通过锁 2000MHz 规避；仍建议基准前 `nvidia-smi
  --query-gpu=clocks.sm --format=csv,noheader` 确认 ~2000。
