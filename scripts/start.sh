#!/bin/bash

webroot=/www

cd /www
chown -Rf www:www *

if [[ -z "${env}" ]]; then
    echo $env > .env
fi

if [ -f "/www/composer.lock" ]; then
    composer install --no-dev
fi

chgrp -R www storage bootstrap/cache
chmod -R ug+rwx storage bootstrap/cache

exec /usr/bin/supervisord -n -c /etc/supervisord.conf