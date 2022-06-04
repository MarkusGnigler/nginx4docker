# Change Log V1.0.0

- Logging
    I decide after i run a while the bare nginx container to follow docker's best practice and logg all nginx logs to StdOut
    ```bash    
    ## Set error logging to StdOut
    sed -i 's|/var/log/nginx/error.log|/dev/stdout|g' /etc/nginx/nginx.conf && \
    ## Set access logging to StdOut
    sed -i 's|/var/log/nginx/access.log|/dev/stdout|g' /etc/nginx/nginx.conf && \
    ```

- Configuration folder
    To configure the base webserver you can create `.conf` files in conf.d folder.
    ```bash
    # rm -f /etc/nginx/conf.d/default.conf && \
    echo "" /etc/nginx/conf.d/default.conf && \
    ```

- Create seperate vhost.d folder
    In order to seperate the concerns, i think it's a better solution to create a vhost folder link apache does
    ```bash
    ## Import vhosts from vhost.d
    mkdir /etc/nginx/vhost.d && \
    sed -i 's|#gzip  on;|#gzip  on; \n    include /etc/nginx/vhost.d/*.conf;|g' /etc/nginx/nginx.conf
    ```

- Hardening docker
    To prevent root access i switch to nginx user and map all file patrhs to `/tmp`
    ```dockerfile
    USER nginx
    ```

    ```bash
    sed -i 's|user  nginx;||g' /etc/nginx/nginx.conf && \
    sed -i 's|pid        /var/run/nginx.pid;|pid        /tmp/nginx.pid;|g' /etc/nginx/nginx.conf && \
    ```

    ```bash
            echo $'\
    client_body_temp_path /tmp/client_body;\n\
    fastcgi_temp_path /tmp/fastcgi_temp;\n\
    proxy_temp_path /tmp/proxy_temp;\n\
    scgi_temp_path /tmp/scgi_temp;\n\
    uwsgi_temp_path /tmp/uwsgi_temp;\n\
        ' > /etc/nginx/conf.d/cache-file-options.conf
    ```

- Add general valid configs for gzip and ssl
    ```bash
        echo $'\
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE\n\
    ssl_prefer_server_ciphers on;\n\
        ' > /etc/nginx/conf.d/ssl.conf
    ```
    ```bash
        echo $'\
    gzip  on;\
        ' > /etc/nginx/conf.d/gzip.conf
    ```

- Remove version number `server_tokens off;`

    ```bash
    sed -i 's|http {|http {\n    server_tokens off;|g' /etc/nginx/nginx.conf
    ```

- Add envsubst
    The following variables will be replaced

    * $NGINX_HOST or ${NGINX_HOST}
    * $NGINX_DOMAIN or ${NGINX_DOMAIN}
    * $NGINX_CERT or ${NGINX_CERT}

- Add ssl_ciphers for better ssl communication
    Create key on first startup
    ```
    [ -f "/etc/nginx/ssl/certsdhparam.pem" ] || libressl dhparam -out /etc/nginx/ssl/certsdhparam.pem 4096
    ```

    Add security header
    ```
    ssl_protocols TLSv1.3 TLSv1.2;\n\
    ssl_prefer_server_ciphers on;\n\
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;\n\
    \
    # DH parameters and curve
    ssl_dhparam /etc/nginx/ssl/certsdhparam.pem;\n\
    ssl_ecdh_curve secp384r1;\n\
    ```