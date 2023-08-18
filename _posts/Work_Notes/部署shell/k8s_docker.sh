#!/bin/bash
# --------LC--------
# 安装 docker-ce-18.06.3.ce-3.el7 一套
# Data:2023.08.17
# --------LC---------
if rpm -qa | grep docker
then
    # 移除掉旧的版本
    sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

    # 删除所有旧的数据
    sudo rm -rf /var/lib/docker
else
    echo '开始安装docker-ce-18.06.3.ce-3.el7'
fi

# 下载dockerrepo
sudo wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

# 安装docker社区版
sudo yum -y install docker-ce-18.06.3.ce-3.el7

# 设置开机自启动和启动docker
sudo systemctl enable docker && systemctl start docker

# 查看docker版本，确认安装
if sudo docker version
then
    clear
    echo 'Docker 安装成功'
else
    echo 'Docker安装失败，请检查网络！'
    exit 1
fi

# 确认docker文件夹是存在的，不存在就创建一个
sudo mkdir -p /etc/docker

# 写入文件设置docker镜像源加速
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "exec-opts": ["native.cgroupdriver=systemd"],	
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}
EOF

# 重新加载一下镜像配置文件
sudo systemctl daemon-reload

# 重启docker服务
sudo systemctl restart docker