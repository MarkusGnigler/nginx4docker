#!/bin/sh

[ -f "/etc/nginx/ssl/certsdhparam.pem" ] || libressl dhparam -out /etc/nginx/ssl/certsdhparam.pem 4096

source /envsubst.sh

exec "$@"
