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

- ```shell
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

