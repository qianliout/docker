#!/bin/bash
# Redis 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "Redis: localhost:6379  密码 redis"
