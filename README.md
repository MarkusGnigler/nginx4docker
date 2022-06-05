
# NginxForDocker a Docker Ready Nginx Image

n4d extends the original nginx container.

The main purpose is to have a <!-- distribution and  --> docker ready nginx container.

n4d could also be extended with your custom env variables. 
only mount a file that lists all your env variables to docker `... --mount $(pwd)/CUSTOM_ENV:/ENV ...`

<!-- n4d is a distribution and docker ready nginx container. -->

<!-- It extends the original nginx container and create a new tag on every release from original nginx. -->

## Usage

Grab the image from github container registry

```bash
docker pull ghcr.io/markusgnigler/n4d:1.0
```

Example docker-compose.yml

```yml
version: '3'

services:

  proxy:
    image: ghcr.io/markusgnigler/n4d:latest
    container_name: proxy
    ports:
      - 80:80
      - 443:443
    environment:
      NGINX_HOST: 127.0.0.1
    volumes:
      - ./www:/var/www
      - ./vhost.d:/etc/nginx/vhost.d
```

More examples are in the .examples folder of this repository.

## Config

To secure the webserver it is possible to enable ssl with the config script.

Call the script on a running container

> NOTE: Generation of the Diffie–Hellman curve may take some time.

```
docker exec <CONTAINER_NAME> sh config.sh enable_ssl
```

To disable ssl call the disable function

```
docker exec <CONTAINER_NAME> sh config.sh disable_ssl
```

## Extensions

- Logging 
    I decide after i run a while the bare nginx container to follow docker's best practice and log all nginx logs to StdOut

- Configuration folder 
    To configure the base webserver you can create `.conf` files in conf.d folder.

- Create seperate vhost.d folder 
    In order to seperate the concerns, i think it's a better solution to create a vhost folder like apache does.

- Hardening docker 
    * Remove version number `server_tokens off;`
    * To prevent root access i switch to nginx user and map all file patrhs to `/tmp`

- Add general valid configs for gzip and ssl
    + gzip  on;

    + ssl_protocols TLSv1.3 TLSv1.2;
    + ssl_prefer_server_ciphers on;

- Add ssl_ciphers for better ssl communication
    Create cipher key with the build in config script.
    ```
    sh config.sh enable_ssl
    ```

    Add security header with "./config enable_ssl" from script.
    ```
    ssl_protocols TLSv1.3 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;

    # DH parameters and curv
    ssl_dhparam /etc/nginx/ssl/certsdhparam.pem;
    ssl_ecdh_curve secp384r1;
    ```

## Environment variables

- $TZ<br>
    Set's the timezone of this container (required in particular for logging)

- This variable will be replaced on startup in all `vhost.d/*.conf` files<br>
    * $NGINX_HOST or \${NGINX_HOST}
    * $NGINX_DOMAIN or \${NGINX_DOMAIN}
    * $NGINX_CERT or \${NGINX_CERT}
