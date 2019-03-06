FROM scientificlinux/sl:6
LABEL Wim De Meester <wim.demeester@ster.kuleuven.be>

# Update all packages
RUN yum -y update

# Update to Scientific Linux 6.6
RUN yum -y install yum-conf-sl6x
RUN yum -y upgrade

# Add extra repository
RUN yum -y install yum-conf-sl-other

# Install wget
RUN yum -y install wget

# Add epel repository
RUN cd /tmp
RUN wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN yum -y update

# Install apache
RUN yum -y install httpd

# Add remi repository
RUN rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum -y install yum-utils

# Install mysql
RUN yum -y install mysql mysql-devel mysql-server compat-mysql51

# Install php 5.6
RUN yum -y install php56w php56w-mbstring php56w-mcrypt php56w-gd php56w-pdo php56w-mysql

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
COPY CDP.sql /CDP.sql

CMD ["/startServices.sh"]
