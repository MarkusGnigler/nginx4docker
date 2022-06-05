FROM nginx:1.21.6-alpine

LABEL \ 
    version=1.0.0 \
    maintainer="Markus Gnigler <markus.gnigler@bit-shifter.at>"

RUN \
    apk add --no-cache --update \
        tini \
        tzdata \
        libressl \
    && \
    # ssl
    mkdir /etc/letsencrypt && \
    cp /etc/ssl1.1/openssl.cnf /etc/ssl/openssl.cnf && \
    \
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
    # Import vhosts from vhost.d and remove default.conf
    rm -f /etc/nginx/conf.d/default.conf && \
    mkdir /etc/nginx/vhost.d && \
    mkdir /etc/nginx/internal-vhost.d && \
    # sed -i 's|#gzip  on;|include /etc/nginx/vhost.d/*.conf;|g' /etc/nginx/nginx.conf && \
    sed -i 's|#gzip  on;|include /etc/nginx/internal-vhost.d/*.conf;|g' /etc/nginx/nginx.conf && \
    # sed -i '/vhost.d\/\*.conf;$/{N;s|$|    include /etc/nginx/internal-vhost.d/*.conf;|g}' /etc/nginx/nginx.conf && \
    \
    # Creat custom config
    mkdir /etc/nginx/internal-config.d && \
    sed -i '/internal-vhost.d\/\*.conf;$/{N;s|$|\n    include /etc/nginx/internal-config.d/*.conf;\n|g}' /etc/nginx/nginx.conf && \
    \
    # Create ssl folder & standard config
    mkdir /etc/nginx/ssl && \
    echo $'\
ssl_protocols TLSv1.3 TLSv1.2;\n\
ssl_prefer_server_ciphers on;\n\
    ' > /etc/nginx/internal-config.d/ssl.conf && \
    # Create gzip config
    echo $'\
gzip  on;\
    ' > /etc/nginx/internal-config.d/gzip.conf && \
    \
    # Create temp and cache file options for user nginx
    echo $'\
client_body_temp_path /tmp/client_body;\n\
fastcgi_temp_path /tmp/fastcgi_temp;\n\
proxy_temp_path /tmp/proxy_temp;\n\
scgi_temp_path /tmp/scgi_temp;\n\
uwsgi_temp_path /tmp/uwsgi_temp;\n\
    ' > /etc/nginx/internal-config.d/cache-file-options.conf

VOLUME [ "/etc/nginx/conf.d" ]
VOLUME [ "/etc/nginx/vhost.d" ]
VOLUME [ "/etc/nginx/ssl" ]
VOLUME [ "etc/letsencrypt" ]

COPY --chown=nginx:nginx ENV /ENV
COPY --chown=nginx:nginx scripts/config.sh /config.sh
COPY --chown=nginx:nginx scripts/envsubst.sh /envsubst.sh
COPY --chown=nginx:nginx scripts/entrypoint.sh /entrypoint.sh

RUN \
    chmod +x /entrypoint.sh && \
    chmod 0777 /etc/nginx/ssl && \
    chmod 0777 /etc/nginx/vhost.d && \
    chmod 0777 -R /etc/letsencrypt && \
    chmod 0777 /etc/nginx/internal-vhost.d && \
    chmod 0777 /etc/nginx/internal-config.d

USER nginx

ENV \
    TZ="Europe/Vienna" \
    \
    NGINX_HOST='' \
    NGINX_DOMAIN='' \
    NGINX_CERT=''

EXPOSE \
    80 \
    443

ENTRYPOINT [ "/entrypoint.sh", "tini", "-g", "--" ]
CMD [ "nginx", "-g", "daemon off;" ]