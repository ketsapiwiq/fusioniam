mkdir -p run/volumes/ldap-data run/volumes/ldap-config


mkdir -p run/volumes/wp-run

mkdir -p run/volumes/sso-data
mkdir -p run/volumes/llng-run
mkdir -p run/volumes/llng-cache
mkdir -p run/volumes/llng-keys


openssl req -new -newkey rsa:4096 -keyout run/volumes/llng-keys/saml.key -nodes -out run/volumes/llng-keys/saml.pem -x509 -days 3650
openssl genrsa -out run/volumes/llng-keys/oidc.key 4096
openssl rsa -pubout -in run/volumes/llng-keys/oidc.key -out run/volumes/llng-keys/oidc_pub.key

chown 48:48 -R run/volumes/llng-*