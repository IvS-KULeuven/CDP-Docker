# Dockerfile that modifies ringo/scientific to create a data volumne container.
FROM ringo/scientific:6.5
MAINTAINER Wim De Meester <deepskywim@gmail.com>
RUN mkdir -p /var/lib/mysql
VOLUME /var/lib/mysql
ENTRYPOINT /usr/bin/tail -f /dev/null
