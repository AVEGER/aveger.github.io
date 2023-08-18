## K8S项目简单分析
### 1、系统环境：
1. 系统：CentOS-7-x86_64-DVD-2207-02
2. 内核版本：3.10.0-1160.71.1.el7.x86_64
3. 防火墙状态：firewalld、swap已永久关闭、selinux临时关闭
4. 其他配置：master节点--4核+4G+200G、node节点--2核+2G+40G

### 2、部署一个服务采用的步骤

**先了解namespace、deployment和service之间的关系**

1. **Namespace（命名空间）**：Namespace是Kubernetes系统中的一种资源，用于将资源分配到不同的环境中。通过使用namespace，可以将Kubernetes集群中的资源划分为不同的逻辑组，以便更好地管理、隔离和组织不同的用户、组织或项目。<u>例如，dev、test、prod等环境可以分别放在不同的namespace中。</u>
2. **Deployment（部署）**：Deployment是Kubernetes中的一种控制器，用于管理Pod的部署。它定义了要运行的Pod的数量、运行时的镜像、存储需求和其他配置选项。当您创建一个Deployment时，Kubernetes将根据Deployment的规范创建并管理相应的Pods。
3. **Service（服务）**：Service是Kubernetes中的一种抽象概念，用于将一组Pod暴露给其他Pod或外部客户端使用。Service提供了一个全局的IP地址和端口号，通过负载均衡的方式将流量分发到后端的Pod上。Service可以与Deployment配合使用，以便将部署的Pod暴露给其他Pod或客户端使用。

三者之间的关系可以理解为：

```reStructuredText
- namespace用于组织和管理资源，不要害怕创建namespace。它不会降低服务的性能，反而大多情况下会提升你的工作效率。
- deployment用于管理Pod的部署，
- 而service用于将Pod暴露给其他Pod或客户端使用。
- 它们共同构成了Kubernetes的基础架构，使得您可以更方便地管理、部署和访问应用程序。
```

##### 1. 创建 和查看Namespace

```shell
kubectl create namespace yournamespace	# yournamespace为你定义的命名空间名字
kubectl create -f namespacefile.yaml	# namespacefile.yaml为创建命名空间的配置文件

# 文件基本内容如下：
apiVersion: v1 #类型为Namespace
kind: Namespace  #类型为Namespace
metadata:
  name: yournamespace  #命名空间名称
  labels:
    name: your-lab  #pod标签
    
    
# 查看命名空间
kubectl get namespace	# 查看所有命名空间
kubectl get ns	# 简写
kubectl get namespace yournamespace	# 查看指定命名空间：yournamespace
```

2. 设置默认命名空间

```

```



##### 2. 创建 Control中的 Deployment

##### 3. 创建 Service