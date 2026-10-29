#!/bin/bash
# MongoDB 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "MongoDB: mongodb://root:root@localhost:27017"
