
USERXML="<?xml version='1.0' encoding='utf-8'?><tomcat-users xmlns=\"http://tomcat.apache.org/xml\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://tomcat.apache.org/xml tomcat-users.xsd\" version=\"1.0\">"
if [ ! -z $GUIPWD ]
 then 
 USERXML=$USERXML"<role rolename=\"manager-gui\"/><user username=\"tomcat\" password=\""$GUIPWD"\" roles=\"manager-gui\"/>"
fi
if [ ! -z $SCRIPTPWD ]
 then 
 USERXML=$USERXML"<role rolename=\"manager-script\"/><user username=\"tomcat\" password=\""$SCRIPTPWD"\" roles=\"manager-script\"/>"
fi
if [ ! -z $JMXPWD ]
 then 
 USERXML=$USERXML"<role rolename=\"manager-jmx\"/><user username=\"tomcat\" password=\""$JMXPWD"\" roles=\"manager-jmx\"/>"
fi
if [ ! -z $STATUSPWD ]
then 
USERXML=$USERXML"<role rolename=\"manager-status\"/><user username=\"tomcat\" password=\""$STATUSPWD"\" roles=\"manager-status\"/>"
 fi
USERXML=$USERXML"</tomcat-users>"
if [ ! -z $GUIPWD ]||[ ! -z $SCRIPTPWD ]||[ ! -z $JMXPWD ]||[ ! -z $STATUSPWD ]
then 
 echo $USERXML > $CATALINA_HOME/conf/tomcat-users.xml
else 
 rm -rf $CATALINA_HOME/webapps/manager
fi
