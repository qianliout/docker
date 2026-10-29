#!/bin/bash
# Qdrant 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "Qdrant: REST http://localhost:6333  gRPC localhost:6334"
