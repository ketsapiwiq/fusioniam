#!/bin/sh
set -e

echo "fusioniam:x:$(id -u):$(id -G | cut -d' ' -f 2):,,,:${HOME}:/bin/bash" >> /etc/passwd
echo "fusioniam:x:$(id -G | cut -d' ' -f 2):" >> /etc/group

export FUSIONIAM_UID=$(id -u)
export FUSIONIAM_GID=$(id -G | cut -d' ' -f 2)

/bin/bash /run-playbook.sh /deploy.yaml

if [ "$1" = "nginx" ]
then
        ln -s /dev/stdout /var/log/nginx/access.log
        ln -s /dev/stdout /var/log/nginx/error.log
        ln -s /dev/stdout /var/log/nginx/manager-api.log
        ln -s /dev/stdout /var/log/nginx/manager.log
        ln -s /dev/stdout /var/log/nginx/portal.log
	/usr/sbin/nginx -g 'daemon off;'
elif [ "$1" = "llng-fastcgi-server" ]
    then
      sed 's/ //g' /etc/default/llng-fastcgi-server > /tmp/llng-fastcgi-server
      /bin/bash  -c 'source /tmp/llng-fastcgi-server && /usr/libexec/lemonldap-ng/sbin/llng-fastcgi-server --foreground'
elif [ "$1" = "purge-sessions" ]
    then
      while : ;
      do /usr/libexec/lemonldap-ng/bin/purgeCentralCache -d -f; sleep 600;
      done;
fi

exit 0
