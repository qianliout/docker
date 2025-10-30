#!/bin/bash

# 定义服务基础路径
BASE_DIR="$HOME/work/docker"

# 定义服务列表（使用普通数组替代关联数组）
SERVICES=("mysql" "redis" "harbor" "rabbitmq" "nginx" "kafka" "es" "qdrant" "mongodb" "chromadb" "pg" "outback")

# 显示启动菜单
show_menu() {
  echo "======================================"
  echo "          服务启动脚本"
  echo "======================================"
  echo "请选择要启动的服务 (可多选，用空格分隔):"
  echo "all     - 启动全部服务"
  echo "mysql   - 启动MySQL"
  echo "redis   - 启动Redis"
  echo "rabbitmq - 启动RabbitMQ"
  echo "nginx   - 启动Nginx"
  echo "kafka   - 启动Kafka"
  echo "es      - 启动Elasticsearch"
  echo "qdrant  - 启动Qdrant"
  echo "mongodb - 启动MongoDB"
  echo "chromadb - 启动Chromadb"
  echo "pg      - 启动Pg"
  echo "outback - 启动OrbStack outback 虚拟机"
  echo "harbor - 启动harbor"
  echo "======================================"
  read -p "请输入选择: " input_services

  # 如果没有输入任何内容
  if [ -z "$input_services" ]; then
    echo "未选择任何服务!"
    exit 1
  fi

  # 将输入转换为数组
  IFS=' ' read -ra selected_services <<<"$input_services"

  # 处理选择的服务
  process_selected_services
}

# 处理选择的服务
process_selected_services() {
  local services_to_execute=()

  # 检查是否选择了all
  for service in "${selected_services[@]}"; do
    if [ "$service" = "all" ]; then
      # 如果选择了all，则添加所有服务
      services_to_execute=("${SERVICES[@]}")
      break
    fi
  done

  # 如果没有选择all，则添加选中的服务
  if [ ${#services_to_execute[@]} -eq 0 ]; then
    for service in "${selected_services[@]}"; do
      if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        services_to_execute+=("$service")
      else
        echo "警告: 未知服务 '$service'，已跳过"
      fi
    done
  fi

  # 执行操作
  if [ ${#services_to_execute[@]} -gt 0 ]; then
    execute_services "${services_to_execute[@]}"
  else
    echo "没有有效的服务选择!"
    exit 1
  fi
}

# 执行启动服务
execute_services() {
  local services=("$@")

  echo ""
  echo "开始启动以下服务: ${services[*]}"
  echo "--------------------------------------"

  for service in "${services[@]}"; do
    echo -n "启动 $service... "

    # 特殊处理 outback 服务
    if [ "$service" = "outback" ]; then
      echo "执行: orbctl start outback"
      if orbctl start outback; then
        echo "成功"
      else
        echo "失败"
      fi
      continue
    fi

    # 处理其他服务的启动脚本
    local script_path="$BASE_DIR/$service/start.sh"
    echo "调试: 脚本路径 = $script_path"

    # 检查脚本是否存在
    if [ ! -f "$script_path" ]; then
      echo "失败: 启动脚本不存在 - $script_path"
      continue
    fi

    # 检查脚本是否有执行权限
    if [ ! -x "$script_path" ]; then
      chmod +x "$script_path"
    fi

    # 切换到服务目录执行脚本
    local service_dir="$BASE_DIR/$service"
    if [ -d "$service_dir" ]; then
      cd "$service_dir" || {
        echo "失败: 无法切换到目录 $service_dir"
        continue
      }
    fi

    # 执行启动脚本
    if sh "$script_path"; then
      echo "成功"
    else
      echo "失败"
    fi
  done

  echo "--------------------------------------"
  echo "启动操作完成!"
}

# 检查基础目录是否存在
if [ ! -d "$BASE_DIR" ]; then
  echo "错误: 基础目录不存在: $BASE_DIR"
  echo "请修改脚本中的 BASE_DIR 变量为正确的路径"
  exit 1
fi

# 显示菜单并执行
show_menu
