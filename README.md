# Docker
The Docker scripts to create the MIRI Docker image.

## Install docker
Docker can be easily installed on Linux machines. On Mac or Windows, download [boot2docker] (https://github.com/boot2docker/boot2docker/)
Before executing the following commands, start boot2docker on your Mac or Windows machine.

## Making the mysql Data Volume container
`docker build -t="mysqlmiri:latest" mysql-container`

## Run the Data Volume container
`docker run -d --name mysqlmiri mysqlmiri:latest tail -f /dev/null`

## Making the docker container
`docker build -t miri:latest .`

## Running the docker container
`docker run -v /lhome/wim/Work/MIRI/sourcecode:/var/www/html --volumes-from mysqlmiri -t -p 80:80 -p 3306:3306 miri:latest`

## Save the state of the docker container
From time to time, you want to save the state of the container. Possible reasons are:

+ There are some Scientific Linux updates that are installed every time.
+ You changed some things in the database and you want to have these changes available next time your start up the container.

The command to save the state is:

    docker commit `docker ps | grep miri | awk '{print $1;}'` miri:latest



## Find out the IP address of the webserver for the Miri webserver
* Mac: `boot2docker ip` (returns 192.168.59.103)
* Windows: `boot2docker.exe ip`
* Linux: You should just use `localhost`. Make sure that apache and mysql are not running on your computer.

## Make MIRI CDP work with the docker containers

In `lib/setup/`, copy the file `databaseInfo.php.dist` to `databaseInfo.php` and enter the correct ip address in the following line:

`$baseURL      = "http://192.168.59.103/";`

## Dump the database (only on Linux)
This can be used to update the database which is added to the Docker image.
`mysqldump -p -u admin -h 192.168.122.1 CDP > CDP.sql`

## Some interesting docker commands
`docker ps` shows the running docker .
`docker stop` stops a running docker container (add the container id)
`docker rm -v mysql` removes the mysql Volume container. You can start a new one.
