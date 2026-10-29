#!/bin/bash
# Qdrant 停止（幂等，保留 data）
set -e
cd "$(dirname "$0")"
docker compose down
