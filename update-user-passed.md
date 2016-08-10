MySQL 5.5 root用户丢失 - Trevor的个人页面 - 开源中国社区

原 MySQL 5.5 root用户丢失
一. Windows

1.以系统管理员身份登入windows系统。

2.如果mysql是启动的，先将它关闭。

3.打开命令视窗cmd。
    如果在上一步骤，没有关闭mysql，可以用net start 查看mysql是否还在启动状态。在启动状态的话，就用net stop mysql的指令停止。

4.切换到mysql的安装路径的bin资料夹内，如果是预设路径，应该在的D:＼MySQL＼MySQL Server 5.5.15＼bin之下。

5.执行mysqld –skip-grant-tables，这个指令用以启动mysql，但会跳过权限检查。

6.上个指令执行完后，命令视窗就停在mysql的运行状态，不能再输入指令了，所以要重新打开一个新的cmd命令视窗。
同样切换到mysql的安装路径的bin资料夹内，执行mysql

7.在mysql>的模式下，执行
     代码如下
        >insert into user set Host='%',User='root',Password=Password('root12345678'),ssl_cipher='',x509_issuer='',x509_subject='',select_priv='y', insert_priv='y',update_priv='y', Alter_priv='y',delete_priv='y',create_priv='y',drop_priv='y',reload_priv='y',shutdown_priv='y',Process_priv='y',file_priv='y',grant_priv='y',References_priv='y',index_priv='y',create_user_priv='y',show_db_priv='y',super_priv='y',create_tmp_table_priv='y',Lock_tables_priv='y',execute_priv='y',repl_slave_priv='y',repl_client_priv='y',create_view_priv='y',show_view_priv='y',create_routine_priv='y',alter_routine_priv='y';

        >flush privileges;
        >quit;
[上面的步骤就可将忘记的密码重设。]

8.回到dos命令模式，执行mysqladmin -u root -p shutdown，输入刚改过的密码123456。关掉目前mysql无权限的模式。

9.再正常启动mysql。

10.再输入 mysql -u root -p
    就可以输入你的正确的密码了

------------------------------------------------------


二.Unix&Linux：

1.用root或者运行mysqld的用户登录系统；

2．利用kill命令结束掉mysqld的进程；

3．使用–skip-grant-tables参数启动MySQL Server
     代码如下
        >;mysqld_safe –skip-grant-tables &（写全路径）

4.为root@localhost设置新密码
    代码如下
        >;mysqladmin -u root flush-privileges password “newpassword”，
    或直接进入mysql表中修改Password
        如：
        >;use mysql
        >;update user set password=password("new_pass") where user=”root”;
        >;flush privileges;

5．重启MySQL Server
