#!/bin/sh
set -e

MYSQL_ROOT_PASSWORD=$(cat "${MYSQL_ROOT_PASSWORD_FILE}")
MYSQL_PASSWORD=$(cat "${MYSQL_PASSWORD_FILE}")

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	mariadbd --user=mysql --bootstrap <<- EOF
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
		EOF
fi

exec "$@"
