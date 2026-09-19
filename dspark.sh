#!/bin/bash
# dspark.sh — DeepSeek-V4.1-Flash (3x/4x Spark) 控制台菜单
#
# 用法（必须在本目录执行）:
#   cd <repo> && ./dspark.sh              # TP3 (start.sh / .env)
#   cd <repo> && ./dspark.sh --tp4        # TP4 (start-tp4.sh / .env.tp4)
#   输入数字选择，q 退出；每个操作结束会提示"按回车返回菜单"
#
# 菜单项:
#   1) doctor  环境自检（GPU/SSH/镜像/权重/NFS 是否就绪）
#   2) build   构建 Engram overlay 镜像（dsv41-{3x,4x}-spark:local）
#   3) share   在 head 导出权重 NFSv4，给 worker 挂载（自动制备 ablit 变体）
#   4) pack    Engram 分片重打包到各机本地 NVMe（首次约 10 分钟）
#   5) serve   启动服务（前台日志；冷启 10-30 分钟到 Ready；Ctrl+C 只退日志）
#   6) status  查看各机容器与 API 状态
#   7) logs    看 head 日志尾部（./start.sh logs worker1 可看 worker）
#   8) logs -f 跟随日志（Ctrl+C 只退出跟随，不影响服务）
#   9) stop    停止一切：head/worker + worker 的 NFS 卷 + dsv41-nfs 全停
#   a)         模型变体切换（ablit=default / native）
#   p)         制备 ablit 权重（./start.sh[-tp4].sh prepare，幂等）
#   i)         一键初始化：doctor → build → share → pack
#
# 场景速查（什么情况跑哪几步）:
#   * 全新机器/环境大变动 ...... i → 5 → 6 验证
#   * 日常启动（服务已停） ...... 5（会自动补 share + abl 制备）→ 6
#   * 改了 .env/.env.tp4 ........ 9（全停）→ 5（重启生效）
#   * 只动了权重或 NFS 配置 ..... 3 → 5
#   * 改了 adapter/ 代码 ........ 2（重建镜像）→ 9 → 5
#   * 服务异常/卡死 ............. 6 看状态 → 7/8 看日志 → 9 → 5 拉起
#   * 日常体检/看日志 ........... 1 / 6 / 7
#   * 完全停机/检修 ............. 9（全停；下次 5 会自动重建 NFS+卷）
#
# 备注:
#   - 9) 为"全停"（不含权重/镜像）；重启走 5) 即可，无需先 3)
#   - 生成运行报告: ./export-report.sh（产出 runtime-report-*.md）
#   - 各参数含义见 .env.example / .env.tp4.example；部署细节见 README.md 与 docs/
#   - 控制脚本实体: start.sh (TP3) / start-tp4.sh (TP4)；本菜单只是包装
cd "$(dirname "$0")" || exit 1

PROFILE="tp3"
if [[ "${1:-}" == "--tp4" || "${DSPARK_PROFILE:-tp3}" == "tp4" ]]; then
  PROFILE="tp4"
