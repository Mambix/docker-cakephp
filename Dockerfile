FROM php:7.4.12-zts
LABEL maintainer "ledi.mambix@gmail.com"

#set our application folder as an environment variable
ARG debug_mode=""
ENV APP_HOME /var/www/html

#install all the system dependencies and enable PHP modules
RUN set -ex \
    && apt-get update && apt-get install -y \
    apache2 \
    libicu-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
      gd \
      intl \
      dom \
      xml \
      soap \
      pdo_mysql

# Enable apache2 modules
RUN a2dismod mpm_event mpm_prefork
RUN a2enmod rewrite expires deflate setenvif headers filter include mpm_worker http2

# Set apache2 settings to run CakePHP from webroot folder
COPY rootfs /

# change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME

# sodium was built as a shared module (so that it can be replaced later if so desired), so let's enable it too (https://github.com/docker-library/php/issues/598)
RUN docker-php-ext-enable sodium

ENTRYPOINT ["docker-php-entrypoint"]
# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL SIGWINCH

WORKDIR /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
