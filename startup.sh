#!/usr/bin/env bash

echo "Setting up Datadog tracing for PHP"
DD_PHP_TRACER_VERSION=1.8.3
DD_PHP_TRACER_URL=https://github.com/DataDog/dd-trace-php/releases/download/${DD_PHP_TRACER_VERSION}/datadog-setup.php

echo "Installing PHP tracer from ${DD_PHP_TRACER_URL}"
if curl -LO --fail "${DD_PHP_TRACER_URL}"; then
    eval "php datadog-setup.php --php-bin=all"
else
    echo "Downloading the tracer was unsuccessful"
    return
fi

# This line is can be uncommented if the project contains an nginx configuration in the project root
# cp /home/site/wwwroot/default /etc/nginx/sites-available/default && service nginx reload

service nginx reload
