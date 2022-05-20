#!/bin/bash

docker run -it --rm \
    --name n4d \
    --publish 80:80 \
    --publish 443:443 \
    --env HOST_IP=127.0.0.1 \
    --volume ${PWD}/www:/var/www \
    --volume $(pwd)/vhost.d:/etc/nginx/vhost.d \
    ghcr.io/MarkusGnigler/n4d:latest

exit 0