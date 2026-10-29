## 简介

在本机用 docker compose 快速启停常用中间件。账号密码直接写在各目录的 `docker-compose.yml`，仅供本机开发使用。

## 安装命令

```bash
sh make-link.sh   # 在 GOBIN 下创建 start / stop 命令
```

## 使用

```bash
start              # 交互菜单，可多选，all 为全部
start pg redis     # 直接启动指定服务
stop pg redis
```

单个服务也可以在目录内执行 `./start.sh` / `./stop.sh`（等价于 `docker compose up -d` / `down`，数据保留在 `data/`）。

| 服务（目录） | 容器名 | 版本 | 地址 | 账号 / 密码 |
|---|---|---|---|---|
| mysql | mysql | 9.7 LTS | localhost:3306 | root / root |
| pg | postgresql | PostgreSQL 18 | localhost:5432 | postgres / postgres |
| redis | redis | 8.10 | localhost:6379 | 密码 redis |
| rabbitmq | rabbitmq | 4.4 | localhost:5672，管理界面 http://localhost:15672 | admin / admin |
| mongodb | mongodb | 9.0 | localhost:27017 | root / root |
| kafka | kafka, akhq | 4.4 + AKHQ | 宿主机 localhost:9092，容器 host.docker.internal:29092，AKHQ http://localhost:8093 | 无 |
| es | elasticsearch, kibana | Elasticsearch / Kibana 9.5 | http://localhost:9200，Kibana http://localhost:5601 | 无（关闭了安全认证） |
| qdrant | qdrant | 1.20 | REST localhost:6333，gRPC localhost:6334 | 无 |
| chromadb | chromadb | 1.5 | http://localhost:9100 | 无 |
| loki | loki, grafana | Loki 3.7 / Grafana 13 | Loki http://localhost:3100，Grafana http://localhost:3000 | admin / admin |
| outback |  | OrbStack 虚拟机 | | |

## Loki 日志插件

`loki/start.sh` 会在宿主机安装 Loki Docker 日志插件（版本可用环境变量 `LOKI_DOCKER_DRIVER_VERSION` 覆盖，默认 `3.7.9`）。业务 compose 可以用 `logging.driver: loki`，推送地址是 `http://127.0.0.1:3100/loki/api/v1/push`。
`loki/stop.sh` 不会卸载插件；如需卸载：`docker plugin disable loki --force && docker plugin rm loki`。
