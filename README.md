
# n4d a Docker Ready Nginx Image

n4d is a distribution and docker ready nginx container.

It extends the original nginx container and create a new tag on every release from original nginx.

## Extensions

- Logging
    I decide after i run a while the bare nginx container to follow docker's best practice and logg all nginx logs to StdOut

- Configuration folder
    To configure the base webserver you can create `.conf` files in conf.d folder.

- Create seperate vhost.d folder
    In order to seperate the concerns, i think it's a better solution to create a vhost folder link apache does

## Environment variables

This container prepares a variable `SERVER_IP` that you can use in all `.conf` files for handling the host ip address.

Timezone can be set trough `TZ` as usual.

## Concultion
<!-- 
> NOTE: I removed the sophisticated include of ``
 -->
