#!/bin/bash
SCRIPTFOLDER=$(cd `dirname $0`; pwd)
CONFIGFILEPATH=$SCRIPTFOLDER/config/moosefs.cfg
local_ip=`ifconfig eth0 | grep "inet " | awk -F " " '{print $2}'|awk '{gsub(/\./,"_");print $0}'`
source $CONFIGFILEPATH

if [ "x$local_ip" == "x" ]; then
    echo "cann't resolve host ip address"
    exit 1
fi

if [ -z $1 ]; then
   img=`docker images|grep $moosefs_img`
   if [[ -z $img ]]; then 
       docker build -t  $moosefs_img  .
   else
       echo "moosefs images already exists"
	   exit 1
   fi
fi

if [ ! -z $1 ]; then
    case "$1" in
      master)
          docker rm -f      "mfs-master" &> /dev/null
          docker run --name "mfs-master" -d -p 9419:9419 -p 9420:9420 -p 9421:9421 -p 9425:9425 --restart=always  -e "SERVICETYPE=master" -e "MASTERIP=$mfsmaster_ip"   $moosefs_img
          ;;

      backup)
          docker rm -f      "mfs-backup" &> /dev/null
          docker run --name "mfs-backup" -d --restart=always  -e "SERVICETYPE=backup" -e "MASTERIP=$mfsmaster_ip"   $moosefs_img
          ;;
		  
      chunk)
	      mkdir -p /mnt/mfs
          docker rm -f      "mfs-chunk" &> /dev/null
          docker run --name "mfs-chunk" -d -p 9422:9422 -v /mnt/mfs:/mnt/mfs --restart=always  -e "SERVICETYPE=chunk" -e "MASTERIP=$mfsmaster_ip"  $moosefs_img
          ;;
		  
      client)
	      yum install fuse fuse-devel fuse-libs -y
		  modprobe fuse
          chmod +x -R ./moosefs/bin/*   ./moosefs/sbin/*  
          echo "$mfsmaster_ip mfsmaster" >> /etc/hosts
		  mkdir -p /mnt/mfs
		  cp ./moosefs/bin/mfsmount /usr/bin/
		  mfsmount /mnt/mfs/ -H mfsmaster
          ;;
      
      cleanup)
          docker rm -f      "mfs-master" &> /dev/null
          docker rm -f      "mfs-backup" &> /dev/null
          docker rm -f      "mfs-chunk" &> /dev/null
          ;;
      *)
          echo "input argument(s) wrong"
          ;;
    esac
fi
