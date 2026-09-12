#!/usr/bin/env bash
# stop.sh — full teardown of DeepSeek-V4.1-Flash SGLang on all 3 Sparks.
#
# Stops (safe order):
#   - dsv41-head on spark1 (rank 0 + API :8888)
#   - dsv41-worker on spark2 and spark3
#   - worker docker volume dsv41-weights (its NFS mount is dropped)
#   - the NFSv4 exporter (dsv41-nfs) — removed LAST, only after both workers
#     are gone; stopping it while a worker still has it mounted wedges that
#     worker's docker in a kernel hard-mount retry
#   - log-tail helper
#   - leftover sglang.launch_server in those containers
#
# Keeps:
#   - checkpoint on spark1
#   - overlay image dsv41-3x-spark:local
#
# Usage:
#   ./stop.sh        stop everything on all 3 nodes
#   ./start.sh stop  same
#
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      sed -n '2,20p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      echo "unknown arg: $1 (try ./stop.sh --help)" >&2
      exit 1
      ;;
  esac
  shift
done

ENV_FILE="${ENV_FILE:-$ROOT/.env}"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ENV_FILE"
  set +a
fi

_abs() { readlink -f "$1" 2>/dev/null || echo "$1"; }

HEAD_CTN="${HEAD_CTN:-dsv41-head}"
WORKER_CTN="${WORKER_CTN:-dsv41-worker}"
PORT="${PORT:-8888}"
_list() { tr ',' ' ' <<<"$1"; }
if [[ -n "${WORKER_IPS:-}" ]]; then
  read -r -a WORKER_IPS <<<"$(_list "$WORKER_IPS")"
else
  WORKER_IPS=("${WORKER1_IP:-10.0.0.2}" "${WORKER2_IP:-10.0.0.3}")
fi
if [[ -n "${WORKER_HOSTS:-}" ]]; then
  read -r -a WORKER_HOSTS <<<"$(_list "$WORKER_HOSTS")"
else
  WORKER_HOSTS=()
  for _i in "${!WORKER_IPS[@]}"; do
    _v="WORKER$((_i + 1))_HOST"
    WORKER_HOSTS+=("${!_v:-${WORKER_IPS[$_i]}}")
  done
fi
WORKER_USER="${WORKER_USER:-zurih}"
SSH_IDENTITY="$(_abs "${SSH_IDENTITY:-$HOME/.ssh/id_ed25519_shared}")"
NFS_VOLUME="${NFS_VOLUME:-dsv41-weights}"
NFS_CONTAINER="${NFS_CONTAINER:-dsv41-nfs}"
IMAGE="${IMAGE:-dsv41-3x-spark:local}"
REMOTE_PY="${REMOTE_PY:-$ROOT/scripts/remote.py}"
LOG_DIR="${LOG_DIR:-$ROOT/logs}"
RM_TIMEOUT="${RM_TIMEOUT:-30}"

GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'; RED=$'\033[0;31m'; NC=$'\033[0m'
info() { echo "${GREEN}[+]${NC} $*"; }
warn() { echo "${YELLOW}[!]${NC} $*"; }
err()  { echo "${RED}[x]${NC} $*" >&2; }

remote_on() {
  local host="$1"; shift
  local env_args=()
  [[ -f "$ENV_FILE" ]] && env_args=(--env-file "$ENV_FILE")
  python3 "$REMOTE_PY" "${env_args[@]}" \
    --host "$host" --user "$WORKER_USER" \
    --identity "$SSH_IDENTITY" \
    --timeout "${REMOTE_TIMEOUT:-60}" \
    "bash -lc $(printf '%q' "$*")"
}

_rm_ctn() {
  local name="$1"
  timeout "$RM_TIMEOUT" docker rm -f "$name" >/dev/null 2>&1 || true
}

_stop_sglang_in() {
  local ctn="$1"
  docker ps --format '{{.Names}}' 2>/dev/null | grep -qx "$ctn" || return 0
  docker exec "$ctn" bash -lc '
    pkill -TERM -f "[s]glang.launch_server" >/dev/null 2>&1 || true
    pkill -TERM -f "[s]glang.srt" >/dev/null 2>&1 || true
    sleep 1
    pkill -KILL -f "[s]glang.launch_server" >/dev/null 2>&1 || true
  ' 2>/dev/null || true
}

info "=== stop DeepSeek-V4.1-Flash (3× Spark SGLang) ==="

if [[ -f "$LOG_DIR/logtail.pid" ]]; then
  kill "$(cat "$LOG_DIR/logtail.pid")" 2>/dev/null || true
  rm -f "$LOG_DIR/logtail.pid"
fi
pkill -f "docker logs -f ${HEAD_CTN}" >/dev/null 2>&1 || true

info "head: SIGTERM sglang in $HEAD_CTN, then remove"
_stop_sglang_in "$HEAD_CTN"
_rm_ctn "$HEAD_CTN"
# The NFS exporter (dsv41-nfs) is not touched here — it is removed at the very
# end, after both workers are gone. Stopping it while a worker still has it
# mounted wedges that worker's docker rm in a kernel hard-mount retry.
timeout "$RM_TIMEOUT" docker rm -f "$HEAD_CTN" >/dev/null 2>&1 || true

ALL_WORKERS_OK=1

for h in "${WORKER_HOSTS[@]}"; do
  info "worker $WORKER_USER@$h: stop $WORKER_CTN"
  if remote_on "$h" "
    if docker ps --format '{{.Names}}' | grep -qx $(printf '%q' "$WORKER_CTN"); then
      docker exec $(printf '%q' "$WORKER_CTN") bash -lc '
        pkill -TERM -f \"[s]glang.launch_server\" >/dev/null 2>&1 || true
        sleep 1
        pkill -KILL -f \"[s]glang.launch_server\" >/dev/null 2>&1 || true
      ' 2>/dev/null || true
    fi
    # One rm only, with a timeout. The old un-timed second attempt hung
    # forever whenever the NFS exporter was already gone (hard-mount retry).
    timeout ${RM_TIMEOUT} docker rm -f $(printf '%q' "$WORKER_CTN") >/dev/null 2>&1 || true
    echo STOPPED_$h
  " 2>/dev/null | grep -q "STOPPED_$h"; then
    info "  $h: container gone"
  else
    warn "  $h: SSH/docker cleanup failed (node unreachable?). GPU there may still be busy."
    ALL_WORKERS_OK=0
  fi
  info "  $h: drop NFS volume $NFS_VOLUME"
  remote_on "$h" "docker volume rm $(printf '%q' "$NFS_VOLUME") >/dev/null 2>&1 || true" || true
done

if [[ "$ALL_WORKERS_OK" == "1" ]]; then
  if docker ps -a --format '{{.Names}}' | grep -qx "$NFS_CONTAINER"; then
    info "head: stop NFS exporter $NFS_CONTAINER (last)"
    # This is a privileged kernel-NFS server (nfsd + rpc_pipefs inside). dockerd
    # sometimes fails to reap it on the first kill ("did not receive an exit
    # event") and only gets the exit ~1-3 min later, so: unexport first, then
    # retry the rm and give dockerd time instead of reporting a false failure.
    timeout 10 docker exec "$NFS_CONTAINER" sh -c 'exportfs -au 2>/dev/null || true; rpc.nfsd 0 2>/dev/null || true' >/dev/null 2>&1 || true
    _nfs_try=0
    while (( _nfs_try < 6 )); do
      _nfs_try=$((_nfs_try + 1))
      if timeout "$RM_TIMEOUT" docker rm -f "$NFS_CONTAINER"; then
        break
      fi
      warn "  rm attempt $_nfs_try/6 failed — waiting 10s, dockerd may still be reaping the container"
      sleep 10
    done
    if docker ps -a --format '{{.Names}}' | grep -qx "$NFS_CONTAINER"; then
      warn "$NFS_CONTAINER is STILL present — run: docker rm -f $NFS_CONTAINER (allow a minute), or restart docker"
    fi
  fi
else
  warn "worker cleanup incomplete — keeping $NFS_CONTAINER (stopping it now could wedge the remaining worker)"
fi

echo
if curl -sf --max-time 2 "http://127.0.0.1:${PORT}/v1/models" >/dev/null 2>&1 \
   || curl -sf --max-time 2 "http://127.0.0.1:${PORT}/health" >/dev/null 2>&1; then
  warn "something is still answering on :${PORT}"
else
  info "API down on :${PORT}"
fi

left=$(docker ps --format '{{.Names}}' 2>/dev/null | grep -E '^dsv41-' || true)
if [[ -n "$left" ]]; then
  warn "still running on head: $left"
else
  info "no dsv41-* containers on head"
fi

info "kept: spark1 weights, $IMAGE overlay"
info "start again with: ./start.sh serve (auto-runs the NFS share step)"
