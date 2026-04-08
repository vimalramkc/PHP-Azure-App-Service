#!/usr/bin/env bash

echo "Setting up Datadog tracing for PHP"

DD_PHP_TRACER_VERSION=1.8.3
DD_PHP_TRACER_URL=https://github.com/DataDog/dd-trace-php/releases/download/${DD_PHP_TRACER_VERSION}/datadog-setup.php

if curl -LO --fail "${DD_PHP_TRACER_URL}"; then
    php datadog-setup.php --php-bin=all
else
    echo "Download failed"
fi

service nginx reload
