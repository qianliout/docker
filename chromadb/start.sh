#!/bin/bash
# ChromaDB 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "ChromaDB: http://localhost:9100"
