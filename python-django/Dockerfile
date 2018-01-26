FROM  registry.aliyuncs.com/kolbuy/django:1.0.1

RUN  mkdir -p /data/app

WORKDIR  /data/app

COPY  init init
COPY  entrypoint.sh  entrypoint.sh
COPY  manage.py  manage.py
COPY  conf conf 

RUN   chmod +x -R  init
RUN   chmod +x     entrypoint.sh

EXPOSE  8888 8000

CMD ["/usr/bin/bash", "entrypoint.sh"]
