#!/bin/sh

find /etc/nginx/vhost.d -name '*.conf' | xargs -i sh -c "envsubst '\$HOST_IP \${HOST_IP}' < {} > {}.temp && mv {}.temp {}"

exec "$@"