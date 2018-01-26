FROM centos:7

RUN rpm -Uvh http://mirrors.ustc.edu.cn/epel//7/x86_64/e/epel-release-7-8.noarch.rpm
RUN rpm --import http://mirrors.ustc.edu.cn/epel/RPM-GPG-KEY-EPEL-7

RUN /usr/bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && /usr/bin/echo -e "ZONE="Asia/Shanghai"\nUTC=false\nRTC=false" > /etc/sysconfig/clock
	
RUN yum install supervisor libpcap -y 

RUN /usr/bin/mkdir -p /data/logs && /usr/bin/mkdir -p /mnt/mfs

RUN groupadd mfs && useradd -g mfs mfs

WORKDIR  /data

ENV MFSPATH /data/moosefs
ENV PATH ${MFSPATH}/bin:${PATH}:${MFSPATH}/sbin

COPY ./ /data/
COPY supervisor.conf /etc/supervisord.conf
RUN chmod +x -R /data/init /data/entrypoint.sh /data/moosefs/bin /data/moosefs/sbin /data/moosefs/share/mfscgi/*.cgi
RUN chown -R mfs:mfs  moosefs/var  /mnt/mfs

# （不推荐下面的路径直接建立在Docker虚拟机上，推荐使用volume挂载方式）
# 在宿主机上创建一个数据库目录存储Mysql的数据文件
# sudo mkdir -p /mnt/mfs

# VOLUME 选项是将本地的目录挂在到容器中　此处要注意：当你运行-v　＜hostdir>:<Containerdir> 时要确保目录内容相同否则会出现数据丢失
# 对应关系如下
# mfs:/mnt/mfs
VOLUME ["/mnt/mfs"]

EXPOSE 9419 9420 9421 9422 9425
    
CMD ["/usr/bin/bash", "entrypoint.sh"]
