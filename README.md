
# NginxForDocker a Docker Ready Nginx Image

n4d extends the original nginx container.

The main purpose is to have a distribution and docker ready nginx container.

<!-- n4d is a distribution and docker ready nginx container. -->

<!-- It extends the original nginx container and create a new tag on every release from original nginx. -->

## Extensions

- Logging
    I decide after i run a while the bare nginx container to follow docker's best practice and logg all nginx logs to StdOut

- Configuration folder
    To configure the base webserver you can create `.conf` files in conf.d folder.

- Create seperate vhost.d folder
    In order to seperate the concerns, i think it's a better solution to create a vhost folder link apache does

- Hardening docker
    To prevent root access i switch to nginx user and map all file patrhs to `/tmp`

- Add general valid configs for gzip and ssl
    + gzip  on;

    + ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    + ssl_prefer_server_ciphers on;

- Remove version number `server_tokens off;`

## Environment variables

- $TZ
    Set's the timezone of this container (required in particular for logging)

- $HOST_IP
    This variable will be replaced on startup in all `vhost.d/*.conf` files
