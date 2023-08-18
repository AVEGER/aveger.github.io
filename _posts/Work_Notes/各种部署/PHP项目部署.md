### PHP项目部署

- 环境：Centos 7

- 内核：3.10.0-1062.el7.x86_64 #1 SMP Wed Aug 7 18:08:02 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
- 镜像源：阿里源

#### 一、Centos下安装Apache

```shell
sudo yum install httpd

Apache的操作命令
systemctl start httpd	//启动apache
systemctl stop httpd	//停止apache
systemctl restart httpd //重启apache
systemctl enable httpd	//设置apache开机启动

防火墙设置，保证服务器能被访问；Http使用80端口，Https使用443端口。
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=80/tcp --permanent		//开放80端口
systemctl restart firewalld					//重启防火墙服务使其生效
```

#### 二、Apache服务的配置文件说明

##### 1、配置文件的位置

| 配置文件               | 存放位置                       |
| ---------------------- | ------------------------------ |
| 服务目录               | /etc/httpd                     |
| 主配置文件             | /etc/httpd/conf/httpd.conf     |
| 虚拟主机的配置文件目录 | /etc/httpd/conf.d              |
| 基于用户的配置文件     | /etc/httpd/conf.d/userdir.conf |
| 日志文件目录           | /etc/httpd/logs                |
| 默认的网站数据目录     | /var/www/html                  |

##### 2、主配置文件的重要参数

主配置文件：/etc/httpd/conf/httpd.conf

| 参数        | 作用                 | 参数           | 作用             |
| ----------- | -------------------- | -------------- | ---------------- |
| ServerRoot  | 服务目录             | ServerName     | 网站服务器的域名 |
| Listen      | 监听的IP地址与端口号 | DocumentRoot   | 默认网站数据目录 |
| User        | 运行服务的用户       | Directory      | 文件目录的权限   |
| Group       | 运行服务的用户组     | DirectoryIndex | 默认的索引页页面 |
| ServerAdmin | 管理员邮箱           | ErrorLog       | 错误日志文件     |

#### 三、PHP安装

PHP如果没有安装使用以下命令：

```shell
sudo yum install php php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash

sudo systemctl restart httpd		//安装完成后需要重启Apache服务

php --version		//查看安装版本
```

打开浏览器，输入服务器的IP地址即可看到Apache页面

```php
在 /var/www/html/ 目录下编辑文件test.php为以下内容
<?php
phpinfo();
?>
```

浏览器打开地址 http://localhost/test.php 如果显示如下页面，说明php安装成功

![1691655367488](I:\LC\Tpora图片\1691655367488.png)

#### 四、mysql安装

- 正常情况下可直接安装mysql服务器: 

```shell
sudo yum -y install mysql-community-server
```

- 否则先下载并安装MySLQ官方的yum respository： 

```shell
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
sudo yum -y install mysql57-community-release-el7-10.noarch.rpm
```

- 可能的报错：

```shell
mysql-community-common-5.7.43-1.el7.x86_64.rpm 的公钥尚未安装

 失败的软件包是：mysql-community-common-5.7.43-1.el7.x86_64
 GPG  密钥配置为：file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
 
 # 解决，然后重新安装
 rpm -import http://repo.mysql.com/RPM-GPG-KEY-mysql-2022
```

-  运行mysql： 

```shell
sudo systemctl start mysqld		//启动mysql

sudo systemctl status mysqld	//查看mysql运行状态

# 查看初始密码，然后进入mysql
 sudo grep "password" /var/log/mysqld.log
 
 [root@localhost ~]# grep "password" /var/log/mysqld.log
2023-08-15T10:23:24.798672Z 1 [Note] A temporary password is generated for root@localhost: as<c2asp/B<if
2023-08-15T10:24:49.507047Z 2 [Note] Access denied for user 'root'@'localhost' (using password: NO)
 
mysql -uroot -p	//输入上面找到的初始密码：as<c2asp/B<if
```

-  修改初始密码和创建你需要的数据、账号等

```mysql
# 修改root密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewPassWord1.';	//注意密码复杂程度 

# 创建数据库
create database mysql_name;

# 查看数据库
SHOW DATABASES;
```



#### 四、部署PHP项目

- 保证项目和php的版本是兼容的，不同版本会造成项目无法运行

- 把项目直接丢在，/var/www/http 文件夹下即可正常访问

```shell
php --version		//查看php版本
```



##### 我的项目需要安装php7.0

1. 首先卸载原有php

```
php --version 或 php -v		//检查是否有php
yum remove php common 		//卸载原有php
```

2. 尝试直接安装php7.0

```shell
yum -y install php71w php71w-cli php71w-devel php71w-embedded php71w-fpm php71w-gd php71w-mbstring php71w-mysqlnd php71w-opcache php71w-pdo php71w-xml php71w-mcrypt php71w-process php71w-odbc php71w-phpdbg php71w-opcache php71w-mcrypt  php71w-common		//我的项目需要安装php7.0
```

3. 无法安装，显示没有包后，首先安装WEBTATIC源

```shell
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# 可能出现的报错
错误：依赖检测失败：
        epel-release >= 7 被 webtatic-release-7-3.noarch 需要
# 安装 epel-release 即可
sudo yum install -y epel-release
```

4. 检查php包

```text
yum list php70w
```

5. 安装

```text
yum install php70w
```

6. 验证php安装

```text
php -v 
```

7. 一些报错

```shell
1. Your PHP installation does not support Intl functions.
Error Your PHP installation does not support IMAP functions.
//你的PHP安装不支持Intl函数、IMAP功能。
//直接安装这两个扩展即可

//先查看有无安装包
yum list php*imap
yum list php*intl

//安装
 yum install -y php71w-intl
 yum install -y php71w-imap
```

### 其他遇到的问题

权限问题，eslinux内核保护，在修改了文件权限后，仍然无法读取的话就先关闭eslinux保护

```shell
setenforce 0	//临时关闭eslinux
getenforce		//查看eslinux状态
```

