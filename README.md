# Risotto API : Laravel API

This project was bootstrapped with [Create Laravel App](https://laravel.com/docs/9.x/installation).

## Exemple config to run project with Docker

### Dockerfile
```
FROM php:8.0.3-apache
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    wget \
    libonig-dev \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-configure gd \
    --with-libdir=lib64 \
    --enable-gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    && a2enmod rewrite \
    && a2enmod ssl
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"
```

### docker-compose.yml
```
risotto-api:
    build: ./risotto-api/
    container_name: risotto_api
    ports:
        - '8119:80'
    volumes:
        - ./apache-api.conf:/etc/apache2/sites-enabled/000-default.conf
        - ./risotto-api:/var/www/risotto-api
    links:
        - risotto_db:db

risotto_db:
    image: mysql:8.0.30
    container_name: risotto_db
    volumes:
        - ./mysql:/var/lib/mysql
    environment:
        - MYSQL_ROOT_PASSWORD=risotto

risotto_phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: risotto_phpmyadmin
    ports:
        - '8121:80'
    links:
        - risotto_db:db

risotto_fakesmtp:
    container_name: risotto_fakesmtp
    image: maildev/maildev
    ports:
        - '8122:80'
```