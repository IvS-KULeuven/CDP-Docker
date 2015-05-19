#!/bin/bash
# Check if there is a network connection on the host machine.
SERVERIP=134.58.117.134

ping -c 3 $SERVERIP > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Installing Scientific Linux updates"
  yum -y update
else
  echo "No network found, not installing Scientific Linux updates"
fi

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
