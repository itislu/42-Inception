#!/bin/sh

set -e

envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec "$@"
