FROM nginx:1.21.6-alpine

LABEL \ 
    version=1.0.0 \
    maintainer="Markus Gnigler <markus.gnigler@bit-shifter.at>"

RUN \
    apk add --no-cache --update \
        tini \
        tzdata \
    && \
    # Remove nginx version
    sed -i 's|http {|http {\n    server_tokens off;|g' /etc/nginx/nginx.conf && \
    \
    # Prepare for nginx user
    sed -i 's|user  nginx;||g' /etc/nginx/nginx.conf && \
    sed -i 's|pid        /var/run/nginx.pid;|pid        /tmp/nginx.pid;|g' /etc/nginx/nginx.conf && \
    # Set error logging to StdOut
    sed -i 's|/var/log/nginx/error.log notice|/dev/stdout warn|g' /etc/nginx/nginx.conf && \
    # Set access logging to StdOut
    sed -i 's|/var/log/nginx/access.log|/dev/stdout|g' /etc/nginx/nginx.conf && \
    # Import vhosts from vhost.d
    rm -f /etc/nginx/conf.d/default.conf && \
    mkdir /etc/nginx/vhost.d && \
    sed -i 's|#gzip  on;|include /etc/nginx/vhost.d/*.conf;|g' /etc/nginx/nginx.conf && \
    \
    # Creat custom config
    mkdir /etc/nginx/custom.d && \
    sed -i '/vhost.d\/\*.conf;$/{N;s|$|    include /etc/nginx/custom.d/*.conf;|g}' /etc/nginx/nginx.conf && \
    \
    # Create ssl config
    echo $'\
ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE\n\
ssl_prefer_server_ciphers on;\n\
    ' > /etc/nginx/custom.d/ssl.conf && \
    # Create gzip config
    echo $'\
gzip  on;\
    ' > /etc/nginx/custom.d/gzip.conf && \
    \
    # Create temp and cache file options for user nginx
    echo $'\
client_body_temp_path /tmp/client_body;\n\
fastcgi_temp_path /tmp/fastcgi_temp;\n\
proxy_temp_path /tmp/proxy_temp;\n\
scgi_temp_path /tmp/scgi_temp;\n\
uwsgi_temp_path /tmp/uwsgi_temp;\n\
    ' > /etc/nginx/custom.d/cache-file-options.conf

VOLUME [ "/etc/nginx/conf.d" ]
VOLUME [ "/etc/nginx/vhost.d" ]

ENV \
    SERVER_IP="" \
    TZ="Europe/Vienna"

EXPOSE \
    80 \
    443

COPY --chown=nginx:nginx envsubst.sh /envsubst.sh

USER nginx

ENTRYPOINT [ "/envsubst.sh", "tini", "-g", "--" ]
CMD [ "nginx", "-g", "daemon off;" ]