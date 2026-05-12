## 简介

快速在开发电脑上启动/停止docker服务

## 使用
### 建立软连接
```bash
sh make-link.sh
```
这样就会在GOBIN目录下安装start和stop命令

设置BASE_DIR
改start.sh 和 stop.sh 里的BASE_DIR,改成当前项目目录

```bash
BASE_DIR="$HOME/work/docker"
```

### 启动
```bash
./start.sh
```

### Storya / 常用中间件（PostgreSQL + Redis + RabbitMQ）

1. **环境变量（勿提交 `.env`）**  
   ```bash
   cp "$HOME/work/docker/.env.example" "$HOME/work/docker/.env"
   ```  
   填写 `POSTGRES_*`、`REDIS_PASSWORD`、`RABBITMQ_DEFAULT_*`。各 `docker-compose` 通过 `env_file: ../.env` 引用，密码不写进 compose 文件。

2. **启动**（任选）  
   ```bash
   "$HOME/work/docker/start-middleware.sh"
   # 或分别
   sh "$HOME/work/docker/pg/start.sh"
   sh "$HOME/work/docker/redis/start.sh"
   sh "$HOME/work/docker/rabbitmq/start.sh"
   ```  
   交互菜单：`./start.sh`（已含 pg、redis、rabbitmq）。

3. **与 storya-go 对齐**：在 storya 仓库复制 `configs/.env.example` 为根目录或 `configs/.env`，填写 `STORYA_*`（与 `~/work/docker/.env` 中密码、库名一致）。YAML 内使用 `${STORYA_*}`，由 `config.Load` 从 `.env` 展开。

4. **deploy/docker 容器**：复制 `storya-go/deploy/docker/.env.example` 为同目录 `.env`，供 compose 注入进程环境。

修改 PG/Rabbit 账号密码后，可能需删除对应服务目录下 `data/` 再 `up`。`deploy/migrations/` 多为增量 SQL，空库需基线后再迁移。

### 停止
```bash
./stop.sh
```

## 注意
1. 请确保在开发电脑上安装了docker和docker-compose