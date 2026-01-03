FROM alpine:3.22

RUN apk add --no-cache \
	gettext \
	nginx

COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
