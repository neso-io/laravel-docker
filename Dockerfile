FROM alpine:3.5

RUN apk add --update tzdata supervisor bash

ADD config/supervisord.conf /etc/supervisord.conf

### Setup local timezone
RUN TIMEZONE="Europe/London" \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone

### Install NGINX
RUN apk add nginx

### Install PHP
RUN apk add php7 php7-fpm php7-mcrypt php7-mbstring php7-soap php7-openssl php7-phar php7-json php7-dom php7-pdo php7-zip php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-xmlrpc php7-iconv php7-curl php7-ctype
RUN ln -s /usr/bin/php7 /usr/bin/php

### Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer

### Setup NGINX
RUN adduser -D -u 1000 -g 'www' www \
    && mkdir -p /www \
    && chown -R www:www /var/lib/nginx \
    && chown -R www:www /www \
    && rm /etc/nginx/conf.d/default.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN rm -rf /etc/nginx/sites-available/*

ADD config/nginx/nginx.conf /etc/nginx/
ADD config/nginx/sites/* /etc/nginx/sites-available/
ADD config/nginx/default /www

### Setup PHP
ADD config/php-fpm.conf /etc/php7/php-fpm.conf


ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

VOLUME /www

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
