FROM ubuntu:latest

WORKDIR /opt

ENV TZ=Asia/Shanghai \
    LC_ALL=zh_CN.UTF-8 \
    LANG=zh_CN.UTF-8 \
    NGINX_TAR_URL=http://nginx.org/download/nginx-1.12.2.tar.gz

RUN mkdir -p /opt/logs && mkdir -p /opt/www
	
COPY localtime \
     bashrc \
	 nginx.conf \
     /opt/
	
RUN apt-get update \
	&& apt-get install language-pack-zh-hans gcc libpcre3 libpcre3-dev openssl libssl-dev zlib1g-dev curl make -y \
    && echo 'LANG="zh_CN.UTF-8"' >> /etc/default/locale \
    && echo 'LANGUAGE="zh_CN:zh:en_US:en"' >> /etc/default/locale \
    && locale-gen zh_CN.UTF-8 \
	&& mkdir -p /usr/share/zoneinfo/Asia \
    && mv localtime /usr/share/zoneinfo/$TZ \
	&& rm -rf /usr/share/zoneinfo/Etc \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
	&& echo $TZ > /etc/timezone \
    && mv bashrc /root/.bashrc \
    && mkdir /tmp/nginx \
    && cd /tmp/nginx \
    && curl -o nginx.tar.gz $NGINX_TAR_URL \
    && tar -xzvf nginx.tar.gz --strip-components=1 \
    && ./configure \
    "--prefix=/usr/local/nginx" \
    "--with-http_ssl_module" \
    "--with-http_v2_module" \
    "--with-http_stub_status_module" \
    "--without-http_auth_basic_module" \
    "--without-http_autoindex_module" \
    "--without-http_browser_module" \
    "--without-http_empty_gif_module" \
    "--without-http_geo_module" \
    "--without-http_limit_req_module" \
    "--without-http_map_module" \
    "--without-http_memcached_module" \
    "--without-http_proxy_module" \
    "--without-http_referer_module" \
    "--without-http_scgi_module" \
    "--without-http_split_clients_module" \
    "--without-http_upstream_least_conn_module" \
    "--without-http_userid_module" \
    "--without-http_uwsgi_module" \
    "--without-mail_imap_module" \
    "--without-mail_pop3_module" \
    "--without-mail_smtp_module" \
    "--without-poll_module" \
    "--without-select_module" \
    "--with-cc-opt='-O2'" \
    && make \
    && make install \
    && mv /opt/nginx.conf /usr/local/nginx/conf/nginx.conf \
    && echo 'hello world' > /opt/www/index.html \
    && rm -rf /tmp/nginx

EXPOSE 8080
    
CMD ["/usr/local/nginx/sbin/nginx", "-g","daemon off;"]
