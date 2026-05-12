#!/bin/bash
# Docker Engine 的 Loki 日志驱动插件（非容器）。架构需与宿主机一致。
set -e
if docker plugin ls --format '{{.Name}}' 2>/dev/null | grep -q '^loki'; then
  echo "Loki Docker 日志插件已安装（loki）。"
  exit 0
fi

VERSION="${LOKI_DOCKER_DRIVER_VERSION:-3.7.0}"
ARCH=$(uname -m)
case "$ARCH" in
arm64 | aarch64) PLUGIN_TAG="${VERSION}-arm64" ;;
x86_64 | amd64) PLUGIN_TAG="${VERSION}-amd64" ;;
*)
  echo "错误: 不支持的架构: $ARCH"
  exit 1
  ;;
esac

echo "安装 Loki 日志插件: grafana/loki-docker-driver:${PLUGIN_TAG}"
docker plugin install "grafana/loki-docker-driver:${PLUGIN_TAG}" --alias loki --grant-all-permissions
echo "安装完成。推送地址示例: http://127.0.0.1:3100/loki/api/v1/push"
