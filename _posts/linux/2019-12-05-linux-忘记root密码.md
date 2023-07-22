---
title: Linux---忘记root密码如何操作
tags: Linux
---



## 个人使用过的方法（centos 7）
- **大概操作概念理论**
[![OFynjD.png](https://i.imgtg.com/2023/07/19/OFynjD.png)](https://imgtg.com/image/OFynjD)
- **首先重启系统，按 e 键，进入编辑模式，修改添加参数 rd.break，按 ctrl + X 重启**
[![OFyNy6.png](https://i.imgtg.com/2023/07/19/OFyNy6.png)](https://imgtg.com/image/OFyNy6)
- 重启后进入以下界面，按照来操作即可
```bash
##注意要按操作来，看注释！！！！！！##

mount	#检查挂载点，一定会有 /sysroot才是对的
mount -o remount,rw /sysroot	#挂载成可擦写
chroot /sysroot		

echo "你要修改的root密码" | passwd --stdin root	#这里已经修改成功了
touch /.autorelabel		#这一步不可缺少，不然可能无法开机
exit	#退出当前模式
reboot	#重启，重新登陆 root 密码上面自己修改的root密码
```

![OFyAob.png](https://i.imgtg.com/2023/07/19/OFyAob.png)


## 1. 使用sudo命令

Linux系统中，大多数发行版都默认安装并配置了sudo（superuser do）命令。sudo允许普通用户以root权限执行特定命令。因此，如果您有一个拥有sudo权限的用户，您可以使用该用户的密码来执行需要root权限的任务。

1. 使用拥有sudo权限的用户登录到系统。
2. 在终端中执行需要root权限的命令时，使用`sudo`命令，例如：

```bash
sudo command
```

3. 输入该用户的密码来执行该命令。

## 2. 使用恢复模式（Recovery Mode）

Linux系统通常提供了恢复模式（Recovery Mode），它是一个特殊的启动选项，允许您在系统不正常运行时进行故障排除和修复。

1. 在系统启动时，选择进入恢复模式。不同的发行版可能有不同的方式进入恢复模式，一般在引导菜单中会有相应选项。
2. 进入恢复模式后，选择“root Drop to root shell prompt”选项，进入root用户的命令行模式，无需输入密码。
3. 在root shell中，可以使用以下命令更改root密码：

```bash
passwd root
```

4. 输入新的root密码并确认修改。

## 3. 使用Live CD/USB

另一种解决方案是使用Live CD或Live USB启动系统，并且在启动时可以访问系统文件。

1. 使用Live CD或Live USB启动系统。
2. 挂载受影响的Linux分区，通常可以在`/mnt`目录下挂载：

```bash
sudo mount /dev/sdXY /mnt
```

请将`sdXY`替换为受影响的分区的正确设备标识。

3. 进入挂载的文件系统：

```bash
sudo chroot /mnt
```

4. 在chroot环境中，可以使用`passwd`命令来更改root密码：

```bash
passwd root
```

5. 输入新的root密码并确认修改。

6. 完成密码修改后，退出chroot环境并重新启动系统。

## 4. 预防措施

为了避免忘记root密码导致的问题，我们应该采取一些预防措施（当然最好是采用自己常用的密码）：

- **创建普通用户并赋予sudo权限**：避免直接使用root用户进行常规操作，创建一个普通用户，并通过sudo命令赋予其执行需要root权限的任务的权限。

- **定期备份系统**：定期备份系统文件和数据，这样即使出现问题，您也可以通过还原备份来恢复系统。

- **使用密码管理工具**：使用密码管理工具来安全地管理和保存密码，避免忘记密码的情况发生。
