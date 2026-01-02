#!/bin/sh

set -e

if [ ! -f "/var/www/html/wp-config.php" ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	wp core download --allow-root

	wp config create \
		--allow-root \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost=mariadb

	wp core install \
		--allow-root \
		--url="${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${MYSQL_WP_ADMIN}" \
		--admin_password="${MYSQL_WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}"

	wp user create "${MYSQL_USER}" "${WP_USER_EMAIL}" \
		--allow-root \
		--user_pass="${MYSQL_PASSWORD}"
fi

exec php-fpm83 -F
