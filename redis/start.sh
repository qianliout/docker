#!/bin/bash

# Redis Docker Compose 启动脚本（幂等）
set -e
cd "$(dirname "$0")"
ROOT="$(cd .. && pwd)"
ENV_FILE="$ROOT/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "错误: 未找到 $ENV_FILE。请执行: cp \"$ROOT/.env.example\" \"$ENV_FILE\" 并填写变量。"
  exit 1
fi

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="redis"

echo "Starting Redis container with Docker Compose..."

# 检查Docker是否运行
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Please start Docker first."
  exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed. Please install it first."
  exit 1
fi

# 检查服务是否已经在运行
if [ -n "$(docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps -q)" ]; then
  echo "Redis container is already running."
  echo "Current status:"
  docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
  exit 0
fi

# 启动服务
echo "Starting Redis..."
docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d

# 等待Redis启动
echo "Waiting for Redis to become available..."
sleep 5

# 检查服务状态
echo "Redis container started successfully!"
echo "Services status:"
docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps

echo ""
echo "Connection details:"
echo "  Redis Host: 127.0.0.1:6379"
echo "  密码见 $ENV_FILE 中的 REDIS_PASSWORD"
echo ""
echo "To view logs: docker-compose --env-file \"$ENV_FILE\" -f $COMPOSE_FILE -p $PROJECT_NAME logs -f"
