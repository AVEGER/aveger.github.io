#!/bin/bash
# --------LC--------
# 更换阿里镜像源脚本
# Data:2023.08.17
# --------LC---------

# 使用ping命令测试网络连接
result=$(ping -c 1 www.baidu.com)

# 检查ping命令的退出状态码
if [ $? -eq 0 ]; then
    echo "网络连接正常，开始设置阿里yum源"
else
    echo "网络连接异常，请检查/etc/syscofnig/network-script/下的接口文件！"
fi

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
      echo "
      ---------------
      设置完成，开始更新软件
      ---------------
      "
      sudo yum update -y
    fi
else
    sudo yum install -y wget
    if sudo rpm -qa | grep wget
	  then
      sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back
      sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
      sudo yum clean all && sudo yum makecache
      echo "
      ---------------
      设置完成，开始更新软件
      ---------------
      "
      sudo yum update -y
	  else
		  echo '错误！请检查网络'
		  exit 1
	  fi
fi
