#### sudo su和su的区别
- <u>su是申请切换root用户，</u>需要申请root用户密码。有些Linux发行版，例如ubuntu，默认没有设置root用户的密码，所以需要我们先使用sudo passwd root设置root用户密码。
- 而sudo su是当前用户暂时申请root权限，所以输入的不是root用户密码，而是当前用户的密码。sudo是用户申请管理员权限执行一个操作，<u>而此处的操作就是变成管理员。</u>
