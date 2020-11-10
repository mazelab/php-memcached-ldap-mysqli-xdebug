FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    apt-transport-https \ 
    apt-utils \ 
    iputils-ping \
    curl \
    openssh-client \ 
    git \ 
    mariadb-client 

# # install memcached extension
RUN apt-get install -y libz-dev libmemcached-dev
RUN pear config-set http_proxy "${HTTP_PROXY}"
RUN pecl install memcached
RUN docker-php-ext-enable memcached

# install gd extension
RUN apt-get install -y libfreetype6-dev \ 
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libpng-dev \
    libxml2-dev \
    autoconf \
    g++ \
    libtool \
    make 

RUN docker-php-ext-configure gd \ 
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --enable-gd 
RUN docker-php-ext-install gd

# install bcmath extension
RUN docker-php-ext-install bcmath

# install intl extension
RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl

# install soap extension
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

# install calendar extension
RUN docker-php-ext-install calendar

# install ldap extension
RUN apt install -y libldap2-dev
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap

# install mbstring extension
RUN apt-get install -y libonig-dev 
RUN docker-php-ext-install mbstring

# instal mysqli extension
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo pdo_mysql

# instal zip extension
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# configure apache2
RUN a2enmod rewrite

# xdebug
RUN pecl install xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.max_nesting_level=8192" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "date.timezone = Europe/Berlin" >> /usr/local/etc/php/conf.d/configuration.ini

RUN curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /usr/share/doc/*
