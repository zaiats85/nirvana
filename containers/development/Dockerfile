FROM ghcr.io/zaiats85/sw-php-fpm-8.2:v1.0

RUN apk add --no-cache \
    jq \
    git \
    make \
    rabbitmq-c \
    rabbitmq-c-dev && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS g++ linux-headers && \
    # Install xDebug
    pecl install xdebug-3.3.1 && \
    docker-php-ext-enable xdebug && \
    # install symfony development dependencies
    pecl install redis && \
    docker-php-ext-enable redis && \
    pecl install amqp && \
    docker-php-ext-enable amqp && \
    # Configure xDebug
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.discover_client_host=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    # Add PHP performance and memory configuration
    echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "max_input_vars = 3000" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "upload_max_filesize = 128M" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "opcache.enable = 1" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "opcache.memory_consumption = 256" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "opcache.max_accelerated_files = 20000" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "opcache.validate_timestamps = 1" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    echo "opcache.revalidate_freq = 0" >> /usr/local/etc/php/conf.d/99-shopware-performance.ini && \
    # Cleanup
    apk del .build-deps && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

# Verify PHP configuration is applied
RUN php -r "echo 'Memory Limit: ' . ini_get('memory_limit') . PHP_EOL;" && \
    php -r "echo 'Max Execution Time: ' . ini_get('max_execution_time') . PHP_EOL;"

COPY ./ /

WORKDIR /srv/www

EXPOSE 9000