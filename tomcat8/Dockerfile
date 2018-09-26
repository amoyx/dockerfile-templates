FROM ubuntu:latest

ENV CATALINA_HOME=/opt \
    JAVA_HOME=/usr/local/java \
	TZ=Asia/Shanghai

ENV JRE_HOME=$JAVA_HOME/jre \
    CLASSPATH=.:$JAVA_HOME/lib:/usr/local/java/jre/lib \
    PATH=$CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH \
    TOMCAT_TAR_URL=http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz \
	JAVA_TAR_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz \
	LC_ALL=zh_CN.UTF-8 \
	LANG=zh_CN.UTF-8
	
RUN /bin/mkdir -p $CATALINA_HOME && /bin/mkdir -p $JAVA_HOME

WORKDIR $CATALINA_HOME

COPY localtime \
     entrypoint.sh \
	 keys \
     bashrc \
	 simsun.ttf \
     $CATALINA_HOME/

RUN apt-get update \
	&& apt-get install language-pack-zh-hans -y \
    && echo 'LANG="zh_CN.UTF-8"' >> /etc/default/locale \
    && echo 'LANGUAGE="zh_CN:zh:en_US:en"' >> /etc/default/locale \
    && locale-gen zh_CN.UTF-8 \
	&& mkdir -p /usr/share/zoneinfo/Asia \
    && mv $CATALINA_HOME/localtime /usr/share/zoneinfo/$TZ \
	&& rm -rf /usr/share/zoneinfo/Etc \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
	&& echo $TZ > /etc/timezone \
	&& mkdir $CATALINA_HOME/keys \
    && mv $CATALINA_HOME/*.keystore $CATALINA_HOME/keys/ \
    && apt-get install fontconfig -y\
    && mv $CATALINA_HOME/simsun.ttf /usr/share/fonts/truetype/dejavu/simsun.ttf \
	&& chmod 777 /usr/share/fonts/truetype/dejavu/simsun.ttf \
	&& fc-cache \
    && mv $CATALINA_HOME/bashrc /root/.bashrc \
    && cd $JAVA_HOME \
    && apt-get install curl -y \
	&& curl -L "$JAVA_TAR_URL" -H "Cookie: oraclelicense=accept-securebackup-cookie" -H "Connection: keep-alive" -o java.tar.gz \
    && tar -xzvf java.tar.gz --strip-components=1 \
    && rm -rf java.tar.gz \
	&& cd $CATALINA_HOME \
    && curl -o tomcat.tar.gz $TOMCAT_TAR_URL \
    && tar -xzvf tomcat.tar.gz --strip-components=1 \
    && /bin/rm -rf webapps/docs webapps/examples webapps/ROOT/* webapps/host-manager webapps/manager \
	&& echo 'Hello World' > webapps/ROOT/index.html \
    && echo '#!/bin/sh' > $CATALINA_HOME/bin/setenv.sh \
    && echo 'JAVA_OPTS="$JAVA_OPTS -Xms1024m -Xmx2048m -XX:MaxPermSize=512m -server -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8787"'  >> $CATALINA_HOME/bin/setenv.sh \
    && rm -rf bin/*.bat \
    && rm -rf tomcat.tar.gz* \
    && chmod +x $CATALINA_HOME/bin/*.sh \
    && mkdir -p $CATALINA_HOME/logs \
    && touch $CATALINA_HOME/logs/catalina.out \
    && chmod 644 $CATALINA_HOME/logs/catalina.out \
	&& mv $CATALINA_HOME/entrypoint.sh /entrypoint.sh \
    && chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["bash", "/entrypoint.sh"]
