#!/bin/bash
set_hostname=$1
if [[ ${set_hostname} == "master" || ${set_hostname} == "node" ]]
then
  echo "当前节点为${set_hostname},开始安装！"
else
  echo "请输入正确的当前节点类型，master/node。"
  exit 1
fi

sudo hostnamectl set-hostname ${set_hostname}
#关闭防火墙
if [[ $(firewall-cmd --state) != running ]]
then
  echo '防火墙已关闭'
else
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
fi
#关闭swap
sed -ri 's/.*swap.*/#&/' /etc/fstab
#临时关闭eslinux
setenforce 0

sudo cat > /etc/sysctl.d/k8s.conf << EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    vm.swappiness = 0
EOF

# 加载br_netfilter模块
sudo modprobe br_netfilter

# 查看是否加载
if sudo lsmod | grep br_netfilter
then
    echo 'br_netfilter模块加载成功'
    # 生效
    sudo sysctl --system
else
    echo 'br_netfilter模块加载失败，请检查是否安装！'
    exit 1
fi

# 在每个节点添加时间同步：
if sudo rpm -qa | grep ntpdate;
then
    sudo ntpdate time.windows.com
else
    if sudo yum install ntpdate -y = 1
	then
        sudo ntpdate time.windows.com
	else
		echo '错误！请检查网络'
	fi
fi

# 在每个节点安装ipset和ipvsadm：
if sudo rpm -qa | grep ipset && sudo rpm -qa | grep ipvsadm;
then
    sudo yum -y install ipset ipvsadm
else
    echo '已安装'
fi

# 在所有节点执行如下脚本：
sudo cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF

# 授权、运行、检查是否加载：
sudo chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

# 检查是否加载：
sudo lsmod | grep -e ipvs -e nf_conntrack_ipv4

if [ ${set_hostname} = 'master' ]
then
    echo '请手动修改host文件,格式为地址 + 主机名
    例如：
sudo cat >> /etc/hosts << EOF
    192.168.10.81 k8s-master
    192.168.10.82 k8s-node1
EOF'
else
    echo '非master节点无需安装！'
fi

echo '
完成基本环境部署！--***请重启***--
重启后运行：setenforce 0   临时关闭eslinux
'
