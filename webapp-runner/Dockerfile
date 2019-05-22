FROM ubuntu:latest

ENV CATALINA_HOME=/opt \
    JAVA_HOME=/usr/local/jre

ENV CLASSPATH=.:$JAVA_HOME/lib:/usr/local/jre/lib \
    PATH=$JAVA_HOME/bin:$PATH \
    LC_ALL=zh_CN.UTF-8 \ 
    LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

RUN /bin/mkdir -p $CATALINA_HOME/logs && /bin/mkdir -p $JAVA_HOME

COPY localtime \
     keys \
     bashrc \
     java1.8.tar.gz \
     webapp-runner.jar \
     simsun.ttf \
     jssecacerts \
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
    && tar -xzvf $CATALINA_HOME/java1.8.tar.gz -C $JAVA_HOME \
    && mv $CATALINA_HOME/jssecacerts $JAVA_HOME/lib/security/ \
    && rm -rf $CATALINA_HOME/java1.8.tar.gz

EXPOSE 8080

WORKDIR $CATALINA_HOME
