#!/bin/bash

# RabbitMQ Docker Compose 停止脚本（幂等）
set -e
cd "$(dirname "$0")"
ROOT="$(cd .. && pwd)"
ENV_FILE="$ROOT/.env"
COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="rabbitmq"

dc() {
  if [ -f "$ENV_FILE" ]; then
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" "$@"
  else
    docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" "$@"
  fi
}

echo "Stopping RabbitMQ ..."

# 检查Docker Compose是否安装
if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed."
  exit 1
fi

# 停止并移除所有相关的容器、网络和卷
# "down" 命令是幂等的，无论服务是否正在运行，它都能正确处理
echo "Stopping RabbitMQ containers..."
dc down

echo "RabbitMQ container stopped successfully."
