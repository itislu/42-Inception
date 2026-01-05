#!/bin/sh

set -e

MYSQL_PASSWORD=$(cat "${MYSQL_PASSWORD_FILE}")
WP_ADMIN_PASSWORD=$(cat "${WP_ADMIN_PASSWORD_FILE}")
WP_USER_PASSWORD=$(cat "${WP_USER_PASSWORD_FILE}")

# Validate wp-admin username.
admin_lower=$(echo "${WP_ADMIN}" | tr '[:upper:]' '[:lower:]')
if echo "${admin_lower}" | grep -qE 'admin|administrator'; then
	echo "Error: Admin username must not contain 'admin' or 'administrator'" >&2
	exit 1
fi

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

wp config set WP_HOME "'https://' . (isset(\$_SERVER['HTTP_HOST']) ? \$_SERVER['HTTP_HOST'] : 'localhost')" --raw --allow-root
wp config set WP_SITEURL "'https://' . (isset(\$_SERVER['HTTP_HOST']) ? \$_SERVER['HTTP_HOST'] : 'localhost')" --raw --allow-root

exec "$@"
