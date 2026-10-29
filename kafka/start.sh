#!/bin/bash
# Kafka 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "Kafka: 宿主机 localhost:9092，容器 host.docker.internal:29092  AKHQ: http://localhost:8093"
