# 本机跑 storya-go（不改仓库里的 docker / yaml）

已在 `~/work/docker` 做过的事：

1. **`.env`**：`REDIS_PASSWORD`、`RABBITMQ_DEFAULT_PASS`、`POSTGRES_PASSWORD` 与仓库里 `deploy/docker/configs` 中 Redis / Rabbit / Postgres DSN 的凭据一致。
2. **RabbitMQ**：对已有数据卷执行了 `rabbitmqctl change_password admin …`（仅改运行中实例密码，与 `.env` 一致）。
3. **Redis**：`docker compose up -d --force-recreate`（`redis/` 目录）以载入新 `REDIS_PASSWORD`。
4. **Postgres**：`ALTER USER sumeng_test …` 使本地库密码与 DSN 中密码一致。

## 必须一步：Postgres 主机名 → 本机

应用 DSN 里的主机名仍是 **阿里云 RDS**（`pc-bp1cw5xb81p2o797c.rwlb.rds.aliyuncs.com`）。在未改仓库配置的前提下，需要让该名字解析到 **本机** 上的 `postgresql` 容器（端口已映射 `5432:5432`）。

在终端执行（会提示输入本机管理员密码）：

```bash
bash ~/work/docker/storya-pg-hosts.sh
```

脚本会向 `/etc/hosts` 追加一行：`127.0.0.1` + 上述 RDS 主机名。若你已手动加过，可跳过。

然后重启 storya 栈：

```bash
cd /path/to/storya-go/deploy/docker
docker compose restart
```

## 可选：worker 里写死的其它 IP

若仍连不上 **scheduler / Rabbit** 等配置里指向的其它公网 IP，需要单独处理（改对方服务、或 VPN、或自行权衡是否再写 `/etc/hosts` 把某 IP 指到本机）。**不要随意**把业务 IP 指到 `127.0.0.1`，以免影响其它依赖该 IP 的程序。
