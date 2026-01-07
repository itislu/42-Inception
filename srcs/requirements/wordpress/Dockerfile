FROM alpine:3.22

# https://make.wordpress.org/hosting/handbook/server-environment/#php-extensions
RUN apk add --no-cache \
	curl \
	mariadb-client \
	php83 \
	php83-ctype \
	php83-curl \
	php83-dom \
	php83-exif \
	php83-fileinfo \
	php83-fpm \
	php83-iconv \
	php83-intl \
	php83-json \
	php83-mbstring \
	php83-mysqli \
	php83-openssl \
	php83-pecl-igbinary \
	php83-pecl-imagick \
	php83-phar \
	php83-tokenizer \
	php83-xml \
	php83-zip

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp

# Default memory limit of 128M is not enough for WP-CLI.
RUN sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php83/php.ini

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY --chmod=755 tools/docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm83", "-F"]
