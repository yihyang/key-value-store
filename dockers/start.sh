#!/bin/bash
# set -eux

composer dump-autoload --optimize

php artisan migrate --force

service php8.0-fpm stop
service supervisor start

chmod -R 777 storage/

/usr/sbin/nginx
/usr/sbin/php-fpm8.0 -O
