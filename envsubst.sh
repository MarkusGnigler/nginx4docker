#!/bin/sh

find /etc/nginx/vhost.d -name '*.conf' \
| rev | awk -v FS='/' '{print $1}' | rev \
| xargs -i sh -c \
"envsubst \"$(cat $(pwd)/ENV | sed -e 's|^|\\|')\" < /etc/nginx/vhost.d/{} > /etc/nginx/internal-vhost.d/{}"

exec "$@"
