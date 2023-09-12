### Centos 7部署Gitlab
1. 直接下载gitlab-ce安装即可

```shell
下载地址：https://packages.gitlab.com/gitlab/gitlab-ce
选择合适的安装包

我的系统是Cetnos 7，选择 gitlab-ce-16.3.0-ce.0.el7.x86_64.rpm
```

2. 环境的安装

```shell
主要依赖包：
policycoreutils-python
perl
setools-libs
audit-libs-python等
```


### Docker部署Gitlab
1. 环境确定：Docker
2. 下载Gitlab镜像

```shell
docker pull gitlab/gitlab-ce:latest
```

3. 创建Gitlab存储文件夹，并运行

```shell
mkdir gitlab gitlab/etc gitlab/log gitlab/opt

docker run -id -p 3000:80 -p 9922:22 -v /root/gitlab/etc:/etc/gitlab  -v /root/gitlab/log:/var/log/gitlab -v /root/gitlab/opt:/var/opt/gitlab --restart always --privileged=true --name gitlab gitlab/gitlab-ce

'''
命令解释：
-i  以交互模式运行容器，通常与 -t 同时使用命令解释：

-d  后台运行容器，并返回容器ID

-p 3000:80  将容器内80端口映射至宿主机9980端口，这是访问gitlab的端口

-p 9922:22  将容器内22端口映射至宿主机9922端口，这是访问ssh的端口

-v ./gitlab/etc:/etc/gitlab  将容器/etc/gitlab目录挂载到宿主机./gitlab/etc目录下，若宿主机内此目录不存在将会自动创建，其他两个挂载同这个一样

--restart always  容器自启动

--privileged=true  让容器获取宿主机root权限

--name gitlab-test  设置容器名称为gitlab

gitlab/gitlab-ce  镜像的名称，这里也可以写镜像ID
'''
```

4. 进入Gitlab容器修改参数

```shell
docker exec -it gitlab /bin/bash

# 修改gitlab.rb
vi /etc/gitlab/gitlab.rb
## 加入如下
# gitlab访问地址，可以写域名。如果端口不写的话默认为80端口
external_url 'http://192.168.10.43'
# ssh主机ip
gitlab_rails['gitlab_ssh_host'] = '192.168.10.43'
# ssh连接端口
gitlab_rails['gitlab_shell_ssh_port'] = 9922

# 让配置生效
gitlab-ctl reconfigure

### 注意不要重启，/etc/gitlab/gitlab.rb文件的配置会映射到gitlab.yml这个文件，由于咱们在docker中运行，在gitlab上生成的http地址应该是http://101.133.225.166:3000,所以，要修改下面文件

# 修改http和ssh配置
vi /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml

  gitlab:
    host: 192.168.10.43
    port: 3000 # 这里改为3000
    https: false


# 重启
gitlab-ctl restart
# 退出容器
exit
```

5. 测试访问和注意事项

```shell
# 机器配置要大于4g，否则很容易启动不了，报502
http://192.168.10.43:3000/

# 第一次访问，会让修改root密码
# 修改后以root用户登录即可
```

### K8S 部署Gitlab

### Gitlab自签名证书

#### 建立认证目录，存放证书文件

```shell
mkdir -p /etc/gitlab/ssl
chmod 700 /etc/gitlab/ssl
```

#### 创建证书文件具体步骤
1. 从原始证书中提取私钥,一般使用自签名证书是没有的。

```shell
openssl rsa -in /etc/gitlab/ssl/gitlab.bybcs.com.original -out /etc/gitlab/ssl/gitlab.bybcs.com.key
```

2. RSA 密钥对和证书签名请求（CSR）：使用 OpenSSL 工具生成一个新的 RSA 密钥对，并创建一个证书签名请求（CSR）。

```shell
openssl req -nodes -newkey rsa:2048 -keyout gitlab.bybcs.com.key -out gitlab.bybcs.com.csr
```

3. 自签名证书：从证书签名请求（CSR）中生成一个自签名的 x509 证书

```shell
openssl x509 -req -days 36500 -in /etc/gitlab/ssl/gitlab.bybcs.com.csr -signkey /etc/gitlab/ssl/gitlab.bybcs.com.key -out /etc/gitlab/ssl/gitlab.bybcs.com.crt
```

4. 移除证书请求文件并设置文件权限

```shell
rm -v /etc/gitlab/ssl/gitlab.bybcs.com.csr
chmod 600 /etc/gitlab/ssl/gitlab.bybcs.com.*
```

5. 复制证书到gitlab目录

```shell
cp /etc/gitlab/ssl/gitlab.bybcs.com.crt /etc/gitlab/trusted-certs/
```

#### 修改配置文件
1. 修改文件gitlab.rb
```shell
vi /etc/gitlab/gitlab.rb

#修改下列值
external_url 'https://gitlab.bybcs.com'
letsencrypt['enable'] = false   #有的可能键是entsencrypt
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = '/etc/gitlab/ssl/gitlab.bybcs.com.crt'
nginx['ssl_certificate_key'] = '/etc/gitlab/ssl/gitlab.bybcs.com.key'
```

2. gitlab更新配置和重新启动

```shell
gitlab-ctl reconfigure
gitlab-ctl restart
```
