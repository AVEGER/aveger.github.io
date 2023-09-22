### GIT 1.8.3.1克隆仓库代码报错
````bash
错误信息：
error: RPC failed; result=22. HTTP code = 404
fatal: The remote end hung up unexpectedly

解决：
1、GIT版本问题，如果可以换，换成高级版本
2、我的解决方法：在远程仓库地址后加 .git 后缀即可，
例：git clone http://giturl.com.git
````

### 某些二进制文件不能用cat查看，否则会乱码

````bash
cat /var/log/wtmp	//乱码
last -f /var/log/wtmp	//正常
last 查看最后登录的用户，可以直接调用查看文件/var/log/wtmp
````

### 安装mysql- -community报错

```shell
  错误信息：
  warning: /var/cache/yum/x86_64/7/mysql57-community/packages/mysql-community-libs-compat-5.7.37-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY

  Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

  The GPG keys listed for the "MySQL 5.7 Community Server" repository are already installed but they are not correct for this package.

  Check that the correct key URLs are configured for this repository.
```

- 原因是Mysql的GPG升级了，需要重新获取。

```shell
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install mysql-community-server -y	//重新安装即可
```
### /bin/bash^M: 坏的解释器: 没有那个文件或目录

```shell
  错误信息：### /bin/bash^M: 坏的解释器: 没有那个文件或目录

  原因：在使用IDEA或其他编辑器编辑脚本过后，由于Windows和linux的文本格式问题导致无法识别，
      主要是Windows的换行符是 \r\n、Linux上的换行符是 \n。

  解决办法： 去掉多余的 \r 符号即可
    1. 使用全局命令： sed 's/\r//' -i shell.sh
    2. 使用vim编辑器，命令模式下输入：set ff=unix、保存退出即可
    3. 可以在IDEA等编辑器的设置中设置换行符的格式，例：IDEA在 Code Style -- General
       -- Line separator下设置
```

### NFS使用

网络文件系统（Network File System，NFS）允许网络中的计算机通过TCP/IP网络共享资源。通过NFS，本地NFS的客户端应用可以直接读写NFS服务器上的文件，就像访问本地文件一样。NFS可以通过网络让不同主机之间或不同的操作系统之间进行数据存储和共享。
- 需要在服务端和客户端分别做配置
- 服务端信息配置

```shell
1.在服务端安装软件
yum -y install nfs-utils rpcbind

2.创建共享目录
mkdir /data/nfs

3.配置共享目录权限
进入 /etc/exports 并修改
vi /etc/exports
/data/nfs     192.168.10.81/24(rw,sync,no_root_squash)
# 这是exports的内容,地址为服务器地址

4.使配置生效
exportfs -r

5.启动NFS服务器
service rpcbind start  或者  systemctl start rpcbind #使用其中一条命令
service nfs start      或者 systemctl start nfs #使用其中一条命令

6.查看本地rpc信息

rpcinfo -p localhost
   program vers proto   port  service
    100000    4   tcp    111  portmapper
    100000    3   tcp    111  portmapper
    100000    2   tcp    111  portmapper
    100000    4   udp    111  portmapper
    100000    3   udp    111  portmapper
    100000    2   udp    111  portmapper

7.在服务端查看NFS挂载信息
showmount -e localhost

Export list for localhost:
/data/nfs 192.168.10.81/24
```

- 客户端配置使用

```shell
1. 客户端安装软件
yum -y install nfs-utils

2. 创建挂载文件夹
mkdir /data/nfs

3. 查看服务器的信息
showmount -e 192.168.10.81

4. 挂载目录到本地
mount -t nfs 192.168.10.81:/data/nfs /data/nfs

5. 创建文件检查
在客户端或者服务端创建文件，在另外一端查看文件，是否为刚才创建的。
```

crontab命令-定时执行任务
```shell
Linux crontab 是用来定期执行程序的命令。

当安装完成操作系统之后，默认便会启动此任务调度命令。

crond 命令每分钟会定期检查是否有要执行的工作，如果有要执行的工作便会自动执行该工作。

注意：新创建的 cron 任务，不会马上执行，至少要过 2 分钟后才可以，当然你可以重启 cron 来马上执行。

而 linux 任务调度的工作主要分为以下两类：

1. 系统执行的工作：系统周期性所要执行的工作，如备份系统数据、清理缓存
2. 个人执行的工作：某个用户定期要做的工作，例如每隔 10 分钟检查邮件服务器是否有新信，这些工作可由每个用户自行设置
```
