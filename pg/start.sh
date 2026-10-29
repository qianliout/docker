#!/bin/bash
# PostgreSQL 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "PostgreSQL: localhost:5432  postgres / postgres"
