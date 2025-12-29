FROM alpine:3.22

RUN apk add --no-cache \
	nginx \
	openssl

RUN mkdir -p /etc/nginx/ssl

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu#step-1-creating-the-tls-certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-out /etc/ssl/nginx-selfsigned.crt \
	-keyout /etc/ssl/nginx-selfsigned.key \
	-subj "/CN=ldulling.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
