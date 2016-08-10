CentOS下mysql数据库文件全部丢失mysql无法启动

CentOS重启后mysql数据库文件全部丢失mysql无法启动

一早起来，发现数据目录下的mysql文件全部消失，一声冷汗，怎么回事！！？？？被黑了，还是因为前两天重启服务器导致mysql数据丢失？？？这是怎么回事，上网看看怎么解决，没找到解决方案！！！！看看mysql服务是不是开启的，

[root@pacteralinux mysql]# ps -ef|grep mysql
root      53794291013:10pts/000:00:00grep mysql
[root@pacteralinux mysql]# service mysqld start
Starting MySQL..The server quit without updating PID file (/mnt/resource/mysqldate/pacteralinux.pid).[FAILED]，服务关闭，而且启动不了！看日志：
13112613:10:57mysqld_safe Starting mysqld daemon withdatabases from /mnt/resource/mysqldate
2013-11-2613:10:580[Warning] TIMESTAMP withimplicit DEFAULT value isdeprecated. Pleaseuse--explicit_defaults_for_timestamp server option (see documentation formore details).
2013-11-2613:10:585650[Note] Plugin 'FEDERATED'isdisabled.
/usr/local/mysql/bin/mysqld: Table 'mysql.plugin'doesn't exist
2013-11-2613:10:585650[ERROR] Can't open the mysql.plugin table. Please run mysql_upgrade to create it.
2013-11-2613:10:585650[Note] InnoDB: The InnoDB memory heap isdisabled
2013-11-2613:10:585650[Note] InnoDB: Mutexes and rw_locks useGCC atomic builtins
2013-11-2613:10:585650[Note] InnoDB: Compressed tables usezlib 1.2.3
2013-11-2613:10:585650[Note] InnoDB: Not using CPU crc32 instructions
2013-11-2613:10:585650[Note] InnoDB: Initializing buffer pool, size = 128.0M
2013-11-2613:10:585650[Note] InnoDB: Completed initialization of buffer pool
2013-11-2613:10:585650[Note] InnoDB: The first specified data file ./ibdata1 did not exist: a newdatabase to be created!
2013-11-2613:10:585650[Note] InnoDB: Setting file ./ibdata1 size to 12MB
2013-11-2613:10:585650[Note] InnoDB: Database physically writes the file full: wait...
2013-11-2613:10:585650[Note] InnoDB: Setting log file ./ib_logfile101 size to 48MB
2013-11-2613:10:585650[Note] InnoDB: Setting log file ./ib_logfile1 size to 48MB
2013-11-2613:10:585650[Note] InnoDB: Renaming log file ./ib_logfile101 to ./ib_logfile0
2013-11-2613:10:585650[Warning] InnoDB: New log files created, LSN=45781
2013-11-2613:10:585650[Note] InnoDB: Doublewrite buffer not found: creating new
2013-11-2613:10:585650[Note] InnoDB: Doublewrite buffer created
2013-11-2613:10:585650[Note] InnoDB: 128rollback segment(s) are active.
2013-11-2613:10:595650[Warning] InnoDB: Creating foreign key constraint system tables.
2013-11-2613:10:595650[Note] InnoDB: Foreign key constraint system tables created
2013-11-2613:10:595650[Note] InnoDB: Creating tablespace and datafile system tables.
2013-11-2613:10:595650[Note] InnoDB: Tablespace and datafile system tables created.
2013-11-2613:10:595650[Note] InnoDB: Waiting forpurge to start
2013-11-2613:10:595650[Note] InnoDB: 5.6.14started; log sequence number 0
2013-11-2613:10:595650[Note] Server hostname (bind-address): '*'; port: 3306
2013-11-2613:10:595650[Note] IPv6 isavailable.
2013-11-2613:10:595650[Note]   - '::'resolves to '::';
2013-11-2613:10:595650[Note] Server socket created on IP: '::'.
2013-11-2613:10:595650[ERROR] Fatal error: Can't open and lock privilege tables: Table 'mysql.user' doesn't exist
13112613:10:59mysqld_safe mysqld from pid file /mnt/resource/mysqldate/pacteralinux.pid ended
[ERROR] Fatal error: Can't open and lock privilege tables: Table 'mysql.user' doesn't exist：表初始化没做好;不管，下意识的删除日志看下能不能重启


 [root@pacteralinux mysqldate]# ll

