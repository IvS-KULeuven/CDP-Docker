#!/bin/bash
tail -F /var/log/httpd/error_log &
mysql_install_db &
/usr/bin/mysqld_safe &
sleep 10s
RESULT=`mysqlshow CDP | grep -o CDP`
if [ "$RESULT" != "CDP" ]; then
  echo "CREATE database CDP;" | mysql 
  mysql CDP < /CDP.sql 
  rm /CDP.sql 
fi

# Add an admin user
mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'miriman'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

exec httpd -D FOREGROUND 
