#!/bin/bash
# --------LC--------
# 删除K8S
# Data:2023.08.17
# --------LC---------
#停止相关服务
sudo systemctl stop kubelet

sudo systemctl stop etcd

sudo systemctl stop docker

#卸载k8s
sudo kubeadm reset -f

#删除k8s相关目录
modprobe -r ipip
lsmod
sudo rm -rf ~/.kube/ && rm -rf /etc/kubernetes/ && rm -rf /etc/systemd/system/kubelet.service.d && rm -rf /etc/systemd/system/kubelet.service 
sudo rm -rf /usr/bin/kube* && rm -rf /etc/cni && rm -rf /opt/cni && rm -rf /var/lib/etcd && rm -rf /var/etcd

#卸载k8s相关程序
sudo yum -y remove kube*

#更新镜像
sudo yum clean all
sudo yum -y update
sudo yum makecache

echo '
-------------------------------------
------------完成K8S清除--------------
-------------------------------------
'