FROM alpine:3.22

RUN apk add --no-cache \
	curl \
	php83-ctype \
	php83-fpm \
	php83-mbstring \
	php83-mysqli \
	php83-phar

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Default memory limit of 128M is not enough for WordPress.
RUN sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php83/php.ini

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm83", "-F"]
