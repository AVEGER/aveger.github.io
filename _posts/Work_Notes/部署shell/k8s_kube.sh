#!/bin/bash
# --------LC--------
# 安装 K8S-1.18.0一套
# Data:2023.08.17
# --------LC---------
if [[ $1 == "master" || $1 == "node" ]]
then
  echo "当前节点为$1,开始安装！"
else
  echo "请输入正确的当前节点类型，master/node。"
  exit 1
fi

if docker version
then
    echo '
    #####################
    开始安装 kubelet-1.18.0 kubeadm-1.18.0 kubectl-1.18.0
    #####################
    '
    sudo systemctl start docker
else
    echo '请先安装docker-ce-18.06.3.ce-3.el7'
fi

cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 安装kubeadm、kubelet和kubectl
if rpm -qa | grep kubelet-1.18.0
then
    echo '-----------已安装kubelet！-----------'
else
    sudo yum install -y kubelet-1.18.0 kubeadm-1.18.0 kubectl-1.18.0
    echo '-----------安装成功-----------'
fi


# 为实现Docker使用的cgroup drvier和kubelet使用的cgroup drver一致，建议修改"/etc/sysconfig/kubelet"文件的内容：
sudo cp /etc/sysconfig/kubelet /etc/sysconfig/kubelet.back
if sudo grep 'KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"' /etc/sysconfig/kubelet
then
    return 1
elif sudo grep 'KUBELET_EXTRA_ARGS' /etc/sysconfig/kubelet
then
    count=$(grep -n 'KUBELET_EXTRA_ARGS' /etc/sysconfig/kubelet | awk -F: '{print $1}')
    sudo cat /etc/sysconfig/kubelet | sed "${count}s/.*/KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"/" > /etc/sysconfig/kubelet_new
    sudo rm -rf /etc/sysconfig/kubelet && mv /etc/sysconfig/kubelet_new /etc/sysconfig/kubelet
else
    echo '---没有kubelet文件---,请检查kubeadm、kubelet和kubectl安装情况'
    exit 1
fi


# 设置为开机自启动即可，由于没有生成配置文件，集群初始化后自动启动：
systemctl enable kubelet

if [ $1 == 'master' ]
then
    # 由于默认拉取镜像地址k8s.gcr.io国内无法访问，这里需要指定阿里云镜像仓库地址
    kubeadm init \
        --apiserver-advertise-address=192.168.10.81 \
        --image-repository registry.aliyuncs.com/google_containers \
        --kubernetes-version v1.18.0 \
        --service-cidr=10.96.0.0/12 \
        --pod-network-cidr=10.244.0.0/16

    echo '
    ----------------------------------------------------------
    ###############以上是需要部署到node节点的信息##################
    ###再次查看的命令kubeadm token create --print-join-command###
    ----------------------------------------------------------


    '
    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    # 最后，查看节点，显示有就正常
    kubectl get nodes
    echo '
    ----------------------------------------------------------
    --------   kubectl get nodes查看节点，显示有就正常   ---------
    ----------------------------------------------------------
    '

    echo "最后还需要部署CNI插件，不然可能会在状态上会一直显示 Notready
    部署命令：
    # 网络好，有魔法可以直接下载
    wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

    # 网络不行，直接访问 https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml 复制里面的代码为一个 .yml 文件，然后直接安装即可
    kubectl apply -f kube-flannel.yml
    "
elif [ $1 == 'node' ]
then
    echo '
    ----------------------------------------------------------
        在master节点部署时，找到类似以下内容。复制执行即可
        以下为举例，每个人的都是不同的：
        kubeadm join 192.168.10.81:6443 --token hzpi5r.mtmg3yx7ah7tgazt \
        --discovery-token-ca-cert-hash sha256:7b557a2fc1441c06185b8de0b87311d58b50b0aca69993f161b8f1243b65193f

        IP地址为master节点的地址，整个的内容其实就时生成在部署master节点时的
    ----------------------------------------------------------
    '
else
    echo '请输入master或node节点的值'
fi
