FROM alpine:3.22

ARG DOMAIN_NAME

RUN apk add --no-cache \
	gettext \
	nginx \
	openssl

RUN mkdir -p /etc/nginx/ssl

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu#step-1-creating-the-tls-certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-out /etc/ssl/nginx-selfsigned.crt \
	-keyout /etc/ssl/nginx-selfsigned.key \
	-subj "/CN=${DOMAIN_NAME}"

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
