FROM ubuntu:latest

ENV CATALINA_HOME /usr/local/tomcat
ENV JAVA_HOME  /usr/local/java
ENV MAVEN_HOME /usr/local/maven
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH .:$JAVA_HOME/lib:$JRE_HOME/lib
ENV PATH $CATALINA_HOME/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

RUN /bin/mkdir -p $CATALINA_HOME && /bin/mkdir -p $JAVA_HOME && /bin/mkdir -p $MAVEN_HOME
WORKDIR $CATALINA_HOME

ENV TOMCAT_TAR_URL http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.27/bin/apache-tomcat-8.5.27.tar.gz
ENV JAVA_TGZ_URL http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz
ENV MAVEN_TGZ_URL http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz

RUN apt-get update \
    && apt-get install supervisor wget -y \
    && apt-get clean

RUN set -x \
    && wget -O tomcat.tar.gz $TOMCAT_TAR_URL \
    && tar -xzvf tomcat.tar.gz --strip-components=1 \
    && rm -rf bin/*.bat \
    && rm -rf tomcat.tar.gz*

RUN set -x \
    && cd $JAVA_HOME \
    && wget -O java.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_TGZ_URL \
    && tar -xzvf java.tar.gz --strip-components=1 \
    && rm -rf java.tar.gz

RUN set -x \
    && cd $MAVEN_HOME \
    && wget -O maven.tar.gz $MAVEN_TGZ_URL \
    && tar -xzvf maven.tar.gz --strip-components=1 \
    && rm -rf maven.tar.gz*

RUN echo 'Asia/Shanghai' /etc/timezone

RUN echo '#!/bin/sh' > $CATALINA_HOME/bin/setenv.sh \
    && echo 'JAVA_OPTS="$JAVA_OPTS -Xms1024m -Xmx2048m -XX:MaxPermSize=512m -server"'  >> $CATALINA_HOME/bin/setenv.sh \
    && echo 'CATALINA_OPTS="$CATALINA_OPTS -DserverType=rdtest -DserverName=first"' >> $CATALINA_HOME/bin/setenv.sh

RUN set -x \
    &&  /bin/rm -rf webapps/docs webapps/examples webapps/ROOT/* webapps/host-manager  \
    &&  echo 'Hello World' > webapps/ROOT/index.html \
    &&  /bin/sed -i "s/redirectPort=\"8443\"/redirectPort=\"8443\" URIEncoding=\"UTF-8\"  \
        maxThreads=\"500\"  \
        acceptCount=\"500\"  \
        maxConnections=\"1024\"   \
        enableLookups=\"false\" /g"  $CATALINA_HOME/conf/server.xml

COPY redis-session-manager redis-session-manager
RUN  cd redis-session-manager \
     && mvn clean package  \
     && cp target/redis-session-manager-with-dependencies*.jar $CATALINA_HOME/lib/ \
     && rm -rf ./*

COPY localtime /etc/localtime
COPY entrypoint.sh /entrypoint.sh
RUN  chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["bash", "/entrypoint.sh"]
