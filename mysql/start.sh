#!/bin/bash
# MySQL 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "MySQL: localhost:3306  root / root"
