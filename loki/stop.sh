#!/bin/bash

# 停止 Loki Compose 栈（不移除已安装的 Docker 日志插件）
set -e
cd "$(dirname "$0")"
ROOT="$(cd .. && pwd)"
ENV_FILE="$ROOT/.env"
COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="loki"

dc() {
  if [ -f "$ENV_FILE" ]; then
    docker-compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" -p "$PROJECT_NAME" "$@"
  else
    docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" "$@"
  fi
}

echo "Stopping Loki stack ..."
if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed."
  exit 1
fi

dc down
echo "Loki stack stopped. (Docker 日志插件 loki 仍保留；卸载见 README)"
