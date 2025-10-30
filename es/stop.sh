#!/bin/bash

# Elasticsearch Docker Compose 停止脚本（幂等）
set -e

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="elasticsearch"

echo "Stopping Elasticsearch ..."

# 检查Docker是否运行
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running."
  exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed."
  exit 1
fi

# 检查服务是否在运行
if [ -z "$(docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps -q)" ]; then
  echo "Elasticsearch is not running."
  exit 0
fi

# 停止并删除服务
echo "Stopping Elasticsearch and Kibana containers..."
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down

echo "Elasticsearch stopped successfully."
