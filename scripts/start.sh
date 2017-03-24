#!/bin/bash

webroot=/www

chown -Rf www:www /www

if [ -f "$WEBROOT/composer.lock" ]; then
  php composer.phar install --no-dev
fi


exec /usr/bin/supervisord -n -c /etc/supervisord.conf
