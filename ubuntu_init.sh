#!/bin/bash

# Ubuntu 22.04 系统初始化脚本
# 功能：系统更新、安装必要工具、配置Docker阿里云镜像、配置apt国内源、设置时区等

# 设置错误时脚本退出
set -e

# 彩色输出函数
function echo_info() {
    echo -e "\033[36m[INFO] $1\033[0m"
}

function echo_success() {
    echo -e "\033[32m[SUCCESS] $1\033[0m"
}

function echo_error() {
    echo -e "\033[31m[ERROR] $1\033[0m"
    exit 1
}

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo_error "请使用sudo或root权限运行此脚本"
fi

# 1. 系统更新
echo_info "开始更新系统..."
apt update || echo_error "apt update 失败"
apt upgrade -y || echo_error "apt upgrade 失败"
echo_success "系统更新完成"

# 2. 安装必要工具
echo_info "开始安装必要工具..."
apt install -y vim curl wget git htop net-tools unzip || echo_error "安装必要工具失败"
echo_success "必要工具安装完成"

# 3. 配置apt国内镜像源
echo_info "配置apt国内镜像源..."
# 备份原始源
cp /etc/apt/sources.list /etc/apt/sources.list.bak || echo_error "备份sources.list失败"

# 替换为阿里云源
cat > /etc/apt/sources.list << EOF
deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
EOF

# 更新源
apt update || echo_error "更新apt源失败"
echo_success "apt国内镜像源配置完成"

# # 4. 配置时区
# echo_info "设置系统时区为上海时区..."
# timedatectl set-timezone Asia/Shanghai || echo_error "设置时区失败"
# echo_success "时区已设置为Asia/Shanghai"

# 5. 安装Docker
echo_info "开始安装Docker..."
apt install -y docker.io || echo_error "安装Docker失败"

# 启用Docker服务
systemctl enable docker || echo_error "启用Docker服务失败"
systemctl start docker || echo_error "启动Docker服务失败"

# 6. 配置Docker阿里云镜像
echo_info "配置Docker阿里云镜像源..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://52696vhg.mirror.aliyuncs.com"]
}
EOF

# 重启Docker服务
systemctl daemon-reload || echo_error "daemon-reload失败"
systemctl restart docker || echo_error "重启Docker服务失败"
echo_success "Docker阿里云镜像源配置完成"

# 7. 安装Docker Compose
echo_info "安装Docker Compose..."
apt install -y docker-compose || echo_error "安装Docker Compose失败"
echo_success "Docker Compose安装完成"

# 8. 验证Docker配置
echo_info "验证Docker配置..."
docker_info=$(docker info 2>/dev/null)
if echo "$docker_info" | grep -q "52696vhg.mirror.aliyuncs.com"; then
    echo_success "Docker阿里云镜像源配置已生效"
else
    echo_error "Docker阿里云镜像源配置未生效，请检查配置"
fi

# 9. 安装其他常用软件（可根据需要启用）
# echo_info "安装Node.js..."
# curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
# apt install -y nodejs || echo_error "安装Node.js失败"
# echo_success "Node.js安装完成"

echo_success "==========================================="
echo_success "Ubuntu 22.04系统初始化和Docker配置已完成！"
echo_success "==========================================="

# 显示系统信息
echo_info "系统信息概览："
echo "操作系统: $(lsb_release -ds)"
echo "内核版本: $(uname -r)"
echo "Docker版本: $(docker --version)"
echo "Docker Compose版本: $(docker-compose --version)"
echo "当前时区: $(timedatectl | grep "Time zone" | awk '{print $3}')"