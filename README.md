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

### 停止
```bash
./stop.sh
```

## 注意
1. 请确保在开发电脑上安装了docker和docker-compose