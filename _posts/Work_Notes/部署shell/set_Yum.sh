#!/bin/bash
# --------LC--------
# 更换阿里镜像源脚本
# Data:2023.08.17
# --------LC---------
if sudo rpm -qa | grep wget;
then
    sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back
    sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    sudo yum clean all && sudo yum makecache
else
    if [ sudo yum install -y wget = 1 ]
	then
        sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back
        sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
        sudo yum clean all && sudo yum makecache
	else
		echo '错误！请检查网络'
	fi
fi
