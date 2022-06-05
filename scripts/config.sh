#!/bin/bash

enable_ssl() {
   echo "Enable ssl ..."

   libressl dhparam -out /etc/nginx/ssl/certsdhparam.pem 4096
   echo "Cipher key generated."

   echo -e "\n"
   create_ssl_headers

   nginx -s reload
}

create_ssl_headers() {
   echo "Generate nginx config ..."

   cat << EOF > /etc/nginx/internal-config.d/ssl.conf
ssl_protocols TLSv1.3 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;

# DH parameters and curv
ssl_dhparam /etc/nginx/ssl/certsdhparam.pem;
ssl_ecdh_curve secp384r1;
EOF

   echo "Nginx config generated."
   echo -e "\n"

   nginx -s reload
}

disable_ssl() {
   echo "Disable ssl ..."

   rm -f /etc/nginx/ssl/certsdhparam.pem
   rm -f /etc/nginx/internal-config.d/ssl.conf
   
   echo "SSL disabled."
   echo -e "\n"
   
   nginx -s reload
}

case "$1" in
    "") ;;
    enable_ssl) "$@"; exit;;
    disable_ssl) "$@"; exit;;
    create_ssl_headers) "$@"; exit;;
    *) echo "Unkown function: $1()"; exit 2;;
esac

exit 0