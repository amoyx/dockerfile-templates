FROM centos:7

RUN rpm -Uvh http://mirrors.ustc.edu.cn/epel//7/x86_64/e/epel-release-7-8.noarch.rpm
RUN rpm --import http://mirrors.ustc.edu.cn/epel/RPM-GPG-KEY-EPEL-7

RUN /usr/bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && /usr/bin/echo -e "ZONE="Asia/Shanghai"\nUTC=false\nRTC=false" > /etc/sysconfig/clock
	
RUN yum install supervisor -y 

RUN /usr/bin/mkdir -p /codis/logs && /usr/bin/mkdir -p /codis/redis

WORKDIR  /codis

COPY ./ /codis/
COPY supervisor.conf /etc/supervisord.conf
RUN chmod +x -R /codis/init /codis/entrypoint.sh /codis/bin


EXPOSE 18087
EXPOSE 6379
EXPOSE 19000
EXPOSE 11000
    
CMD ["/usr/bin/bash", "entrypoint.sh"]
