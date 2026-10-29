#!/bin/bash
# Kafka 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "Kafka: localhost:9092  AKHQ: http://localhost:8093"
