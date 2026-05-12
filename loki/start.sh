#!/bin/bash

# Loki + Grafana（Compose）及 Loki Docker 日志插件（宿主机）
set -e
cd "$(dirname "$0")"
ROOT="$(cd .. && pwd)"
ENV_FILE="$ROOT/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "错误: 未找到 $ENV_FILE。请与其它服务一致准备根目录 .env。"
  exit 1
fi

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="loki"

echo "Starting Loki stack (docker-compose)..."

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Please start Docker first."
  exit 1
fi

if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed. Please install it first."
  exit 1
fi

if [ -n "$(docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps -q)" ]; then
  echo "Loki stack is already running."
  docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
else
  echo "Starting Loki and Grafana..."
  docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up -d
  echo "Waiting for Loki..."
  sleep 3
  docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
fi

echo ""
echo "Installing Loki Docker logging driver plugin on this Docker host (if missing)..."
sh "$(dirname "$0")/install-logging-plugin.sh"

echo ""
echo "Connection details:"
echo "  Loki push URL (for compose logging driver): http://127.0.0.1:3100/loki/api/v1/push"
echo "  Grafana: http://127.0.0.1:3000  (用户/密码见 .env 中 GRAFANA_ADMIN_* ，默认 admin/admin)"
echo ""
echo "storya-go deploy/docker 可设置: export LOKI_PUSH_URL=http://127.0.0.1:3100/loki/api/v1/push"
echo "Logs: docker-compose --env-file \"$ENV_FILE\" -f $COMPOSE_FILE -p $PROJECT_NAME logs -f"
