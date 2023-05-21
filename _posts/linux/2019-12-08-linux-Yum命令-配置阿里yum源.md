---
title: Linux---配置阿里云yum源
tags: Linux
---

## 配置阿里云yum源
5步配置完成阿里云yum源<!--more-->
1. 打开centos的yum文件夹
输入命令cd /etc/yum.repos.d/
2. 用wget下载repo文件
输入命令wget http://mirrors.aliyun.com/repo/Centos-7.repo
如果wget命令不生效，说明还没有安装wget工具，输入yum -y install wget 回车进行安装。
当前目录是/etc/yum.repos.d/，刚刚下载的Centos-7.repo也在这个目录上
3. 备份系统原来的repo文件
cp CentOs-Base.repo CentOs-Base.repo.bak

4. 替换系统原理的repo文件
    mv Centos-7.repo CentOs-Base.repo
    即重命名 Centos-7.repo -> CentOs-Base.repo
5. 执行yum源更新命令
    yum clean all
    yum makecache
    yum update
    依次执行上述三条命令更新yum源完成。