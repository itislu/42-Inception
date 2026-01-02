#!/bin/sh

set -e

if [ ! -f "/var/www/html/wp-config.php" ]; then
	# Needs to be at runtime to initialize the mounted volume at "/var/www/html".
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
		--admin_user="${WP_ADMIN}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}"

	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--allow-root \
		--user_pass="${WP_USER_PASSWORD}"
fi

exec php-fpm83 -F
