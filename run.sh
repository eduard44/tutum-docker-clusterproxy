#!/bin/bash

if [ "${VIRTUAL_HOST}" = "**None**" ]; then
    unset VIRTUAL_HOST
fi

if [ "${SSL_CERT}" = "**None**" ]; then
    unset SSL_CERT
fi

if [ "${S3_SSL_CERT_FILE}" = "**None**" ]; then
    unset S3_SSL_CERT_FILE
fi

if [ -n "$S3_SSL_CERT_FILE" ]; then
    echo "SSL certificate provided"

    echo "Downloading certificate from S3..."

    aws s3 cp $S3_SSL_CERT_FILE /servercert.pem

    echo "Download complete"

    export SSL="ssl crt /servercert.pem"
else
    echo "No SSL certificate provided"
fi

exec python /haproxy.py 
