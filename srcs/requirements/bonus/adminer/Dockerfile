FROM alpine:3.22

RUN apk add --no-cache \
    php83 \
    php83-mysqli \
    php83-session

WORKDIR /var/www/html

ADD https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php \
    index.php

# Start the built-in PHP web server on port 8080.
CMD ["php83", "-S", "0.0.0.0:8080"]
