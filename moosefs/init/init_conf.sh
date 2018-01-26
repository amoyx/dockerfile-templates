#!/bin/bash

supervisord_conf="/etc/supervisord.conf"

if [ ! -z $SERVICETYPE -a ! -z $MASTERIP ];then 
case "$SERVICETYPE" in
    master)
        echo "$MASTERIP mfsmaster" >> /etc/hosts
		echo "[program:mfs-master]" >> $supervisord_conf
        echo "command=/data/moosefs/sbin/mfsmaster start" >> $supervisord_conf
		echo "" >> $supervisord_conf
		echo "[program:mfs-cgi]" >> $supervisord_conf
		echo "command=/data/moosefs/sbin/mfscgiserv" >> $supervisord_conf
        ;;
    
    backup)
	    echo "$MASTERIP mfsmaster" >> /etc/hosts
        echo "" >> $supervisord_conf
        echo "[program:mfs-meta]" >> $supervisord_conf
		echo "autorestart = True" >> $supervisord_conf
		echo "startsecs = 1" >> $supervisord_conf
		echo "command = /data/moosefs/sbin/mfsmetalogger start" >> $supervisord_conf
		echo "autostart = True" >> $supervisord_conf
        ;;
   
    chunk)
	    chown -R mfs:mfs /mnt/mfs
	    echo "$MASTERIP mfsmaster" >> /etc/hosts
        echo "[program:mfs-chunk]" >> $supervisord_conf
		echo "command=/data/moosefs/sbin/mfschunkserver start" >> $supervisord_conf
        ;;
		
    *)
        echo "input wrong argument(s)"
        ;;
esac
fi

    
    
    
    
    