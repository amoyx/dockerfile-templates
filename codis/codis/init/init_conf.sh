#!/bin/bash
codis_conf="/codis/config/config.ini"
redis_conf="/codis/config/redis.conf"
supervisord_conf="/etc/supervisord.conf"
productName=`cat $codis_conf |grep "product="|awk -F '=' '{print $2}'`


if [ ! -z $APPTYPE ];then 
case "$APPTYPE" in
    dashboard)
        echo "" >> $supervisord_conf
		echo "[program:codis-dashboard]" >> $supervisord_conf
        echo "command=/codis/bin/codis-config -c $codis_conf dashboard" >> $supervisord_conf
        ;;
    
    ha)
        echo "" >> $supervisord_conf
        echo "[program:codis-ha]" >> $supervisord_conf
		echo "autorestart = True" >> $supervisord_conf
		echo "stopwaitsecs = 10" >> $supervisord_conf
		echo "startsecs = 1" >> $supervisord_conf
		echo "stopsignal = QUIT" >> $supervisord_conf
		if [ ! -z $DASHBOARDIP ]; then 
		   echo "command = /codis/bin/codis-ha --codis-config=$DASHBOARDIP:18087 --productName=$productName" >> $supervisord_conf
		fi 
		echo "user = root" >> $supervisord_conf
		echo "startretries = 3" >> $supervisord_conf
		echo "autostart = True" >> $supervisord_conf
		echo "exitcodes = 0,2" >> $supervisord_conf
        ;;
   
    proxy)
	    if [ ! -z $PROXYIP -a ! -z $DASHBOARDIP ]; then
            PROXY_NUMBER=`echo $PROXYIP|awk '{gsub(/_/,"");print $0}'`
            sed -i "s/proxy_id=.*/proxy_id=$PROXY_NUMBER/"  $codis_conf
            echo "dashboard_addr=${DASHBOARDIP}:18087"  >> $codis_conf
        fi
        echo "[program:codis-proxy]" >> $supervisord_conf
		echo "command=/codis/bin/codis-proxy -c $codis_conf -L /codis/logs/codis-proxy.log --cpu=4  --addr=0.0.0.0:19000 --http-addr=0.0.0.0:11000" >> $supervisord_conf
        ;;    
	
    server)
		echo "[program:codis-server]" >> $supervisord_conf
		echo "command=/codis/bin/codis-server $redis_conf" >> $supervisord_conf
        ;;
		
    *)
        echo "input wrong argument(s)"
        ;;
esac
fi

    
    
    
    
    