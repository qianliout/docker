#!/bin/bash

# Kafka Docker Compose 启动脚本（幂等）
set -e

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="kafka-cluster"

echo "Starting Kafka cluster with Docker Compose..."

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
  echo "Kafka cluster is already running."
  echo "Current status:"
  docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
  exit 0
fi

# 启动服务
echo "Starting Kafka, Zookeeper, and Kafka-UI..."
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d

# 等待Kafka启动
echo "Waiting for Kafka to become available..."
sleep 5

# 检查服务状态
echo "Kafka cluster started successfully!"
echo "Services status:"
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps

echo ""
echo "Connection details:"
echo "  Kafka Broker: localhost:9092"
echo "  Zookeeper: localhost:2181"
echo "  Kafka UI: http://localhost:8080"
echo ""
echo "To view logs: docker-compose -f $COMPOSE_FILE logs -f"
