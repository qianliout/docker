#!/bin/bash
# Loki + Grafana 启动（幂等），并在宿主机安装 Loki Docker 日志插件
set -e
cd "$(dirname "$0")"
docker compose up -d
sh ./install-logging-plugin.sh
echo "Loki push: http://127.0.0.1:3100/loki/api/v1/push  Grafana: http://127.0.0.1:3000  admin / admin"
