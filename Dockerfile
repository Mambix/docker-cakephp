FROM php:7.2.14-apache AS build
LABEL maintainer "ledi.mambix@gmail.com"

#set our application folder as an environment variable
ARG debug_mode=""
ENV APP_HOME /var/www/html
ENV PHP_VERSION 7.2.14
ENV PTHREADS_VERSION 3.1.6
WORKDIR /tmp

#install all the system dependencies and enable PHP modules 
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libxml2-dev \
    libpng-dev \
    libssl-dev \
    wget \
    mc \
    && rm -r /var/lib/apt/lists/*

#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# enable apache module rewrite
#RUN a2dismod mpm_prefork mpm_event
RUN a2enmod rewrite expires deflate setenvif headers filter include
#mpm_worker
# removed 'http2' module

RUN wget http://www.php.net/distributions/php-${PHP_VERSION}.tar.gz
RUN wget http://pecl.php.net/get/pthreads-${PTHREADS_VERSION}.tgz
RUN tar zxvf php-${PHP_VERSION}.tar.gz
#RUN tar zxvf pthreads-${PTHREADS_VERSION}.tgz

#RUN mv /tmp/pthreads-${PTHREADS_VERSION} /tmp/php-${PHP_VERSION}/ext/pthreads

#RUN pear channel-update pear.php.net
#RUN pear install PEAR

WORKDIR /tmp/php-${PHP_VERSION}
RUN rm -rf aclocal.m4
RUN rm -rf autom4te.cache/
RUN ./buildconf --force
RUN ./configure \
    --prefix=/usr/local \
    --enable-debug \
    --enable-cgi \
#    --with-pdo-mysql \
#    --enable-soap \
#    --with-gd \
#    --with-curl \
    --with-openssl \
    --enable-maintainer-zts \
    --with-config-file-path=/usr/local/etc
#    --enable-pthreads \
#    --with-php-config=/usr/local/bin/php-config \
#    --with-fpm-user=http \
#    --with-fpm-group=http \
#    --enable-fpm
RUN make clean
RUN make
RUN make install

RUN docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    dom \
    xml \
    soap \
#    pthreads \
    pdo_mysql

# # minify container
# 
# FROM php:7.2.14-apache
# LABEL maintainer "ledi.mambix@gmail.com"
# 
# #set our application folder as an environment variable
# ENV APP_HOME /var/www/html
# 
# #COPY --from=build /etc/apache2 /etc/apache2
# COPY --from=build /usr/lib/apache2 /usr/lib/apache2
# COPY rootfs /
# 
# #change ownership of our applications
# #RUN chown -R www-data:www-data $APP_HOME
# 
# #change ownership of our applications
# #RUN chown -R www-data:www-data $APP_HOME
