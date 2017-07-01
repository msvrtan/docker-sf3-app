FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y software-properties-common python-software-properties

#add repo with newest PHP versions
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update

RUN apt-get install -y acl curl mysql-client nginx supervisor

RUN apt-get install -y --force-yes \
    supervisor \
    acl \
    mysql-client \
    php7.1-bcmath \
    php7.1-cli \
    php7.1-common \
    php7.1-curl \
    php7.1-fpm \
    php7.1-gd \
    php7.1-intl \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-xml \
    php7.1-zip \
    php-imagick \
    php-memcached \
    php-mongodb \
    php-redis \
    php-zip



#Set up PHP7-FPM folder
RUN mkdir /run/php
RUN chmod 777 /run/php/

# Create log folder for supervisor
RUN mkdir -p /var/log/supervisor


ADD supervisord.conf /etc/supervisor/conf.d/

ADD nginx/nginx.conf /etc/nginx/
ADD nginx/symfony-prod.conf /etc/nginx/sites-available/
ADD nginx/symfony-dev.conf /etc/nginx/sites-available/
ADD nginx/symfony-test.conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-available/default

RUN usermod -u 1000 www-data

# Source the bash
RUN . ~/.bashrc

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

EXPOSE 80

CMD ["/usr/bin/supervisord"]
