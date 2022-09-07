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