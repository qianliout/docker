#!/bin/bash

# Redis Docker Compose 停止脚本（幂等）
set -e

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="redis"

echo "Stopping Redis ..."

# 检查Docker Compose是否安装
if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed."
  exit 1
fi

# 停止并移除所有相关的容器、网络和卷
# "down" 命令是幂等的，无论服务是否正在运行，它都能正确处理
echo "Stopping and removing Redis containers..."
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down

echo "Redis container stopped successfully."