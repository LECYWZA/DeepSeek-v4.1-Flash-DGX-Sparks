#!/bin/bash
# dspark.sh — DeepSeek-V4.1-Flash (3× Spark TP3) 控制台菜单
#
# 用法（必须在本目录执行）:
#   cd /models/DeepSeek-V4.1-Flash-DGX-Sparks && ./dspark.sh
#   输入数字选择，q 退出；每个操作结束会提示"按回车返回菜单"
#
# 菜单项:
#   1) doctor  环境自检（GPU/SSH/镜像/权重/NFS 是否就绪）
#   2) build   构建 Engram overlay 镜像 dsv41-3x-spark:local
#   3) share   在 spark1 导出权重 NFSv4，给 spark2/spark3 挂载
#   4) pack    Engram 分片重打包到各机本地 NVMe（首次约 10 分钟）
#   5) serve   启动服务（前台日志；约 30 分钟到 Ready；Ctrl+C 只退日志、不停服务）
#   6) status  查看三台容器与 API 状态
#   7) logs    看 head 日志尾部（./start.sh logs worker1 可看 worker）
#   8) logs -f 跟随日志（Ctrl+C 只退出跟随，不影响服务）
#   9) stop    停止一切：head/worker + worker 的 NFS 卷 + dsv41-nfs 全停
#   i)         一键初始化：doctor → build → share → pack
#
# 场景速查（什么情况跑哪几步）:
#   * 全新机器/环境大变动 ...... i → 5 → 6 验证
#   * 日常启动（服务已停） ...... 5（会自动补 share）→ 6
#   * 改了 .env（参数/IP/密钥） . 9（全停）→ 5（重启生效）
#   * 只动了权重或 NFS 配置 ..... 3 → 5
#   * 改了 adapter/ 代码 ........ 2（重建镜像）→ 9 → 5
#   * 服务异常/卡死 ............. 6 看状态 → 7/8 看日志 → 9 → 5 拉起
#   * 日常体检/看日志 ........... 1 / 6 / 7
#   * 完全停机/检修 ............. 9（全停；下次 5 会自动重建 NFS+卷）
#
# 备注:
#   - 9) 为"全停"（不含权重/镜像）；重启走 5) 即可，无需先 3)
#   - 生成运行报告: ./export-report.sh（产出 runtime-report-*.md）
#   - 各参数含义见 .env.example；部署细节见 README.md
#   - 控制脚本实体: start.sh / stop.sh（本菜单只是包装）
cd "$(dirname "$0")" || exit 1

pause() { echo; read -r -p "按回车返回菜单..." _; }

while true; do
  clear
  echo "=================================================="
  echo "     DeepSeek-V4.1-Flash (3× Spark TP3) 控制台"
  echo "=================================================="
  echo "  1) 环境自检        doctor"
  echo "  2) 构建镜像        build"
  echo "  3) 共享权重 NFS    share"
  echo "  4) 打包 Engram     pack (首次约10分钟)"
  echo "  5) 启动服务        serve (前台日志, 约30分钟到Ready)"
  echo "  --------------------------------------------------"
  echo "  6) 查看状态        status"
  echo "  7) 查看日志 (尾)   logs"
  echo "  8) 跟随日志        logs -f (Ctrl+C 退出跟随, 不影响服务)"
  echo "  9) 停止服务        stop"
  echo "  --------------------------------------------------"
  echo "  i) 一键初始化      doctor → build → share → pack"
  echo "  q) 退出"
  echo
  read -r -p "请选择: " c
  echo
  case "$c" in
    1) ./start.sh doctor; pause ;;
    2) ./start.sh build; pause ;;
    3) ./start.sh share; pause ;;
    4) ./start.sh pack; pause ;;
    5) echo "提示: 启动约30分钟; 中途 Ctrl+C 只退出日志显示, 容器会继续启动; 停止服务请用菜单 9)"; echo
       read -r -p "是否开启内存守护 dsv41-memguard（长上下文防爆，默认关）？[y/N]: " mg
       if [[ "$mg" =~ ^[Yy]$ ]]; then
         export DSV41_MEMGUARD_GB="${DSV41_MEMGUARD_GB:-1.5}"
         echo "内存守护: 开（随服务启动; 停止服务时自动关闭; 阈值 ${DSV41_MEMGUARD_GB} GB）"
       else
         echo "内存守护: 关"
       fi
       ./start.sh serve; pause ;;
    6) ./start.sh status; pause ;;
    7) ./start.sh logs; pause ;;
    8) echo "提示: Ctrl+C 退出日志跟随 (不影响服务)"; echo
       ./start.sh logs -f ;;
    9) ./start.sh stop; pause ;;
    i|I) ./start.sh doctor && ./start.sh build && ./start.sh share && ./start.sh pack; pause ;;
    q|Q) exit 0 ;;
    *) ;;
  esac
done
