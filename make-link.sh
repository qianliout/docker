#!/bin/bash
# 获取GOBING
GOBIN=$(go env GOBIN)
echo "GOBIN: $GOBIN"

# 检查GOBIN是否存在
if [ -z "$GOBIN" ]; then
  echo "GOBIN is not set"
  exit 1
fi

# 检查GOBIN是否存在
if [ ! -d "$GOBIN" ]; then
  echo "GOBIN does not exist"
  exit 1
fi

ln -s ~/work/docker/start.sh $GOBIN/start
ln -s ~/work/docker/stop.sh $GOBIN/stop
