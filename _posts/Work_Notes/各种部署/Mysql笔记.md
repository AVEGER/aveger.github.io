## Mysql查看

1. 查看mysql的最大连接数
```shell
show variables like 'max_connections';
```

2. 查看Mysql访问的端口号
```shell
show global variables like 'port';
```

3. 查看是否允许远程连接,mysql为安全起见,默认只允许本地登录数据库
```shell
use mysql;
select host from user;
```

## Mysql修改参数

- 修改一个表和键的编码格式

```mysql
alter table llx_c_product_nature convert to character set utf8;
# llx_c_product_nature是你要修改的表名，utf8是你要修改的编码格式
```
