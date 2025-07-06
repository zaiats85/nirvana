FROM docker.io/library/php:8.2-fpm-alpine

# shopware breaks during bin/shop-administration.sh because of npm version
# see: https://github.com/shopware/administration/blob/trunk/Resources/app/administration/package.json
RUN apk --update --no-cache add \
    bash \
    curl \
    mysql-client \
    zlib-dev \
    libpng-dev \
    libzip-dev \
    icu-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    patch \
    nodejs \
    npm \
  && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    g++ \
  && docker-php-ext-install \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    zip \
    soap \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd \
  # apcu
  # -> really making things faster? at first i'd say NO...make sure!!
  && docker-php-source extract \
  && pecl install apcu \
  && docker-php-ext-enable apcu \
  && docker-php-source delete \
  # Install Composer
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --install-dir=/usr/bin/ --filename=composer \
  && php -r "unlink('composer-setup.php');" \
  # Cleanup
  && apk del .build-deps \
  && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

COPY ./ /
WORKDIR /srv/www
EXPOSE 9000