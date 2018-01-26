moosefs项目使用说明
===================================


###  1. 首先克隆本项目  <br />
     git  clone  https://github.com/amoyx/moosefs.git  <br />
 

###  2. 修改config/moosefs.cfg配置文件  <br />
     1. mfsmaster_ip 代表moosefs master的ip地址  <br />
     2. moosefs_img 代表mfs的docker镜像名称 <br />
   
   
###  3. 执行mfs.sh脚本
     执行 bash docker.sh时 ,不要带任何参数，仅需要执行一次即可  <br /> 
     注：该步骤操作完成后，会生成一个镜像，默认镜像名称为moosefs:1.0.1 ，如需修改，编辑config/moosefs.cfg文件，修改moosefs_img变量即可<br />
   
   
###  4. 安装Master server 主控服务器
     执行bash mfs.sh master，会生成mfs-master容器，默认对应的主机端口是9419,9420,9421,9425  <br />
	 注：通过访问 http://mfsmaster:9425 ,看到详细信息


###  5. 备份服务器Backup Server(metalogger)安装
     执行bash mfs.sh back，会生成mfs-back容器 <br /> 

   
###  6. 存储块服务器Chunk Servers安装 
     执行bash mfs.sh chunk，默认开放端口9422  <br />   
     注：最好能在多台服务器上安装chunk server,这样确保数据的安全性 <br />
   

###  7. 客户端User's  computers 安装
     执行bash mfs.sh client <br />
     注：默认挂载点 /mnt/mfs

