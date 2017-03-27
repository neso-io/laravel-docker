#!/bin/bash

webroot=/www

cd /www
chown -Rf www:www *

if [ -f "/www/composer.lock" ]; then
  composer install --no-dev
fi

sudo chgrp -R www storage bootstrap/cache
sudo chmod -R ug+rwx storage bootstrap/cache


exec /usr/bin/supervisord -n -c /etc/supervisord.conf
