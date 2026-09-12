#!/bin/bash
# 生成 DeepSeek-V4.1-Flash 运行报告 (markdown)
cd /models/DeepSeek-v4.1-Flash-DGX-Sparks || exit 1
OUT="$PWD/runtime-report-$(date +%Y%m%d-%H%M).md"
meminfo() { grep -e MemTotal -e MemAvailable -e SwapTotal -e SwapFree -e Cached /proc/meminfo; }
{
echo "# DeepSeek-V4.1-Flash 运行报告（3× Spark TP3）"; echo
echo "- 导出时间: $(date '+%F %T %Z')"
echo "- 配置: $(grep -e '^CONTEXT_LENGTH' -e '^MAX_TOTAL_TOKENS' -e '^MAX_RUNNING_REQUESTS' .env | tr '\n' ' ')"
echo; echo "## 0. 容器状态"; echo '```'
echo "== spark-1 =="; docker ps -a --format '{{.Names}} {{.Status}}'
echo "== spark-2 =="; ssh -o BatchMode=yes root@192.168.100.2 "docker ps -a --format '{{.Names}} {{.Status}}'"
echo "== spark-3 =="; ssh -o BatchMode=yes root@192.168.101.3 "docker ps -a --format '{{.Names}} {{.Status}}'"
echo '```'
echo; echo "## 1. 内存状态（导出时实时）"
echo "### spark-1"; echo '```'; free -h; meminfo; echo '```'
echo "### spark-2"; echo '```'; ssh -o BatchMode=yes root@192.168.100.2 "free -h; grep -e MemTotal -e MemAvailable -e SwapTotal -e SwapFree /proc/meminfo"; echo '```'
echo "### spark-3"; echo '```'; ssh -o BatchMode=yes root@192.168.101.3 "free -h; grep -e MemTotal -e MemAvailable -e SwapTotal -e SwapFree /proc/meminfo"; echo '```'
echo; echo "## 2. 启动关键指标（head 日志提取）"; echo '```'
docker logs dsv41-head 2>&1 | grep -e max_total_num_tokens -e "Engine startup timings" -e "Load weight end" -e "avail mem" | tail -20
echo '```'
echo; echo "## 3. 容器日志（全量）"
echo "### 3.1 dsv41-head（spark-1）"; echo '~~~'; docker logs dsv41-head 2>&1; echo '~~~'
echo "### 3.2 dsv41-worker（spark-2）"; echo '~~~'; ssh -o BatchMode=yes root@192.168.100.2 "docker logs dsv41-worker 2>&1"; echo '~~~'
echo "### 3.3 dsv41-worker（spark-3）"; echo '~~~'; ssh -o BatchMode=yes root@192.168.101.3 "docker logs dsv41-worker 2>&1"; echo '~~~'
echo; echo "## 4. 备注"
echo "- 服务: DeepSeek-V4.1-Flash 3×Spark TP3 (SGLang)"
echo "- 日志中 /slots 404 为外部探测，无碍。"
} > "$OUT" 2>&1
echo "已生成: $OUT"; ls -lh "$OUT"
