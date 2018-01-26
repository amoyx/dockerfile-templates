#!/usr/bin/bash

MYSQLCNF=/etc/mysql/mysql.conf.d/mysqld.cnf
SCRIPTFOLDER=$(cd `dirname $0`; pwd)
source  $SCRIPTFOLDER/conf.sh


if [ "${NODETYPE}" = "MASTER" ];then
    sed -i "s/server-id=.*/server-id=1/g"  $MYSQLCNF
    sed -i "s/log-bin=.*/d"  $MYSQLCNF
    sed -i "s/log-bin-index=.*/d" $MYSQLCNF
    for db in $REPLICATE_DBNAME
	  do
	   sed -i "s/server-id/a\binlog-do-db=$db" $MYSQLCNF
	done
	for db in $RE_IGNORE_DBNAME
	  do
	   sed -i "s/server-id/a\binlog-ignore-db=$db" $MYSQLCNF
	done
    /usr/bin/mysqld
fi

if [ "${NODETYPE}" = "SLAVE" ];then
    sed -i "s/server-id=.*/server-id=$SERVER_ID/g"  $MYSQLCNF
    sed -i "s/log-bin=.*/d"  $MYSQLCNF
    sed -i "s/log-bin-index=.*/d" $MYSQLCNF
    sed -i "s/server-id/a\master-host=$MASTERIP" $MYSQLCNF
    sed -i "s/master-host/a\master-user=$MASTER_USER" $MYSQLCNF
    sed -i "s/master-user/a\master-pass=$MASTER_PASSWD" $MYSQLCNF
    sed -i "s/master-pass/a\master-port=3306" $MYSQLCNF
    sed -i "s/master-port/a\master-connect-retry=30" $MYSQLCNF
    for db in $REPLICATE_DBNAME
	  do
	   sed -i "s/server-id/a\replicate-do-db=$db" $MYSQLCNF
	done
	for db in $RE_IGNORE_DBNAME
	  do
	   sed -i "s/server-id/a\replicate-ignore-db=$db" $MYSQLCNF
	done
    /usr/bin/mysqld --init-command="MASTER_HOST='$MASTERIP',MASTER_USER='$MASTER_USER',MASTER_PASSWORD=$MASTER_PASSWD,MASTER_LOG_FILE='$MASTER_LOG_FILE',MASTER_LOG_POS=$MASTER_LOG_POS;"
fi


