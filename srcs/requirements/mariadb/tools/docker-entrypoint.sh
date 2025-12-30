#!/bin/sh

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	mariadbd --user=mysql --bootstrap <<- EOF
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		CREATE USER IF NOT EXISTS '${MYSQL_WP_ADMIN}'@'%' IDENTIFIED BY '${MYSQL_WP_ADMIN_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_WP_ADMIN}'@'%';
		FLUSH PRIVILEGES;
		EOF
fi

exec mariadbd --user=mysql --console
