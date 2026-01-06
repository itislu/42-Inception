FROM alpine:3.22

RUN apk add --no-cache \
	gettext \
	nginx

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY --chmod=+x tools/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
