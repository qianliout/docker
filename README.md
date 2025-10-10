## 简介

快速在开发电脑上启动/停止docker服务

## 使用
### 建立软连接

```bash
sh make-link.sh
```
这样就会在GOBIN目录下安装start和stop命令

### 启动
```bash
start
```

### 停止
```bash
stop
```

## 注意
1. 请确保在开发电脑上安装了docker和docker-compose