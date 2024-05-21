FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        zip \
        unzip \
        libicu-dev \
        acl \
    && rm -rf /var/lib/apt/lists/*sdf

RUN a2enmod rewrite && service apache2 restart

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-configure intl && docker-php-ext-install intl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# See https://hub.docker.com/_/php Changing DocumentRoot
ENV DOC_ROOT /var/www/html/app/webroot
RUN sed -ri -e 's!/var/www/html!${DOC_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${DOC_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

ARG XDEBUG=false
RUN if [ "${XDEBUG}" = true ]; then \
        pecl install xdebug && docker-php-ext-enable xdebug; \
        { \
            echo "[xdebug]"; \
            echo "xdebug.mode=develop,debug,coverage"; \
            echo "xdebug.discover_client_host = true"; \
            echo "xdebug.client_host=172.17.0.1"; \
            echo "xdebug.client_port = 9003"; \
            echo "xdebug.max_nesting_level = 512"; \
            echo "xdebug.start_with_request=yes"; \
        } >> "$PHP_INI_DIR"/conf.d/xdebug.ini \
    ;fi
