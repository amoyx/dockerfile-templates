#!/usr/bin/env bash

# set project name
PROJECTNAME=mysqlmha
# set static port, default random
CPORT=3306
# set mysqlmha master node ip address
MASTERIP=10.155.0.2
# set mysqlmha slave node ip address
SLAVEIP="10.155.0.3 10.155.0.4"
# set mysql data synchronism user
MASTER_USER="repl"
# set mysql data synchronism user password
MASTER_PASSWD="passwd"
# set mysql data synchronism master log file
MASTER_LOG_FILE="master-bin.000001"
# set mysql data synchronism master log pos
MASTER_LOG_POS="0"
# set mysql config file SERVER id 
SERVER_ID=1
# 需要复制的数据库名称
REPLICATE_DBNAME="db1 db2 db3"
# 不需要复制的数据库名称
RE_IGNORE_DBNAME="mysql information_schema performance_schema sys"