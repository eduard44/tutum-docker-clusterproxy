#!/bin/bash

if [ "${SSL_CERT}" = "**None**" ]; then
    unset SSL_CERT 
fi

if [ -n "$SSL_CERT" ]; then
    echo "SSL certificate provided"
    echo -e "${SSL_CERT}" > /servercert.pem
    echo -e "${SSL_CA}" > /serverca.pem
    export SSL="ssl crt /servercert.pem ca-file /serverca.pem"
else
    echo "No SSL certificate provided"
fi

exec python /main.py 
