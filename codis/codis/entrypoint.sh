
for INITFILE in `ls init/*.sh`
do
  bash $INITFILE
done

/usr/bin/supervisord