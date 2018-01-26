codis项目使用说明
===================================


###  1. 首先克隆本项目  <br />
     git  clone  https://github.com/amoyx/codis.git  <br />
 
 
###  2. 启动zoookeeper服务  <br />
     1. cd scripts  && bash zookeeper.sh <br />
     2. 注：如果需要在多台主机上安装，需修改 ZOOKEEPER_CLUSTER_IP 该变量的值，该值为主机IP地址 <br />
   
   
###  3. 修改config.ini配置文件  <br />
     1. 需要修改zk的主机连接地址，  <br />
     2. 修改product的名称  <br />
   
   
###  4. 执行docker.sh脚本
     1. 接着执行 bash docker.sh ,不要带任何参数，仅需要执行一次即可  <br /> 
     注：该脚本执行完成后，会生成一个镜像，默认镜像名称为codis:1.0.1 ，如需修改，打开docker.sh脚本，修改codisimage变量即可<br />
   
   
###  5. 启动dashboard脚本
     执行bash docker.sh  dashboard，会生成dashboard容器，默认对应的主机端口是18087  <br />


###  6. 初始化slots
     手动执行 cd codis && chmod +x ./bin/codis-config && ./bin/codis-config  -c  ./config/config.ini  slot init  <br /> 
     注：切记，一定要在redis Server Group步骤之前执行，仅需要执行一次即可 <br />

   
###  7. 启动codis redis 
     执行 bash  docker.sh  server  <br />   
     注：如果需要在多台主机上启动redis,把该脚本复制到不同的机器上执行即可， 前提是该机器已经pull codis:1.0.1的镜像 <br />
   

###  8. 添加redis Server Group
     1. 可以通过WEB页面操作，通过浏览器打开dashboard_IP:18087   <br />
     2. 也可以通过命令操作  cd codis && ./bin/codis-config -c ./config/config.ini server add 1 10.100.0.2:6379 master <br /> 
                                      ./bin/codis-config -c ./config/config.ini server add 1 10.100.0.3:6379 slave <br />
     注：每一个 Server Group 作为一个 Redis 服务器组存在, 只允许有一个 master, 可以有多个 slave, group id 仅支持大于等于1的整数 <br />
   

###  9. 设置redis server group服务的slot范围
     1. 手动执行./bin/codis-config  -c ./config/config.ini slot range-set 0 512 1 online  <br />   
              ./bin/codis-config  -c ./config/config.ini slot range-set 513 1023 2 online  <br />      
     2. 也可以通过WEB页面操作    <br /> 
     注：Codis 采用 Pre-sharding 的技术来实现数据的分片, 默认分成 1024 个 slots (0-1023), <br />

   
###  10. 启动codis-proxy
     1. 在执行这步操作前，需要先确认运行dashboard的主机IP，然后把docker.sh的dashboard_ip改成你自己的IP地址，切记修改正确，以免造成proxy不能使用  <br /> 
     2. 执行bash docker.sh  proxy  ，默认开放了主机的19000和11000端口<br />   
     注：如果需要多台,在各主机上执行 bash docker.sh  proxy 即可 <br />
   

###  11. 设置codis-server的HA
     1. 在执行这步操作前，需要先确认运行dashboard的主机IP，然后把docker.sh的dashboard_ip改成你自己的IP地址，切记修改正确，以免造成ha不能使用  <br /> 
     2. 执行bash docker.sh  ha  <br />   
     codis-ha实现codis-server的主从切换，codis-server主库挂了会提升一个从库为主库，从库挂了会设置这个从库从集群下线 <br />
   
