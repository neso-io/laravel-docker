#!/bin/bash

webroot=/www

cd /www
chown -Rf www:www *

if [ -f "/www/composer.lock" ]; then
  php composer.phar install --no-dev
fi

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
