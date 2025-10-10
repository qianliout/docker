#!/bin/bash

# MySQL Docker Compose 启动脚本（幂等）
set -e

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="mysql"

echo "Starting MySQL container with Docker Compose..."

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
if [ -n "$(docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps -q)" ]; then
  echo "MySQL container is already running."
  echo "Current status:"
  docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
  exit 0
fi

# 启动服务
echo "Starting MySQL..."
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d

# 等待MySQL启动
echo "Waiting for MySQL to become available..."
sleep 5

# 检查服务状态
echo "MySQL container started successfully!"
echo "Services status:"
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps

echo ""
echo "Connection details:"
echo "  MySQL Host: localhost:3306"
echo "  Username: root"
echo "  Password: root"
echo ""
echo "To view logs: docker-compose -f $COMPOSE_FILE -p $PROJECT_NAME logs -f"
