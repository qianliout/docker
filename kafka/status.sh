#!/bin/bash

# 查看Kafka集群状态脚本
set -e

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="kafka-cluster"

echo "Kafka cluster status:"
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps

echo ""
echo "Container logs:"
docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" logs --tail=10