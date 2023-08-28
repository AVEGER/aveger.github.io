#!/bin/bash

# 设置ping的目标IP地址和间隔时间（秒）
target_ip="10.20.10.1"
interval="1"

# 循环ping，直到中断或ping通
while true; do
    echo "开始ping $target_ip..."
    result=$(ping -c 1 $target_ip)
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "ping成功，$target_ip 可用"
        break
    else
        echo "ping失败，$target_ip 不可用"
    fi
    sleep $interval
done
