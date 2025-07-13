FROM ghcr.io/zaiats85/node_22/sw-php-fpm-8.2_production:v3.0.2

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
  # Cleanup
  apk del .build-deps && \
  rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

COPY ./ /
WORKDIR /srv/www
EXPOSE 9000
