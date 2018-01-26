FROM isuper/java-oracle

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN set -ex \
	&& for key in \
		05AB33110949707C93A279E3D3EFE6B686867BA6 \
		07E48665A34DCAFAE522E5E6266191C37C037D42 \
		47309207D818FFD8DCD3F83F1931D684307A10A5 \
		541FBE7D8F78B25E055DDEE13C370389288584E7 \
		61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
		79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
		9BA44C2621385CB966EBA586F72C284D731FABEE \
		A27677289986DB50844682F8ACB77FC2E86E29AC \
		A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
		DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
		F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
		F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23 \
	; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.33
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --batch --verify tomcat.tar.gz.asc tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz* 
    
RUN set -x \
    && apt-get update \
    && apt-get install -y supervisor nginx \
    && apt-get clean 
    
RUN set -x \
    && rm -rf webapps/docs webapps/examples webapps/ROOT webapps/host-manager \
    && sed -i "s/redirectPort=\"8443\"/redirectPort=\"8443\" URIEncoding=\"UTF-8\"/g" $CATALINA_HOME/conf/server.xml \
    && sed -i "s/# gzip/gzip/g" /etc/nginx/nginx.conf \
    && sed -i "s/access_log.*/access_log \/usr\/local\/tomcat\/logs\/nginx_access.log;/g" /etc/nginx/nginx.conf \
    && sed -i "s/error_log.*/error_log \/usr\/local\/tomcat\/logs\/nginx_error.log;/g" /etc/nginx/nginx.conf \
    && sed -i "s/logfile=.*/logfile=\/usr\/local\/tomcat\/logs\/supervisord.log/g" /etc/supervisor/supervisord.conf \
    && sed -i "s/childlogdir=.*/childlogdir=\/usr\/local\/tomcat\/logs/g" /etc/supervisor/supervisord.conf
ADD nginx.conf /etc/nginx/sites-enabled/default
COPY init init
ADD timezone timezone
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf
ADD *.sh ./
RUN chmod +x $CATALINA_HOME/*.sh
EXPOSE 80
EXPOSE 8080
CMD ["bash", "entrypoint.sh"]


