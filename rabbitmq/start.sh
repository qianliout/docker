#!/bin/bash
# RabbitMQ 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "RabbitMQ: amqp://admin:admin@localhost:5672  管理界面 http://localhost:15672"
