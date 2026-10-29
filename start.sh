#!/bin/bash
# 本机 docker 服务启停。用法: start [服务...] / stop [服务...]，不带参数进入菜单
BASE_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

ACTION=start
VERB=启动
if [ "$1" = "--stop" ]; then
  ACTION=stop
  VERB=停止
  shift
fi

# 服务名即子目录名（内含 start.sh / stop.sh）；outback 为 OrbStack 虚拟机
SERVICES=(
  "mysql:MySQL 9.7 (3306)"
  "pg:PostgreSQL 18 (5432)"
  "redis:Redis 8 (6379)"
  "rabbitmq:RabbitMQ 4 (5672 / 15672)"
  "mongodb:MongoDB 9 (27017)"
  "kafka:Kafka 4 + AKHQ (9092 / 8093)"
  "es:Elasticsearch + Kibana 9 (9200 / 5601)"
  "qdrant:Qdrant (6333 / 6334)"
  "chromadb:ChromaDB (9100)"
  "loki:Loki + Grafana (3100 / 3000)"
  "outback:OrbStack outback 虚拟机"
)

if [ $# -eq 0 ]; then
  echo "======================================"
  echo "  服务${VERB}（可多选，空格分隔）"
  echo "======================================"
  printf '  %-9s %s\n' all "全部服务"
  for s in "${SERVICES[@]}"; do
    printf '  %-9s %s\n' "${s%%:*}" "${s#*:}"
  done
  read -rp "请输入选择: " -a input
  set -- "${input[@]}"
fi

if [ $# -eq 0 ]; then
  echo "未选择任何服务"
  exit 1
fi

if [[ " $* " == *" all "* ]]; then
  set --
  for s in "${SERVICES[@]}"; do
    set -- "$@" "${s%%:*}"
  done
fi

failed=()
for svc in "$@"; do
  echo "---- ${VERB} $svc"
  if [ "$svc" = "outback" ]; then
    orbctl "$ACTION" outback || failed+=("$svc")
  elif [ -f "$BASE_DIR/$svc/$ACTION.sh" ]; then
    bash "$BASE_DIR/$svc/$ACTION.sh" || failed+=("$svc")
  else
    echo "未知服务: $svc"
    failed+=("$svc")
  fi
done

if [ ${#failed[@]} -gt 0 ]; then
  echo "${VERB}失败: ${failed[*]}"
  exit 1
fi
echo "${VERB}完成"
