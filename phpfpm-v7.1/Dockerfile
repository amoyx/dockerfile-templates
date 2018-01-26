FROM centos:7
RUN rpm -Uvh https://repo.webtatic.com/yum/el7/epel-release.rpm && \
    rpm -Uvh https://repo.webtatic.com/yum/el7/webtatic-release.rpm && \
	rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN rpm --import https://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7

RUN yum install php71w php71w-mysql php71w-fpm  php71w-mbstring php71w-xml \
    php71w-pecl-redis  php71w-common php71w-opcache php71w-gd php71w-mcrypt -y
RUN yum install nginx supervisor -y

RUN /bin/ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    /bin/echo 'ZONE="Asia/Shanghai"'  > /etc/sysconfig/clock

RUN /bin/mkdir -p /data/logs  && /bin/chmod 777 -R /data/logs \
    && /bin/mkdir -p /var/www && /bin/chown -R nginx.nginx /var/www \
    && /bin/mkdir /data/www && /bin/chown -R nginx.nginx /data/www	
	
WORKDIR  /data

RUN /bin/sed -i 's/daemonize = yes/daemonize = no/g' /etc/php-fpm.conf \
    && /bin/sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/;listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/listen = 127.0.0.1:9000/listen = \/dev\/shm\/php-fpm.sock/g' /etc/php-fpm.d/www.conf

RUN /bin/sed -i 's/^error_reporting = E_ALL/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/g' /etc/php.ini \
    && /bin/sed -i 's/^display_errors = On/display_errors = Off/g' /etc/php.ini \
	&& /bin/sed -i 's/^display_startup_errors = On/display_startup_errors = Off/g' /etc/php.ini \
	&& /bin/sed -i 's/^;error_log = php_errors.log/error_log = \/data\/logs\/php_errors.log/g' /etc/php.ini \
	&& /bin/sed -i 's/^error_log = \/var\/log\/php-fpm\/error.log/error_log = \/data\/logs\/phpfpm_error.log/g' /etc/php-fpm.conf \
	&& /bin/sed -i 's/^slowlog = \/var\/log\/php-fpm\/www-slow.log/slowlog = \/data\/logs\/www-slow.log/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^php_admin_value[error_log] = \/var\/log\/php-fpm\/www-error.log/php_admin_value[error_log] = \/data\/logs\/www-error.log/g' /etc/php-fpm.d/www.conf
	
RUN /bin/sed -i 's/^;pm.status_path = \/status/pm.status_path = \/status/g' /etc/php-fpm.d/www.conf \
    && /bin/sed -i 's/^;rlimit_files = 1024/rlimit_files = 10240/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^;pm.max_requests = 500/pm.max_requests = 500/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^;request_terminate_timeout = 0/request_terminate_timeout = 60/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^;request_slowlog_timeout = 0/request_slowlog_timeout = 10/g' /etc/php-fpm.d/www.conf \
    && /bin/sed -i 's/^pm.max_children = 50/pm.max_children = 70/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^pm.start_servers = 5/pm.start_servers = 3/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^pm.min_spare_servers = 5/pm.min_spare_servers = 2/g' /etc/php-fpm.d/www.conf \
	&& /bin/sed -i 's/^pm.max_spare_servers = 35/pm.max_spare_servers = 20/g' /etc/php-fpm.d/www.conf
	
RUN /bin/sed -i 's/^;date.timezone =/date.timezone = Asia\/Shanghai/g'  /etc/php.ini \
    && /bin/sed -i 's/^max_execution_time = 30/max_execution_time = 60/g' /etc/php.ini \
    && /bin/sed -i 's/^post_max_size = 8M/post_max_size = 100M/g' /etc/php.ini \
	&& /bin/sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php.ini \
	&& /bin/sed -i 's/^max_file_uploads = 20/max_file_uploads = 50/g' /etc/php.ini \
	&& /bin/sed -i 's/^session.cookie_lifetime = 0/session.cookie_lifetime = 7200/g' /etc/php.ini \
	&& /bin/sed -i 's/^session.gc_maxlifetime = 1440/session.gc_maxlifetime = 7200/g' /etc/php.ini

RUN /bin/sed -i 's/^nodaemon=false/nodaemon=true/g' /etc/supervisord.conf \
    && touch /etc/supervisord.d/php-fpm.ini \
	&& echo '[program:nginx]' > /etc/supervisord.d/php-fpm.ini \
	&& echo "command=/usr/sbin/nginx" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "autostart=true" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "startsecs=3" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "autorestart=true" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "startretries=3" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "" >>  /etc/supervisord.d/php-fpm.ini \
	&& echo "[program:php7-fpm]" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "command=/usr/sbin/php-fpm -F" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "autostart=true" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "startsecs=3" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "autorestart=true" >> /etc/supervisord.d/php-fpm.ini \
	&& echo "startretries=3" >> /etc/supervisord.d/php-fpm.ini
	
COPY nginx.conf /etc/nginx/nginx.conf
ADD errors /var/www/errors
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x  /entrypoint.sh

EXPOSE 80

CMD ["/bin/bash","/entrypoint.sh"]