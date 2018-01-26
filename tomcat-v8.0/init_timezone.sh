if [ -z "$TIMEZONE"]
then
  TIMEZONE=`cat $CATALINA_HOME/timezone`
fi
ln -b -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "$TIMEZONE" > /etc/timezone
