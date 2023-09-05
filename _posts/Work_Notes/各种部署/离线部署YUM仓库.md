## 搭建本地离线yum仓库
环境：VMware-Workstation-12-Pro，Windows-10，CentOS-7.5，Xshell5

### 前言
我们知道yum工具是基于rpm的，其一个重要的特性就是可以自动解决依赖问题，但是yum的本质依旧是把后缀名.rpm的包下载到本地，然后按次序安装之。但是每次执行yum install xxx，会自动安装并且安装完毕后把rpm包自动删除。当我们下载比较大的服务，比如MySQL大约190M，每次都重新下载比较慢，这时我们就可以考虑，搭建本地离线yum仓库，大致需要如下几个步骤。

1. 把rpm包及其相关依赖全部都下载到本地，保存好。
2. 手动在/etc/yum.repos.d/目录下配置本地仓库信息。
3. 使用createrepo命令生成repodata信息。
4. 使用yum repoinfo检查确认。

### 把rpm包下载到本地

```shell
yum install  --downloadonly --downloaddir=/aspack/ \
mysql-community-server
```
看到了吗，就是如此简单，上述命令即可把 mysql-community-server 对应的所有rpm包及其依赖下载到/aspack/目录里，也就是说yum本地安装mysql需要的所有文件我们都准备好了。

```
需要安装其它包，则替换成别的包名即可
执行上述命令本机不会安装mysql，本机初始处于没有安装任何mysql相关包的状态
```


### 配置本地yum仓库信息
```shell
vim /etc/yum.repos.d/as4k.repo
[as4k]
name=as4k local repository
baseurl=file:///aspack
gpgcheck=0
enabled=1
```
可以看到.repo配置文件，也是如此简单：

- as4k是本地仓库名，可任意起名，但是注意不能与已有的仓库名重复。
- name后面是注释信息，随意书写。
- baseurl这后面就是填写本地仓库路径了，file://表示使用本地文件协议，后面的/aspack本地rpm包存放路径。
- gpgcheck=0这是和验证包的安全信息的，最好设置成0，表示关闭安全验证，否则还需要准备安全验证文件，麻烦一堆一堆的。
- enabled=0，表示启用本仓库，1启用，0关闭。
更多详细配置信息，请参考man yum.conf

### 生成repodata信息
直觉上好像我们完成上述两个步骤就可使用本地yum仓库了，然后并不行。如果我们现在就直接使用本地仓库安装一个包，会报如下错误：

```shell
failure: repodata/repomd.xml from as4k: [Errno 256] No more mirrors to try
```


错误有一大堆，总而言之就是本地仓库不行，还不能用。关键提示就是上图红色的部分，告诉我们找不到/aspack/repodata/repomd.xml这个文件，当然找不到了，到目前位置我们的本地仓库里除了鲜红的rpm包之外什么都没有，repomd.xml这个文件简单来说就是存放本地仓库rpm包的索引信息，具体用法不是我们关心的重点，可以使用createrepo直接生成。

```
假如我们本地仓库没有配置好，不仅本地仓库无法使用，整个yum安装工具都会一直报错，此时我们把本地yum配置文件改名或暂时删除即可
```

createrepo命令默认系统没有，需要我们额外安装：

```shell
# yum install createrepo -y
安装完毕之后，直接使用：
# createrepo /aspack/
这时会发现本地仓库repodata相关信息已经生成完毕：
```


### 检查以及使用
使用下述命令可以看到本地仓库基本信息：

```shell
# yum repoinfo as4k
Repo-id      : as4k
Repo-name    : as4k local repository
Repo-status  : enabled
Repo-revision: 1537699080
Repo-updated : Sun Sep 23 18:38:01 2018
Repo-pkgs    : 41
Repo-size    : 214 M
Repo-baseurl : file:///aspack/
Repo-expire  : 21,600 second(s) (last: Sun Sep 23 18:41:05 2018)
Filter     : read-only:present
Repo-filename: /etc/yum.repos.d/as4k.repo
repolist: 41

# 安装MySQL5.7测试：
yum install mysql-community-server
```

可以看到使用起来，与线上仓库区别不大。创建好的本地仓库可直接scp复制到其它机器使用，yum配置文件及rpm仓库直接复制过去即可，无需再创建一遍repodata信息。

### 对本地仓库进行更新
下载一个新的rpm软件包到本地仓库，此时我们使用yum repoinfo as4k查看会发现软件包的数量并没有增加，我们安装新增的软件包也会提示，找不到次软件包的现象，可以按照下述步骤，更新仓库信息。

1. 查看旧的软件包总数  yum repoinfo as4k | grep pkgs
2. 更新本地仓库  createrepo --update /aspack/
3. 清除所有缓存  yum clean all
4. 查看新的软件包总数  yum repoinfo as4k | grep pkgs
如果软件包的数量增加，说明仓库更新成功。

参考资料
http://blog.51cto.com/hashlinux/1661474
http://blog.sina.com.cn/s/blog_130affe1d0102vy01.html