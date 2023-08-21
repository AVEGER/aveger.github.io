#!/bin/bash
# --------LC--------
# 更换阿里镜像源脚本
# Data:2023.08.17
# --------LC---------
if sudo rpm -qa | grep wget;
then
    if [ -e '/etc/yum.repos.d/CentOS-Base.repo.back' ]
    then
      echo '已更新，无需重复操作'
      exit 1
    else
      sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back
      sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
      sudo yum clean all && sudo yum makecache
    fi
else
    sudo yum install -y wget
    if sudo rpm -qa | grep wget
	  then
      sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back
      sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
      sudo yum clean all && sudo yum makecache
	  else
		  echo '错误！请检查网络'
		  exit 1
	  fi
fi
