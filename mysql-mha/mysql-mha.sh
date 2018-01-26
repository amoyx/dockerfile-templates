#!/bin/bash
MYSQLIMG="mysql:5.7.16"

if [ -z $1 ]; then
   echo "mysql node type Can't be empty"
   exit 1
fi

if [ ! -z $1 ]; then
    case "$1" in
      master)
          docker rm -f      "mysqlmha-master" &> /dev/null
          docker run --name "mysqlmha-master" -d -p 3306:3306 -v /data/mysql:/var/lib/mysql --restart=always  -e "NODETYPE=MASTER"  $MYSQLIMG
          ;;

      slave)
          docker rm -f      "mysqlmha-slave" &> /dev/null
          docker run --name "mysqlmha-slave" -d -p 3306:3306  -v /data/mysql:/var/lib/mysql --restart=always -e "NODETYPE=SLAVE"  $MYSQLIMG
          ;;
      
      cleanup)
          docker rm -f      "mysqlmha-master" &> /dev/null
          docker rm -f      "mysqlmha-slave" &> /dev/null
          ;;
      *)
          echo "input argument(s) wrong"
          ;;
    esac
fi
