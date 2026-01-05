#!/bin/sh

set -e

MYSQL_PASSWORD=$(cat "${MYSQL_PASSWORD_FILE}")
WP_ADMIN_PASSWORD=$(cat "${WP_ADMIN_PASSWORD_FILE}")
WP_USER_PASSWORD=$(cat "${WP_USER_PASSWORD_FILE}")
TARGET_URL=https://${DOMAIN_NAME}:${HOST_PORT}

# Update a WordPress option (stored in the database).
wp_option_update() {
	key=$1
	target_value=$2
	current_value=$(wp option get "$key" --allow-root)

	if [ "$current_value" != "$target_value" ]; then
		wp option update "$key" "$target_value" --allow-root
	else
		echo "Option '$key' is already set to '$target_value'. Skipping."
	fi
}

# Validate wp-admin username.
admin_lower=$(echo "${WP_ADMIN}" | tr '[:upper:]' '[:lower:]')
if echo "${admin_lower}" | grep -qE 'admin|administrator'; then
	echo "Error: Admin username must not contain 'admin' or 'administrator'" >&2
	exit 1
fi

until mariadb-admin --host=mariadb --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" ping --silent; do
	echo "Waiting for mariadb..."
	sleep 1
done

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

	# This fixes some redirect issues of WordPress when the host port is custom.
	# F.e., "https://example.com:3443/wp-admin" would redirect to "https://example.com/wp-admin" without this ("https://example.com:3443/wp-admin/" does not though).
	# However, setting these values in the wp-config.php greyes out the site URL settings in the admin panel.
	# wp config set WP_HOME "'https://' . (isset(\$_SERVER['HTTP_HOST']) ? \$_SERVER['HTTP_HOST'] : 'localhost')" --raw --allow-root
	# wp config set WP_SITEURL "'https://' . (isset(\$_SERVER['HTTP_HOST']) ? \$_SERVER['HTTP_HOST'] : 'localhost')" --raw --allow-root
fi

# Needed to be able to change the exposed port of the project.
wp_option_update siteurl "$TARGET_URL"
wp_option_update home "$TARGET_URL"

exec "$@"
