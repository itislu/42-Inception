FROM alpine:3.22

RUN apk add --no-cache mariadb

COPY conf/mariadb.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Default location for socket file that MariaDB wants to create.
RUN mkdir -p /run/mysqld && \
	chown mysql:mysql /run/mysqld

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mariadbd", "--user=mysql", "--console"]
