#!/bin/bash

codisimage="codis:1.0.1"
proxyip=`ifconfig eth0 | grep "inet " | awk -F " " '{print $2}'|awk '{gsub(/\./,"_");print $0}'`
dashboard_ip="10.0.0.2"


if [ "x$proxyip" == "x" ]; then
    echo "cann't resolve host ip address"
    exit 1
fi

if [ -z $1 ]; then
   cd codis
   img=`docker images|grep $codisimage`
   if [ -z $img ]; then 
       docker build -t  $codisimage  .
   else
       echo "codis images already exists"
   fi
fi

if [ ! -z $1 ]; then
    case "$1" in
      dashboard)
          docker rm -f      "Codis-dashboard" &> /dev/null
          docker run --name "Codis-dashboard" -d -p 18087:18087 --restart=always -e "APPTYPE=dashboard"  $codisimage
          ;;
      
      ha)
          docker rm -f      "Codis-ha" &> /dev/null
          docker run --name "Codis-ha" -d  -e "APPTYPE=ha" --restart=always -e "DASHBOARDIP=$dashboard_ip"   $codisimage
          ;;
		  
      proxy)
          docker rm -f      "Codis-proxy" &> /dev/null
          docker run --name "Codis-proxy" -d  --hostname=$proxyip  -p 19000:19000 -p 11000:11000 --restart=always -e "APPTYPE=proxy"  -e "PROXYIP=$proxyip" -e "DASHBOARDIP=$dashboard_ip"  $codisimage
          ;;
		  
      server)
          docker rm -f      "Codis-server" &> /dev/null
          docker run --name "Codis-server" -d -p 6379:6379  --restart=always -e "APPTYPE=server"  $codisimage
          ;;
      
      cleanup)
          docker rm -f      "Codis-dashboard" &> /dev/null
          docker rm -f      "Codis-ha" &> /dev/null
          docker rm -f      "Codis-server" &> /dev/null
		  docker rm -f      "Codis-proxy" &> /dev/null
          ;;
      *)
          echo "input argument(s) wrong"
          ;;
    esac
fi
