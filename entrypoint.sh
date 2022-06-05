#!/bin/sh

# [ -f "/etc/nginx/ssl/certsdhparam.pem" ] || {
#    libressl dhparam -out /etc/nginx/ssl/certsdhparam.pem 4096 
#    echo "ssl cipher key created ..."
# }

[ -f "/etc/nginx/ssl/certsdhparam.pem" ] && sh /config.sh create_ssl_headers

source /envsubst.sh

exec "$@"