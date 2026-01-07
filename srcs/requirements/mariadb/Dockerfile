FROM alpine:3.22

RUN apk add --no-cache mariadb

# Default location for socket file that MariaDB wants to create.
RUN mkdir -p /run/mysqld && \
	chown mysql:mysql /run/mysqld

COPY conf/mariadb.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY --chmod=755 tools/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mariadbd", "--user=mysql", "--console"]
