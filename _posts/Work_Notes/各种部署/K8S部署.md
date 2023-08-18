## 内网K8S项目的部署
### 1、系统环境：
1. 系统：CentOS-7-x86_64-DVD-2207-02
2. 内核版本：3.10.0-1160.71.1.el7.x86_64
3. 防火墙状态：firewalld、swap已永久关闭、selinux临时关闭
4. 其他配置：master节点--4核+4G+200G、node节点--2核+2G+40G

### 2、系统初始化
#### 2.1、关闭防火墙

```shell
systemctl stop firewalld
systemctl disable firewalld
```

#### 2.2、关闭selinux

```shell
sed -i 's/enforcing/disabled/' /etc/selinux/config	//永久关闭
reboot			//重启生效
setenforce 0	//临时关闭
```

#### 2.3、关闭swap分区

```shell
sed -ri 's/.*swap.*/#&/' /etc/fstab		//永久关闭
reboot			//重启生效
swapoff -a	//临时关闭
```

#### 2.4、设置主机名

```shell
# 设置主机名：
hostnamectl set-hostname <hostname>
设置192.168.10.81的主机名：
hostnamectl set-hostname k8s-master
设置192.168.10.82的主机名：
hostnamectl set-hostname k8s-erp
设置192.168.10.83的主机名：
hostnamectl set-hostname k8s-node2
```

#### 2.5、在master节点上添加hosts

```shell
# 在每个节点添加hosts：
cat >> /etc/hosts << EOF
192.168.10.81 k8s-master
192.168.10.82 k8s-erp
EOF
```

#### 2.6、将桥接的IPv4流量传递到iptables的链

```shell
# 在每个节点添加如下的命令：
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness = 0
EOF
```
```shell
# 加载br_netfilter模块
modprobe br_netfilter
```
```shell
# 查看是否加载
lsmod | grep br_netfilter
```
```shell
# 生效
sysctl --system 
```

#### 2.7、时间同步

```shell
# 在每个节点添加时间同步：
yum install ntpdate -y
ntpdate time.windows.com
```

#### 2.8、开启ipvs

```shell
# 在每个节点安装ipset和ipvsadm：
yum -y install ipset ipvsadm
```

```shell
# 在所有节点执行如下脚本：
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
```

```shell
# 授权、运行、检查是否加载：
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
```

```shell
# 检查是否加载：
lsmod | grep -e ipvs -e nf_conntrack_ipv4
```

### 3、节点安装Docker、K8S组件

#### 3.1、概述
- k8s默认CRI（容器运行时）为Docker，因此需要先安装Docker。

#### 3.2、安装Docker
- 安装Docker：

```shell
# 下载dockerrepo
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

# 安装docker社区版
yum -y install docker-ce-18.06.3.ce-3.el7

# 设置开机自启动和启动docker
systemctl enable docker && systemctl start docker

# 查看docker版本，确认安装
docker version
```

- 设置Docker镜像加速器：

```shell
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
```

#### 3.3、给kubernetes添加阿里云的YUM软件源

```shell
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

#### 3.4、安装kubeadm、kubelet和kubectl
- 由于版本更新频繁，这里指定版本 1.18 部署：
```shell
# 安装kubeadm、kubelet和kubectl
yum install -y kubelet-1.18.0 kubeadm-1.18.0 kubectl-1.18.0
```

```shell
# 为实现Docker使用的cgroup drvier和kubelet使用的cgroup drver一致，建议修改"/etc/sysconfig/kubelet"文件的内容：
vim /etc/sysconfig/kubelet

# 修改为
KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"
```

```shell
# 设置为开机自启动即可，由于没有生成配置文件，集群初始化后自动启动：
systemctl enable kubelet
```

#### 3.5、部署k8s的Master节点

- 部署k8s的Master节点(192.168.10.81)：

```shell
# 由于默认拉取镜像地址k8s.gcr.io国内无法访问，这里需要指定阿里云镜像仓库地址
kubeadm init \
  --apiserver-advertise-address=192.168.10.81 \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version v1.18.0 \
  --service-cidr=10.96.0.0/12 \
  --pod-network-cidr=10.244.0.0/16

# 下面是各个参数的详细解释：
--apiserver-advertise-address=192.168.10.81
这是主节点上 API 服务器的地址，所有 Kubernetes 节点都将使用此地址访问 API 服务器

--image-repository registry.aliyuncs.com/google_containers
这是用于加载 Kubernetes 容器镜像的仓库地址

--kubernetes-version v1.18.0
这是要安装的 Kubernetes 版本

--service-cidr=10.96.0.0/12
这是 Kubernetes 服务（Service）的 IP 地址范围。在这个范围内，Kubernetes 可以为服务自动分配 IP 地址

--pod-network-cidr=10.244.0.0/16
这是 Kubernetes 中所有 Pod 的网络范围。在这个范围内，Kubernetes 可以为 Pod 分配 IP 地址
```

- 运行命令后，需等待片刻加载，显示以下内容则代表成功部署

```shell
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.10.81:6443 --token hzpi5r.mtmg3yx7ah7tgazt \
    --discovery-token-ca-cert-hash sha256:7b557a2fc1441c06185b8de0b87311d58b50b0aca69993f161b8f1243b65193f
```

- 根据提示信息，在Master节点上使用kubectl工具：

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 最后，查看节点，显示有就正常
kubectl get nodes
```

#### 3.6、部署k8s的Node节点
- 在192.168.10.82和其他你需要的节点上添加如下的命令：

```shell
# 向k8s集群中添加Node节点
kubeadm join 192.168.10.81:6443 --token hzpi5r.mtmg3yx7ah7tgazt \
    --discovery-token-ca-cert-hash sha256:7b557a2fc1441c06185b8de0b87311d58b50b0aca69993f161b8f1243b65193f
    
    # IP地址为master节点的地址，整个的内容其实就时生成在部署master节点时的
```

```shell
# 显示以下内容完成部署，已加入主节点
[root@K8S-erp docker]# kubeadm join 192.168.10.81:6443 --token hzpi5r.mtmg3yx7ah7tgazt \
>     --discovery-token-ca-cert-hash sha256:7b557a2fc1441c06185b8de0b87311d58b50b0aca69993f161b8f1243b65193f
W0811 16:02:22.852797    5840 join.go:346] [preflight] WARNING: JoinControlPane.controlPlane settings will be ignored when control-plane flag is not set.
[preflight] Running pre-flight checks
        [WARNING Hostname]: hostname "k8s-erp" could not be reached
        [WARNING Hostname]: hostname "k8s-erp": lookup k8s-erp on 202.96.134.133:53: no such host
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.18" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

#### 3.7、部署CNI网络插件
- 首先在Master节点使用kubectl工具查看节点状态：

```shell
kubectl get nodes
```

- 在Master节点部署CNI网络插件(可能会失败，如果失败，请下载到本地，然后安装，我的就失败了)：

```shell
# 网络好，有魔法可以直接下载
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# 网络不行，直接访问 https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml 复制里面的代码为一个 .yml 文件，然后直接安装即可
kubectl apply -f kube-flannel.yml
```

- 查看部署CNI网络插件进度：

```shell
kubectl get pods -n kube-system		//查看安装进度
```

- 安装完成后，再次在Master节点使用kubectl工具查看节点状态：

```shell
kubectl get nodes
```

- 查看集群健康状态：

```shell
kubectl get cs

kubectl cluster-info
```

- 最后使用命令查看 K8S 是否正常运行

```shell
kubectl cluster-info
# 显示正常输出则表示已部署完成
```

