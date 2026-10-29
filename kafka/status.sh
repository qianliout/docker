#!/bin/bash
# 查看 Kafka 状态与最近日志
cd "$(dirname "$0")"
docker compose ps
docker compose logs --tail=10
