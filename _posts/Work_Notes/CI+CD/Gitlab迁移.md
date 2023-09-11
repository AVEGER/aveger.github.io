### 会用到的一些命令

```shell
# 查看Gitlabbanb
cat /opt/gitlab/embedded/service/gitlab-rails/VERSION

# Docker删除一个容器
docker rm -f 指定容器名

# 使用docker安装Gitlab时，指定卷的位置
export GITLAB_HOME=/srv/gitlab

# 直接下载并运行docker中的Gitlab镜像（这是极狐版Gitlab）
sudo docker run --detach \    # --detach 指定容器后台运行
  --hostname 192.168.10.37 \  # --hostname 指定主机地址可以写域名
  --publish 443:443 --publish 80:80 --publish 2222:22 \
  # --publish 指定端口映射，冒号前代表宿主机的端口，冒号后代表容器的端口
  --name gitlab \    # --name 容器的名字
  --restart always \ # --restart always 总是重启
  # --volume 指定数据卷
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  --shm-size 256m \
  registry.gitlab.cn/omnibus/gitlab-jh:latest
  # 这里可以指的就是镜像，可以是远程地址也可以下载下来后使用镜像的名字
```

### 备份原Gitlab服务器数据
1. 直接安装在Linux中的
2. 安装在docker中的

```shell
# 先进入容器
docker exec -it gitlab /bin/bash

# 使用备份命令
gitlab-rake gitlab:backup:create

# 备份文件所在目录一般为git数据卷目录中的backups
例:/usr/local/docker/gitlab/data/backups

# 没找到的话可以使用docker复制命令，直接复制到容器里
docker cp source_path 容器_ID:目标_PATH

# 备份 gitlab.rb 和 gitlab-secrets.json 文件
# 这两个文件不会被备份命令打包备份，需要手动备份一份，复制就行
cp /etc/gitlab/gitlab.rb
cp /etc/gitlab/gitlab-secrets.json
```

### 还原Gitlab服务器数据
- 注意各个Gitlab版本之间的迁移要求； 最好是在新机器上安装原版本
- 注意备份的文件在恢复时，最好设置权限为 777
```shell
# 需要先停止相关数据连接服务
gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq

# 加载备份文件，注意等号后面只需到文件编号，不用整个文件名
gitlab-rake gitlab:backup:restore BACKUP=1694136701_2023_09_08_14.10.2
# 等待备份文件加载完成即可，中间会出现几次交互，大概意思就是加载备份会删除现有数据，是否确定，都输入yes就可以

# 最后别忘记了重新加载 gitlab.rb 和 gitlab-secrets.json 文件
gitlab-ctl reconfigure
```
