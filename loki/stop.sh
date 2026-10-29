#!/bin/bash
# Loki + Grafana 停止（保留日志插件；卸载: docker plugin disable loki --force && docker plugin rm loki）
set -e
cd "$(dirname "$0")"
docker compose down
