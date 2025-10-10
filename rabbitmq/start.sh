#!/bin/bash

# RabbitMQ Docker Compose 启动脚本（幂等）
set -e

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="rabbitmq"

echo "Starting RabbitMQ container with Docker Compose..."

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
  echo "RabbitMQ container is already running."
  echo "Current status:"
  docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
  exit 0
fi

# 启动服务
echo "Starting RabbitMQ..."
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d

# 等待RabbitMQ启动
echo "Waiting for RabbitMQ to become available..."
sleep 10

# 检查服务状态
echo "RabbitMQ container started successfully!"
echo "Services status:"
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps

echo ""
echo "Connection details:"
echo "  RabbitMQ AMQP: localhost:5672"
echo "  RabbitMQ Management UI: http://localhost:15672"
echo "  Username: user"
echo "  Password: password"
echo ""
echo "To view logs: docker-compose -f $COMPOSE_FILE -p $PROJECT_NAME logs -f"
