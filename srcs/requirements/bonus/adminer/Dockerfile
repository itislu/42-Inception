FROM alpine:3.22

ARG ADMINER_VERSION=5.4.1

RUN apk add --no-cache \
    php83 \
    php83-mysqli \
    php83-session

WORKDIR /var/www/html

ADD https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php \
    index.php

# Start the built-in PHP web server on port 8080.
CMD ["php83", "-S", "0.0.0.0:8080"]
