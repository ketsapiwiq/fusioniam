#!/bin/bash 

echo "fusioniam:x:$(id -u):$(id -G | cut -d' ' -f 2):,,,:${HOME}:/bin/bash" >> /etc/passwd
echo "fusioniam:x:$(id -G | cut -d' ' -f 2):" >> /etc/group

export FUSIONIAM_UID=$(id -u)
export FUSIONIAM_GID=$(id -G | cut -d' ' -f 2)

/bin/bash /run-playbook.sh /deploy.yaml

/usr/local/openldap/libexec/slapd -h "ldap://*:33389 ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi" -F /usr/local/openldap/etc/openldap/slapd.d -d 256
