#!/bin/sh

find /etc/nginx/vhost.d -name '*.conf' \
| xargs -i sh -c \
"envsubst '$(cat /ENVSUB | sed -e 's|^|\\|')' < {} > {}.temp && mv {}.temp {}"

exec "$@"
