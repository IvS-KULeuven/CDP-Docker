#!/bin/bash
tail -F /var/log/httpd/error_log &
mysql_install_db &
/usr/bin/mysqld_safe &
sleep 10s
RESULT=`mysqlshow deepskylog | grep -o deepskylog`
if [ "$RESULT" != "deepskylog" ]; then
  echo "CREATE database deepskylog;" | mysql 
  mysql deepskylog < /www.deepskylog.org.sql 
  rm /www.deepskylog.org.sql 
fi

# Add an admin user
mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'deepskylog'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

exec httpd -D FOREGROUND 
