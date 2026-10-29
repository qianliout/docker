#!/bin/bash
# Elasticsearch 启动（幂等）
set -e
cd "$(dirname "$0")"
docker compose up -d
echo "Elasticsearch: http://localhost:9200  Kibana: http://localhost:5601"
