FROM alpine:3.22

RUN apk add --no-cache \
	curl \
	php83-fpm \
	php83-mysqli \
	php83-phar

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
