FROM ringo/scientific:6.5
MAINTAINER Wim De Meester <deepskywim@gmail.com>

# Update all packages
RUN yum -y update

# Update to Scientific Linux 6.6
RUN yum -y install yum-conf-sl6x
RUN yum -y upgrade

# Add extra repository
RUN yum -y install yum-conf-sl-other

# Add epel repository
RUN cd /tmp
RUN wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN yum -y update

# Install apache
RUN yum -y install httpd

# Add remi repository
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN rpm -Uhv remi-release-6.rpm
RUN yum -y install yum-utils
RUN yum-config-manager --enable remi

# Install mysql
RUN yum -y install mysql mysql-devel php-mysql mysql-server compat-mysql51

# Install php
RUN yum -y install php php-xml php-mbstring php-mcrypt php-cli php-gd

# Start httpd
EXPOSE 80

ADD startServices.sh /startServices.sh
RUN chmod 755 /*.sh
RUN touch /var/log/httpd/access_log /var/log/httpd/error_log

# Add a data volume for the mysql database
VOLUME /var/lib/mysql

# Start mysql
EXPOSE 3306
RUN /usr/bin/mysql_install_db
COPY www.deepskylog.org.sql /www.deepskylog.org.sql

CMD ["/startServices.sh"]
