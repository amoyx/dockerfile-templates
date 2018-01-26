#!/bin/bash


ZOOKEEPER_PACKE="http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz"
CLIENTPORT=2181
ZOOKEEPER_CLUSTER_IP="10.155.0.51  10.155.0.52 10.155.0.53"
LOCAL_IP=`ifconfig eth0 | grep "inet " | awk -F " " '{print $2}'`
ZOOKEEPER_DATADIR="/data/zookeeper"

yum install wget tar java -y
wget -O zookeeper.tar.gz $ZOOKEEPER_PACKE
tar -xzvf zookeeper.tar.gz -C /usr/local/
cd /usr/local/zookeeper*
cp conf/zoo_sample.cfg conf/zoo.cfg

i=1
if [[ ! -z $ZOOKEEPER_CLUSTER_IP ]] ; then
  for ip in $ZOOKEEPER_CLUSTER_IP 
    do
	   echo "server.${i}=${ip}:2888:3888"  >> conf/zoo.cfg
	   if [ $ip = $LOCAL_IP ]; then 
	      mkdir -p  $ZOOKEEPER_DATADIR
          TEMP_CHAR=`echo "$ZOOKEEPER_DATADIR" |sed 's:\/:\\\/:g'`
	      sed -i "s/dataDir=.*/dataDir=$TEMP_CHAR/" conf/zoo.cfg
	      echo $i > $ZOOKEEPER_DATADIR/myid
	   fi
	   i=$[$i+1]
  done
fi

if [ ! -z $CLIENTPORT ];then
   sed -i "s/clientPort=.*/clientPort=$CLIENTPORT/" conf/zoo.cfg
fi 

./bin/zkServer.sh start
