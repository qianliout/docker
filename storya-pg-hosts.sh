#!/usr/bin/env bash
# storya-go 的 DSN 使用阿里云 RDS 主机名；不改仓库配置时，让该名字解析到本机 Postgres。
# 执行一次（需管理员写 /etc/hosts）：
#   bash ~/work/docker/storya-pg-hosts.sh

set -euo pipefail
RDS_HOST="${STORYA_PG_RDS_HOST:-pc-bp1cw5xb81p2o797c.rwlb.rds.aliyuncs.com}"
LINE="127.0.0.1 ${RDS_HOST}"

if grep -q "${RDS_HOST}" /etc/hosts 2>/dev/null; then
  if grep "${RDS_HOST}" /etc/hosts | grep -q '^127\.0\.0\.1'; then
    echo "OK: /etc/hosts already maps ${RDS_HOST} -> 127.0.0.1"
    exit 0
  fi
  echo "error: /etc/hosts contains ${RDS_HOST} but not as 127.0.0.1 — fix manually." >&2
  exit 1
fi

echo "Adding to /etc/hosts: ${LINE}"
sudo sh -c "printf '%s\n' '${LINE}' >> /etc/hosts"
echo "Done. Flush DNS cache if needed (e.g. dscacheutil -flushcache; sudo killall -HUP mDNSResponder)."
