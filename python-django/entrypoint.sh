
for INITFILE in `ls init/*.sh`
  do
    bash  $INITFILE
done

/usr/bin/python manage.py runserver 0.0.0.0:8000