fi
LAUNCH() {
  if [[ "$PROFILE" == "tp4" ]]; then ./start-tp4.sh "$@"; else ./start.sh "$@"; fi
}
ENV_FILE=".env"
if [[ "$PROFILE" == "tp4" ]]; then ENV_FILE=".env.tp4"; fi
[[ -f "$ENV_FILE" ]] || { echo "[!] $ENV_FILE 不存在 — 复制示例: cp $ENV_FILE.example $ENV_FILE"; }
: > /tmp/dspark-env-$$.sh; i=0
while IFS= read -r line; do
  [[ "$line" =~ ^[[:space:]]*#?[[:space:]]*[A-Za-z_][A-Za-z0-9_]*= ]] || continue
  echo "$line" >> /tmp/dspark-env-$$.sh; i=$((i+1))
done < "$ENV_FILE"
source /tmp/dspark-env-$$.sh 2>/dev/null; rm -f /tmp/dspark-env-$$.sh
VARIANT="${DSV41_MODEL_VARIANT:-ablit}"

set_variant() {
  local v="$1"
  if [[ "$v" != "ablit" && "$v" != "native" ]]; then echo "[!] 变体必须是 ablit 或 native"; return; fi
  VARIANT="$v"
  if [[ -f "$ENV_FILE" ]]; then
    if grep -q "^DSV41_MODEL_VARIANT=" "$ENV_FILE"; then
      sed -i "s/^DSV41_MODEL_VARIANT=.*/DSV41_MODEL_VARIANT=$v/" "$ENV_FILE"
    else
      echo "DSV41_MODEL_VARIANT=$v" >> "$ENV_FILE"
    fi
  fi
  echo "[+] DSV41_MODEL_VARIANT=$v（已写入 $ENV_FILE；serve 时生效）"
}

pause() { echo; read -r -p "按回车返回菜单..." _; }

while true; do
  clear
  echo "=================================================="
  echo "     DeepSeek-V4.1-Flash ($( [[ "$PROFILE" == tp4 ]] && echo 4x || echo 3x )x Spark 控制台)"
  echo "      profile=${PROFILE}   model_variant=${VARIANT:-$(grep -E '^DSV41_MODEL_VARIANT=' "$ENV_FILE" 2>/dev/null | cut -d= -f2 || echo ablit)}"
  echo "=================================================="
  echo "  1) 环境自检        doctor"
  echo "  2) 构建镜像        build"
  echo "  3) 共享权重 NFS    share"
  echo "  4) 打包 Engram     pack (首次约10分钟)"
  echo "  5) 启动服务        serve (前台日志, 冷启10-30分钟到Ready)"
  echo "  --------------------------------------------------"
  echo "  6) 查看状态        status"
  echo "  7) 查看日志 (尾)   logs"
  echo "  8) 跟随日志        logs -f (Ctrl+C 退出跟随, 不影响服务)"
  echo "  9) 停止服务        stop"
  echo "  --------------------------------------------------"
  echo "  a) 模型变体切换    当前: ${VARIANT:-ablit} (ablit=默认/去审查, native=原版)"
  echo "  p) 制备 ablit 权重 prepare (幂等, 首次约几分钟)"
  echo "  i) 一键初始化      doctor → build → share → pack"
  echo "  q) 退出"
  echo
  read -r -p "请选择: " c
  echo
  case "$c" in
    1) LAUNCH doctor; pause ;;
    2) LAUNCH build; pause ;;
    3) LAUNCH share; pause ;;
    4) LAUNCH pack; pause ;;
    5) echo "提示: 冷启约10-30分钟; 中途 Ctrl+C 只退出日志显示, 容器会继续启动; 停止服务请用菜单 9)"; echo
       echo "当前模型变体: ${VARIANT:-ablit}（a) 可切换; 可用左上角查看）"
       read -r -p "是否开启内存守护 dsv41-memguard（长上下文防爆，默认关）？[y/N]: " mg
       if [[ "$mg" =~ ^[Yy]$ ]]; then
         export DSV41_MEMGUARD_GB="${DSV41_MEMGUARD_GB:-1.5}"
         echo "内存守护: 开（随服务启动; 停止服务时自动关闭; 阈值 ${DSV41_MEMGUARD_GB} GB）"
       else
         echo "内存守护: 关"
       fi
       LAUNCH serve; pause ;;
    6) LAUNCH status; pause ;;
    7) LAUNCH logs; pause ;;
    8) echo "提示: Ctrl+C 退出日志跟随 (不影响服务)"; echo
       LAUNCH logs -f ;;
    9) LAUNCH stop; pause ;;
    a|A) echo "当前: ${VARIANT:-ablit}"; read -r -p "切换为 (ablit|native) [回车=ablit]: " v
         set_variant "${v:-ablit}"; pause ;;
    p|P) LAUNCH prepare; pause ;;
    i|I) LAUNCH doctor && LAUNCH build && LAUNCH share && LAUNCH pack; pause ;;
    q|Q) exit 0 ;;
    *) ;;
  esac
done
