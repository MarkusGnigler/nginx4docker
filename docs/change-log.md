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