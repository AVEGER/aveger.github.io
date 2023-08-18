### 有用的cmd命令
- msconfig：系统配置
	微软操作系统中的一个实用工具，用于管理系统启动项和硬件配置。该工具可帮助用户查看和更改系统配置、启动项、服务、驱动程序、网络协议等设置。
	
- diskpart：
	是Windows系统下的一个命令行工具，用于管理和操作磁盘分区、卷和文件系统。
	
- 安装framework 3.5 失败：

  需要重新安装软件的源；使用以下命令安装

  ```shell
  dism.exe /online /add-package /packagepath:C:\NetFx3.cab
  
  C:\NetFx3.cab为.net3.5的文件的路径
  NetFx3.cab就是.net 3.5的文件
  ```

### 不重启更新环境变量

````shell
更新环境变量
set PATH=C:

查看环境变量
set

查看环境变量PATH
echo %PATH%

查看变量位置
where java
````

