FROM php:7.4.12-apache
LABEL maintainer "ledi.mambix@gmail.com"

#set our application folder as an environment variable
ARG debug_mode=""
ENV APP_HOME /var/www/html

#install all the system dependencies and enable PHP modules
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
      gd \
      intl \
      dom \
      xml \
      soap \
      pdo_mysql

# Enable apache2 modules
RUN a2enmod rewrite expires deflate setenvif headers filter include http2

# Set apache2 settings to run CakePHP from webroot folder
COPY rootfs /

# change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME
