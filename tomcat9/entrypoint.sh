INIT_DIR=$CATALINA_HOME/init
if [ -d $INIT_DIR ]; then
   for initfile in `ls $INIT_DIR/*.sh`
     do
       if [ -f $initfile ]; then
          sh $initfile
       fi
   done
fi

$CATALINA_HOME/bin/startup.sh && tail -f $CATALINA_HOME/logs/catalina.out
