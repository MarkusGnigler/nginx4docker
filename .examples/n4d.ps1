
docker run -it --rm `
    --name n4d `
    --publish 80:80 `
    --publish 443:443 `
    --env HOST_IP=127.0.0.1 `
    --volume ${PWD}/www:/var/www `
    --volume ${PWD}/vhost.d:/etc/nginx/vhost.d `
    ghcr.io/markusgnigler/n4d:latest

exit 0