# add config replace script here,
# example:
#
#
#CONFIGFILE='www/config.php'
#if [ "$ENVTYPE" = "staging" ]
#then
#  CONF1="staging conf 1"
#  CONF2="staging conf 2"
#elif [ "$ENVTYPE" = "dev" ]
#then
#  CONF1="dev conf 1"
#  CONF2="dev conf 2"
#fi
#if [ ! -z $CONF1 ]
#then
# echo '$conf1="'$CONF1'";' >> $CONFIGFILE
#fi
#if [ ! -z $CONF2 ]
#then
# sed -i -e 's/conf2 = .*/conf2 = $CONF2/g' $CONFIGFILE
#fi