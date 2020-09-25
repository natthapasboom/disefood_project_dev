FROM php:7.3-fpm

RUN apt-get update \
&& apt-get install -y \
cron \
libfreetype6-dev \
libicu-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
libxslt1-dev \
libzip-dev \
openssh-server \
openssh-client \
rsync

RUN pecl install mcrypt-1.0.3

RUN docker-php-ext-enable \
mcrypt

RUN docker-php-ext-configure \
gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
bcmath \
gd \
intl \
mbstring \
pdo_mysql \
soap \
xsl \
zip

RUN curl -sS https://getcomposer.org/installer | \
php -- --install-dir=/usr/local/bin --filename=composer
