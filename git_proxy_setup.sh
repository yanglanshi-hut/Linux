#!/bin/bash

# GitHub连接问题解决脚本
# 此脚本提供多种方法来解决GitHub的连接问题

echo "GitHub连接问题解决工具"
echo "======================="
echo ""

# 方法1: 设置HTTP代理
setup_http_proxy() {
    echo "请输入HTTP代理地址 (例如: 127.0.0.1:7890):"
    read proxy_address
    
    # 设置HTTP和HTTPS代理
    git config --global http.proxy "http://$proxy_address"
    git config --global https.proxy "http://$proxy_address"
    
    echo "代理已设置为: $proxy_address"
    echo "您可以使用以下命令查看当前代理设置:"
    echo "git config --global --get http.proxy"
    echo "git config --global --get https.proxy"
}

# 方法2: 清除代理设置
clear_proxy() {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    echo "已清除所有代理设置"
}

# 方法3: 更改远程URL为SSH
change_to_ssh() {
    echo "请确认您已经设置好SSH密钥并添加到GitHub账户"
    echo "当前远程仓库URL:"
    git remote -v
    
    echo "请输入远程仓库名称 (通常是origin):"
    read remote_name
    
    current_url=$(git remote get-url $remote_name)
    # 从HTTPS URL提取用户名和仓库名
    if [[ $current_url == https://github.com/* ]]; then
        repo_path=${current_url#https://github.com/}
        ssh_url="git@github.com:$repo_path"
        
        git remote set-url $remote_name "$ssh_url"
        echo "已将远程URL更改为: $ssh_url"
    else
        echo "当前URL不是GitHub HTTPS URL,无法自动转换"
    fi
}

# 方法4: 尝试使用github.global.ssl.fastly.net
use_fastly() {
    git config --global url."https://github.global.ssl.fastly.net/".insteadOf "https://github.com/"
    echo "已配置使用fastly CDN代替直接连接GitHub"
}

# 方法5: 设置连接超时时间更长
extend_timeout() {
    git config --global http.lowSpeedLimit 0
    git config --global http.lowSpeedTime 999999
    echo "已增加Git的连接超时时间"
}

# 方法6: 检查当前设置
check_settings() {
    echo "当前Git代理设置:"
    git config --global --get http.proxy
    git config --global --get https.proxy
    
    echo "当前远程仓库URL:"
    git remote -v
}

# 主菜单
while true; do
    echo ""
    echo "请选择一个选项:"
    echo "1) 设置HTTP代理"
    echo "2) 清除代理设置"
    echo "3) 将远程URL更改为SSH"
    echo "4) 使用GitHub CDN"
    echo "5) 延长连接超时时间"
    echo "6) 检查当前设置"
    echo "q) 退出"
    read -p "您的选择: " choice
    
    case $choice in
        1) setup_http_proxy ;;
        2) clear_proxy ;;
        3) change_to_ssh ;;
        4) use_fastly ;;
        5) extend_timeout ;;
        6) check_settings ;;
        q) exit 0 ;;
        *) echo "无效的选择,请重试" ;;
    esac
done