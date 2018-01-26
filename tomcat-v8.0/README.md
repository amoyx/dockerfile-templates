# docker-tomcat8

## lastest version

amoyx/tomcat:v8-1.2.1

## pull image

> registry.aliyuncs.com/amoyx/tomcat:v8-1.2.1

## version notes

### 1.2.1

move supervisor log to `/usr/local/tomcat/logs`

### 1.2.0

1. add nginx

default nginx service run in port 80, proxy to 8080

you can add nginx config file in `/etc/nginx/sites-enabled/default`

2. add supervisor

### 1.1.6

1. fix jvm timezone bug, add timzezone parameter.

### write timezone in file  (Case Sensitive)

now you can set timezone in file `timezone`,default is `Asia/Shanghai`

example:

first, list timezone file in folder `/usr/share/zoneinfo/`

> ls /usr/share/zoneinfo/

second, blow to `Dockerfile`

	ADD timezone timezone


### set timezone with env parameter (Case Sensitive)

you can run container with env parameter. 

example:

> docker run -e "TIMEZONE=Asia/Shanghai" amoyx/tomcat:`<version tag>` 


### 1.1.5

remove memcachememcached-session-manager base jar, not need set them in base image.

### 1.1.4

a. add memcachememcached-session-manager needed jar package to tomcat lib :

  memcached-session-manager-1.9.1.jar
  
  memcached-session-manager-tc8-1.9.1.jar
  
  spymemcached-2.11.1.jar
  
b. add init folder for execute some scripts when container begin running

  you can add scripts in folder `$CATALINA_HOME/init`
  
### run container

run (remove container after stop)

> docker run -d --name tomcat-name -p 8080:8080 -v /data/logs/tomcat-name:/usr/local/tomcat/logs --restart=always amoyx/tomcat:`<version tag>`

there are some tomcat management password can be set with -e:

GUIPWD 

SCRIPTPWD 

JMXPWD 

STATUSPWD

as command:

> docker run -d --name tomcat-name -p 8080:8080 -v /data/logs/tomcat-name:/usr/local/tomcat/logs -e 'GUIPWD=Aa123456' --restart=always amoyx/tomcat:`<version tag>`

### build your docker image 

Execute blow command, and u can replace 'tomcat8-jre8' to your tag name.

> docker build -t="tomcat:`<version tag>`" ./

## OPTIONS

### crontab

the container will run crontab when start, meet below two conditions:

1 environment variables `CRONTAB` not none, or file `init/crontab.enable` exist

1.1 this option is a switch for enable or disable cron task

by the way, you can enable cron task when run the container:

> docker run -d -e "CRONTAB=true" <image name\>

1.2 use file `init/crontab.enable`, you can make cron task always run.

by this way, you can enable cron task by two step: 

step one, create a file `init/crontab.enable` with any string

> echo "true" > init/crontab.enable

step two, write below command into `Dockerfile` for add file into image

> COPY init/crontab.enable init/crontab.enable


2 you can write it reference blow in to folder init/crontab/, specifie user with file name:

step one, write a file `init/crontab/<user name>`  reference blow:

> \* * * * * /bin/echo "hello world"

step two, write below command into `Dockerfile` for add file into image

> COPY init/crontab/* init/crontab/


### init scripts

when the container start, will execute all .sh file in `init`

you can add .sh file into `init`, as such Dockerfile

> COPY custom.sh init/custom.sh

