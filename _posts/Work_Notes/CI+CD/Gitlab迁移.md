### 备份原Gitlab服务器数据
1. 直接安装在Linux中的
2. 安装在docker中的

```shell
# 备份命令
gitlab-rake gitlab:backup:create

# 备份文件所在目录一般为git数据卷目录中的backups
例：/usr/local/docker/gitlab/data/backups
```

### 还原Gitlab服务器数据
注意各个Gitlab版本之间的迁移要求；
