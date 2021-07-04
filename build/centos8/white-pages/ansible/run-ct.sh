#!/bin/sh
set -e

echo "fusioniam:x:$(id -u):$(id -g):,,,:${HOME}:/bin/bash" >> /etc/passwd
echo "fusioniam:x:$(id -G | cut -d' ' -f 2)" >> /etc/group

cp /usr/share/white-pages/config.inc.php /usr/share/white-pages/conf/config.inc.php

/bin/bash /run-playbook.sh /deploy.yaml

if [ "$1" = "nginx" ]
then
        ln -s /dev/stdout /var/log/nginx/access.log
        ln -s /dev/stdout /var/log/nginx/error.log
        ln -s /dev/stdout /var/log/nginx/wp.access.log
        ln -s /dev/stdout /var/log/nginx/wp.error.log
        /usr/sbin/nginx -g 'daemon off;'
elif [ "$1" = "php-fpm" ]
then
        ln -s /dev/stdout /var/log/php-fpm/error.log
        ln -s /dev/stdout /var/log/php-fpm/www-error.log
        /usr/sbin/php-fpm --nodaemonize
fi

exit 0
