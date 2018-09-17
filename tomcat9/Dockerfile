FROM centos:7.4.1708

ENV CATALINA_HOME=/opt \
    JDK_RPM=jdk.rpm \
    PATH=/opt/bin:$PATH \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8

RUN /bin/mkdir -p $CATALINA_HOME

WORKDIR $CATALINA_HOME

COPY tomcat \
     $JDK_RPM \
     entrypoint.sh \
     simsun.ttc \
     keys \
     fonts.conf \
     $CATALINA_HOME/

RUN rpm -ivh $CATALINA_HOME/$JDK_RPM \
    && /bin/rm -rf $CATALINA_HOME/bin/*.bat $CATALINA_HOME/$JDK_RPM $CATALINA_HOME/webapps/* \
    && /bin/chmod +x $CATALINA_HOME/bin/*.sh \
    && /bin/mkdir -p $CATALINA_HOME/webapps/ROOT \
    && /bin/echo 'Hello World' > $CATALINA_HOME/webapps/ROOT/index.html \
    && /bin/mkdir -p $CATALINA_HOME/keys \
    && /bin/mv $CATALINA_HOME/*.key $CATALINA_HOME/keys/ \
    && /bin/mv $CATALINA_HOME/entrypoint.sh /entrypoint.sh \
    && /bin/chmod +x /entrypoint.sh \
    && /bin/echo 'Asia/Shanghai' > /etc/timezone \
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum -y install kde-l10n-Chinese glibc-common \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 \
    && yum -y install fontconfig ttmkfdir \
    && mkdir -p /usr/share/fonts/chinese \
    && /bin/mv $CATALINA_HOME/simsun.ttc /usr/share/fonts/chinese/simsun.ttc \
    && chmod -R 755 /usr/share/fonts/chinese \
    && ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir \
    && /bin/mv $CATALINA_HOME/fonts.conf /etc/fonts/fonts.conf \
    && fc-cache

EXPOSE 8080

CMD ["bash", "/entrypoint.sh"]
