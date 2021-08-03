#!/bin/sh
set -e

/bin/bash /run-playbook.sh /deploy.yaml

if [ "$1" = "nginx" ]
    then
        ln -sf /dev/stdout /var/log/nginx/access.log
        ln -sf /dev/stdout /var/log/nginx/error.log
        ln -sf /dev/stdout /var/log/nginx/manager-api.log
        ln -sf /dev/stdout /var/log/nginx/manager.log
        ln -sf /dev/stdout /var/log/nginx/portal.log
        /usr/sbin/nginx -g 'daemon off;'
elif [ "$1" = "llng-fastcgi-server" ]
    then
        sed 's/ //g' /etc/default/llng-fastcgi-server > /tmp/llng-fastcgi-server
        if [ $(id -u) -eq 0 ]; then
            /bin/bash  -c 'source /tmp/llng-fastcgi-server && /usr/libexec/lemonldap-ng/sbin/llng-fastcgi-server -u apache -g apache --foreground'
        else
            /bin/bash  -c 'source /tmp/llng-fastcgi-server && /usr/libexec/lemonldap-ng/sbin/llng-fastcgi-server --foreground'
        fi
elif [ "$1" = "purge-sessions" ]
    then
        while : ; do
            /usr/libexec/lemonldap-ng/bin/purgeCentralCache -d -f; sleep 600;
        done
fi

exit 0
