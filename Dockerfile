FROM nginx:1.21.6-alpine

LABEL \ 
    version=1.0.0 \
    maintainer="Markus Gnigler <markus.gnigler@bit-shfter.at>"

RUN \
    apk add --no-cache --update \
        tini \
        tzdata \
    && \
    # Set error logging to StdOut
    sed -i 's|/var/log/nginx/error.log|/dev/stdout|g' /etc/nginx/nginx.conf && \
    # Set access logging to StdOut
    sed -i 's|/var/log/nginx/access.log|/dev/stdout|g' /etc/nginx/nginx.conf && \
    # Import vhosts from vhost.d
    rm -f /etc/nginx/conf.d/default.conf && \
    mkdir /etc/nginx/vhost.d && \
    sed -i 's|#gzip  on;|#gzip  on; \n    include /etc/nginx/vhost.d/*.conf;|g' /etc/nginx/nginx.conf

VOLUME [ "/etc/nginx/conf.d" ]
VOLUME [ "/etc/nginx/vhost.d" ]

ENV \
    SERVER_IP="" \
    TZ="Europe/Vienna"

EXPOSE \
    80 \
    443

ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "nginx", "-g", "daemon off;" ]