total 110640
-rw-rw----. 1mysql mysql       56Nov 2517:17auto.cnf
-rw-rw----. 1mysql mysql 12582912Nov 2613:15ibdata1
-rw-rw----. 1mysql mysql 50331648Nov 2613:15ib_logfile0
-rw-rw----. 1mysql mysql 50331648Nov 2613:10ib_logfile1
-rw-rw----. 1mysql root     39056Nov 2613:15pacteralinux.err
[root@pacteralinux mysqldate]# rm ib*
rm: remove regular file `ibdata1'? y
rm: remove regular file `ib_logfile0'? y
rm: remove regular file `ib_logfile1'? y
不行，网上看看能不能恢复数据，无解决方案！！
幸好这时一个mysql从服务器（我做了一个主从mysql热备份）！！！没办法，数据恢复不了就重新在复制一份吧！
上述步骤后还是不能启动数据
试试重新初始化：
[root@pacteralinux mysqldate]# /usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql/data/ --datadir=/mnt/resource/mysqldate/
FATAL ERROR: Could not find ./bin/my_print_defaults
If you compiled from source, you need to run 'make install'to
copy the software into the correct location ready foroperation.
If you are using a binary release, you must either be at the top
level of the extracted archive, or pass the --basedir option
pointing to that location.
[root@pacteralinux mysqldate]# cd /usr/local/mysql/bin/
[root@pacteralinux mysql]# /usr/local/mysql/scripts/mysql_install_db --user=mysql --no-defaults
Installing MySQL system tables...2013-11-2613:20:420[Warning] TIMESTAMP withimplicit DEFAULT value isdeprecated. Please use--explicit_defaults_for_timestamp server option (see documentation formore details).
2013-11-2613:20:426036[Note] InnoDB: The InnoDB memory heap isdisabled
2013-11-2613:20:426036[Note] InnoDB: Mutexes and rw_locks useGCC atomic builtins
2013-11-2613:20:426036[Note] InnoDB: Compressed tables usezlib 1.2.3
2013-11-2613:20:426036[Note] InnoDB: Not using CPU crc32 instructions
2013-11-2613:20:426036[Note] InnoDB: Initializing buffer pool, size = 128.0M
2013-11-2613:20:426036[Note] InnoDB: Completed initialization of buffer pool
2013-11-2613:20:426036[Note] InnoDB: Highest supported file format isBarracuda.
2013-11-2613:20:426036[Note] InnoDB: 128rollback segment(s) are active.
2013-11-2613:20:426036[Note] InnoDB: Waiting forpurge to start
2013-11-2613:20:426036[Note] InnoDB: 5.6.14started; log sequence number 1600607
2013-11-2613:20:426036[Warning] InnoDB: Cannot open table mysql/innodb_table_stats from theinternaldata dictionary of InnoDB though the .frm file forthe table exists. See http://dev.mysql.com/doc/refman/5.6/en/innodb-troubleshooting.html for how you can resolve the problem.
ERROR: 1146Table 'mysql.innodb_table_stats'doesn't exist
2013-11-2613:20:426036[ERROR] Aborting
2013-11-2613:20:426036[Note] Binlog end
2013-11-2613:20:426036[Note] InnoDB: FTS optimize thread exiting.
2013-11-2613:20:426036[Note] InnoDB: Starting shutdown...
2013-11-2613:20:446036[Note] InnoDB: Shutdown completed; log sequence number 1600617
2013-11-2613:20:446036[Note] ./bin/mysqld: Shutdown complete初始化不了，，删除之前初始化的文件试试


[root@pacteralinux data]# ll
total 12
drwx------. 2mysql mysql 4096Sep 2512:27mysql
drwx------. 2mysql mysql 4096Sep 2512:27performance_schema
drwxr-xr-x. 2mysql mysql 4096Sep 2510:28test
[root@pacteralinux data]# cd ..
[root@pacteralinux mysql]# rm -rf data/
重新初始化：


 [root@pacteralinux mysql]# scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/mnt/resource/mysqldate --user=mysql
Installing MySQL system tables...2013-11-2613:41:480[Warning] TIMESTAMP withimplicit DEFAULT value isdeprecated. Please use--explicit_defaults_for_timestamp server option (see documentation formore details).
2013-11-2613:41:486768[Note] InnoDB: The InnoDB memory heap isdisabled
2013-11-2613:41:486768[Note] InnoDB: Mutexes and rw_locks useGCC atomic builtins
2013-11-2613:41:486768[Note] InnoDB: Compressed tables usezlib 1.2.3
2013-11-2613:41:486768[Note] InnoDB: Not using CPU crc32 instructions
2013-11-2613:41:486768[Note] InnoDB: Initializing buffer pool, size = 128.0M
2013-11-2613:41:486768[Note] InnoDB: Completed initialization of buffer pool
2013-11-2613:41:486768[Note] InnoDB: Highest supported file format isBarracuda.
2013-11-2613:41:486768[Note] InnoDB: Log scan progressed past the checkpoint lsn 49463
2013-11-2613:41:486768[Note] InnoDB: Database was not shutdown normally!
2013-11-2613:41:486768[Note] InnoDB: Starting crash recovery.
2013-11-2613:41:486768[Note] InnoDB: Reading tablespace information from the .ibd files...
2013-11-2613:41:486768[Note] InnoDB: Restoring possible half-written data pages
2013-11-2613:41:486768[Note] InnoDB: from the doublewrite buffer...
InnoDB: Doing recovery: scanned up to log sequence number 1600617
2013-11-2613:41:486768[Note] InnoDB: Starting an apply batch of log records to the database...
InnoDB: Progress inpercent: 282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899
InnoDB: Apply batch completed
2013-11-2613:41:486768[Note] InnoDB: 128rollback segment(s) are active.
2013-11-2613:41:486768[Note] InnoDB: Waiting forpurge to start
2013-11-2613:41:486768[Note] InnoDB: 5.6.14started; log sequence number 1600617
2013-11-2613:41:546768[Note] Binlog end
2013-11-2613:41:546768[Note] InnoDB: FTS optimize thread exiting.
2013-11-2613:41:546768[Note] InnoDB: Starting shutdown...
2013-11-2613:41:556768[Note] InnoDB: Shutdown completed; log sequence number 1625997
OK
Filling help tables...2013-11-2613:41:550[Warning] TIMESTAMP withimplicit DEFAULT value isdeprecated. Please use--explicit_defaults_for_timestamp server option (see documentation formore details).
2013-11-2613:41:556793[Note] InnoDB: The InnoDB memory heap isdisabled
2013-11-2613:41:556793[Note] InnoDB: Mutexes and rw_locks useGCC atomic builtins
2013-11-2613:41:556793[Note] InnoDB: Compressed tables usezlib 1.2.3
2013-11-2613:41:556793[Note] InnoDB: Not using CPU crc32 instructions
2013-11-2613:41:556793[Note] InnoDB: Initializing buffer pool, size = 128.0M
2013-11-2613:41:556793[Note] InnoDB: Completed initialization of buffer pool
2013-11-2613:41:556793[Note] InnoDB: Highest supported file format isBarracuda.
2013-11-2613:41:556793[Note] InnoDB: 128rollback segment(s) are active.
2013-11-2613:41:556793[Note] InnoDB: Waiting forpurge to start
2013-11-2613:41:556793[Note] InnoDB: 5.6.14started; log sequence number 1625997
2013-11-2613:41:556793[Note] Binlog end
2013-11-2613:41:556793[Note] InnoDB: FTS optimize thread exiting.
2013-11-2613:41:556793[Note] InnoDB: Starting shutdown...
2013-11-2613:41:576793[Note] InnoDB: Shutdown completed; log sequence number 1626007
OK
To start mysqld at boot time you have to copy
support-files/mysql.server to the right place foryour system
PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
To doso, start the server, then issue the following commands:
/usr/local/mysql/bin/mysqladmin -u root password 'new-password'
/usr/local/mysql/bin/mysqladmin -u root -h pacteralinux password 'new-password'
Alternatively you can run:
/usr/local/mysql/bin/mysql_secure_installation
which will also give you the option of removing the test
databases and anonymous user created by default.  This is
strongly recommended forproduction servers.
See the manual formore instructions.
You can start the MySQL daemon with:
cd . ; /usr/local/mysql/bin/mysqld_safe &
You can test the MySQL daemon withmysql-test-run.pl
cd mysql-test ; perl mysql-test-run.pl
Please report any problems withthe ./bin/mysqlbug script!
The latest information about MySQL isavailable on the web at
http://www.mysql.com
Support MySQL by buying support/licenses at http://shop.mysql.com
WARNING: Found existing config file /usr/local/mysql/my.cnf on the system.
Because thisfile might be inuse, it was not replaced,
but was used inbootstrap (unless you used --defaults-file)
and when you later start the server.
The newdefaultconfig file was created as/usr/local/mysql/my-new.cnf,
please compare it withyour file and take the changes you need.
WARNING: Default config file /etc/my.cnf exists on the system
This file will be read by defaultby the MySQL server
If you donot want to usethis, either remove it, or usethe
--defaults-file argument to mysqld_safe when starting the server


重新启动mysql


 [root@pacteralinux scripts]# service mysqld start
Starting MySQL.[  OK  ]
[root@pacteralinux mysql]# ps -ef|grep msyql
root      7236  4316  0 14:08 pts/100:00:00 grepmsyql
[root@pacteralinux mysql]# ps -ef|grep mysql
root      6838     1  0 13:42 pts/100:00:00 /bin/sh/usr/local/mysql/bin/mysqld_safe--datadir=/mnt/resource/mysqldate--pid-file=/mnt/resource/mysqldate/pacteralinux.pid
mysql     7091  6838  0 13:42 pts/100:00:00 /usr/local/mysql/bin/mysqld--basedir=/usr/local/mysql--datadir=/mnt/resource/mysqldate--plugin-dir=/usr/local/mysql/lib/plugin--user=mysql --log-error=/mnt/resource/mysqldate/pacteralinux.err --pid-file=/mnt/resource/mysqldate/pacteralinux.pid --socket=/mnt/resource/mysqldate/mysql.sock --port=3306
root      7238  4316  0 14:08 pts/100:00:00 grepmysql

可以看到，mysql安装路径为--basedir=/usr/local/mysql，初始数据库的存放目录为--datadir=/mnt/resource/mysqldate


-rw-rw----. 1 mysql mysql   2048 Nov 26 13:41 user.MYI

[root@pacteralinux mysql]# pwd
/mnt/resource/mysqldate/mysql
[root@pacteralinux mysql]# cd ..
[root@pacteralinux mysqldate]# ll
total 110664
-rw-rw----. 1 mysql mysql       56 Nov 25 17:17 auto.cnf
-rw-rw----. 1 mysql mysql 12582912 Nov 26 13:42 ibdata1
-rw-rw----. 1 mysql mysql 50331648 Nov 26 13:42 ib_logfile0
-rw-rw----. 1 mysql mysql 50331648 Nov 26 13:39 ib_logfile1
drwx------. 2 mysql mysql     4096 Nov 26 13:41 mysql
srwxrwxrwx. 1 mysql mysql        0 Nov 26 13:42 mysql.sock
-rw-rw----. 1 mysql root     46096 Nov 26 13:42 pacteralinux.err
-rw-rw----. 1 mysql mysql        5 Nov 26 13:42 pacteralinux.pid
drwx------. 2 mysql mysql     4096 Nov 26 13:41 performance_schema
drwx------. 2 mysql mysql     4096 Nov 26 13:41 test
其中，mysql，performance_schema，test为初始化后的文件
下面开始恢复数据库
登录到生产服务器执行备份：

 [root@uyhd000225 ~]# mysqldump -u***** -p***** mysqldb >mysqldb20131126.sql  #数据库比较大，大约半小时


复制到备份服务器：


[root@uyhd000225 ~]# scp mysqldb20131126.sql root@remoteIP:/mnt/backup/
root@remoteIP's password:
mysqldb20131126.sql                                                                               3%  153MB 680.6KB/s 1:43:33ETA


(责任编辑：IT)
