#!/bin/bash

docker run -it --rm \
    --name n4d \
    --publish 80:80 \
    --env SERVER_IP=127.0.0.1 \
    --volume $(pwd)/default.conf:/etc/nginx/conf.d/default.conf \
    ghcr.io/MarkusGnigler/n4d:latest

exit 0