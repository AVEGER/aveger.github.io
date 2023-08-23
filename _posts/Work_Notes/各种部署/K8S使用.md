### 将 Docker Compose 文件转换为 Kubernetes 资源
- 使用Kompose来把docker-compose.yaml文件转换为kubectl可运行的文件

```shell
举例：
$ kompose convert -f docker-compose.yaml

$ kubectl apply -f .

$ kubectl get po
NAME                            READY     STATUS              RESTARTS   AGE
frontend-591253677-5t038        1/1       Running             0          10s
redis-master-2410703502-9hshf   1/1       Running             0          10s
```
1. 首先安装kompose

```shell
sudo yum -y install kompose  # Centos直接安装即可
yum install -y epel-release  # 可能需要先安装epel，linux企业额外安装包
```

2. 使用kompose
