$CATALINA_HOME/init_timezone.sh
$CATALINA_HOME/init_manager.sh
$CATALINA_HOME/init_conf.sh

if [ ! -z "$CRONTAB" ] || [ -f "/data/init/crontab.enable" ]
then
  /usr/bin/cp $CATALINA_HOME/init/crontab/* /var/spool/cron/crontabs/
fi
/usr/sbin/cron

for INITFILE in `ls $CATALINA_HOME/init/*.sh`
do
  bash $INITFILE
done

/usr/bin/supervisord
