#!/bin/bash
# 本机 docker 服务停止，逻辑见 start.sh
exec bash "$(dirname "$(readlink -f "$0")")/start.sh" --stop "$@"
