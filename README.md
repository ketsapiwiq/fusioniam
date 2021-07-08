# FusionIAM

This is the main [FusionIAM](https://www.fusioniam.org) project.

FusionIAM is a software federation to offer a global open source IAM solution.

| Short name | Long name                    | Technical component            |
|------------|------------------------------|--------------------------------|
| FIDS       | FusionIAM Directory Server   | OpenLDAP LTB                   |
| FIDM       | FusionIAM Directory Manager  | Fusion Directory               |
| FIAM       | FusionIAM Access Manager     | LemonLDAP::NG                  |
| FIWP       | FusionIAM White Pages        | LTB White Pages                |
| FISD       | FusionIAM Service Desk       | LTB Service Desk               |
| FISC       | FusionIAM Sync Connector     | LDAP Synchronization Connector |

## Build

### Prerequisites

To build container images, you need `podman` or `docker`.

### Create images

Go in `build/` and choose the subdirectory.

For example:
```
cd build/centos8
```

Then build all images:
```
make all
```

### Upload images

List  images:
```
podman images
```

FusionIAM developers can upload images to OW2 repository:
```
podman tag localhost/<image name>:<version> gitlab.ow2.org:4567/fusioniam/fusioniam/<image name>:<version>
podman push gitlab.ow2.org:4567/fusioniam/fusioniam/<image name>:<version>
```

## Run

### Configuration

Configuration parameters are set as environment variables.

| Variable name                     | Description                                   |
|-----------------------------------|-----------------------------------------------|
| ACCCONFIGROOTPW                   | Password of OpenLDAP cn=config admin          |
| ACCDATAROOTPW                     | Password of OpenLDAP main database admin      |
| ADMIN_LDAP_PASSWORD               | Password of admin account                     |
| CUSTOMERID                        | ID of the organization / customer             |
| FUSIONDIRECTORY_HOST              | Internal host for FD                          |
| FUSIONDIRECTORY_LDAP_PASSWORD     | Password of FD service account                |
| FUSIONDIRECTORY_LDAP_USERNAME     | Identifier of FD service account              |
| FUSIONDIRECTORY_NAME              | Virtual host name for FD                      |
| FUSIONDIRECTORY_PORT              | Internal port for FD                          |
| LDAP_HOST                         | Hostname of LDAP server                       |
| LDAP_PORT                         | Port of LDAP server                           |
| LEMONLDAP2_LDAP_PASSWORD          | Password of LL::NG service account            |
| LEMONLDAP2_LDAP_USERNAME          | Identifier of LL::NG service account          |
| LEMONLDAP2_OIDCPRIV               | Path to OIDC private key                      |
| LEMONLDAP2_OIDCPUB                | Path to OIDC public key                       |
| LEMONLDAP2_SAMLPRIV               | Path to SAML private key                      |
| LEMONLDAP2_SAMLPUB                | Path to SAML public key or certificate        |
| LEMONLDAP2_UNPROTECT_PHOTO_URL    | Allow unauthenticated access to user photo    |
| LEMONLDAP2_UNPROTECT_PROFILE_URL  | Allow unauthenticated access to user profile  |
| LSC_LDAP_PASSWORD                 | Password of LSC service account               |
| LSC_LDAP_USERNAME                 | Identifier of LSC service account             |
| POSTGRES_HOST                     | Host of database server                       |
| POSTGRES_PASSWORD                 | Password of database account                  |
| POSTGRES_PORT                     | Port of database server                       |
| POSTGRES_USER                     | Login of database account                     |
| SERVICEDESK_HOST                  | Internal host for SD                          |
| SERVICEDESK_LDAP_PASSWORD         | Password of SD service account                |
| SERVICEDESK_LDAP_USERNAME         | Identifier of SD service account              |
| SERVICEDESK_NAME                  | Virtual host name for SD                      |
| SERVICEDESK_PORT                  | Internal port for SD                          |
| WHITEPAGES_HOST                   | Internal host for WP                          |
| WHITEPAGES_LDAP_PASSWORD          | Password of WP service account                |
| WHITEPAGES_LDAP_USERNAME          | Identifier of WP service account              |
| WHITEPAGES_NAME                   | Virtual host name for WP                      |
| WHITEPAGES_PORT                   | Internal port for WP                          |

An example in this file is available in `run/ENVVAR.example`.

### Launch containers

We use the following options:
* `-env-file=/path/to/ENVVAR`: pass environment variables to container
* `-v`: mount volumes if needed
* `--rm=true`: Remove old container
* `-p HOST_IP:HOST_PORT:PORT`: bind container ports
* `--name=NAME`: friendly name
* `--entrypoint='["command","arg1","arg2"]'`: override entryoint if needed
* `--detach=true`: detach container
* `--no-hosts`: do not copy hosts file
* `--network=slirp4netns:allow_host_loopback=true`: connect to host loopback interface

| Service           | Internal port |
|-------------------|---------------|
| OpenLDAP LTB      | 33389         |
| PostgreSQL        | 33432         |
| LemonLDAP::NG     | 8080          |
| Fusion Directory  | 8081          |
| Service Desk      | 8082          |
| White Pages       | 8083          |

#### FIDS

Create directories for data and configuration:
```
mkdir -p run/volumes/ldap-data run/volumes/ldap-config
```

Start:
```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/ldap-data:/usr/local/openldap/var/openldap-data \
  -v ./run/volumes/ldap-config:/usr/local/openldap/etc/openldap/slapd.d \
  --rm=true \
  -p 127.0.0.1:33389:33389 \
  --name=fusioniam-directory-server \
  --detach=true \
  --no-hosts \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-openldap-ltb:v0.1
```

Stop:
```
podman stop fusioniam-directory-server
```

#### FIWP

Create the shared directory for socket:
```
mkdir -p run/volumes/wp-run
```

Start:
```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/wp-run:/run/php-fpm/ \
  --rm=true \
  --name=fusioniam-white-pages-php-fpm \
  --detach=true \
  --no-hosts \
  --network=slirp4netns:allow_host_loopback=true \
  --entrypoint='["/bin/bash","/run-ct.sh","php-fpm"]' \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-white-pages:v0.1
```

```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/wp-run:/var/run/php-fpm/ \
  --rm=true \
  -p 127.0.0.1:8083:8080 \
  --name=fusioniam-white-pages-nginx \
  --detach=true \
  --no-hosts \
  --entrypoint='["/bin/bash","/run-ct.sh","nginx"]' \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-white-pages:v0.1
```

Stop:
```
podman stop fusioniam-white-pages-nginx fusioniam-white-pages-php-fpm
```

#### FIAM

Create volumes:
```
mkdir -p run/volumes/sso-data
mkdir -p run/volumes/llng-run
mkdir -p run/volumes/llng-cache
mkdir -p run/volumes/llng-keys
```

Initialize keys for SAML and OpenID Connect services:
```
openssl req -new -newkey rsa:4096 -keyout run/volumes/llng-keys/saml.key -nodes -out run/volumes/llng-keys/saml.pem -x509 -days 3650
openssl genrsa -out run/volumes/llng-keys/oidc.key 4096
openssl rsa -pubout -in run/volumes/llng-keys/oidc.key -out run/volumes/llng-keys/oidc_pub.key
```

Change owner of volumes:
```
podman unshare chown 48:48 -R run/volumes/llng-*
```

Start database:
```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/sso-data:/var/lib/postgresql/data \
  --rm=true \
  -p 127.0.0.1:33432:5432 \
  --name=fusioniam-database \
  --detach=true \
  --no-hosts \
  docker.io/library/postgres
```

Start SSO server:
```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/llng-run:/run/llng-fastcgi-server \
  -v ./run/volumes/llng-cache:/var/cache/lemonldap-ng \
  -v ./run/volumes/llng-keys:/etc/lemonldap-ng-keys \
  --rm=true \
  --name=fusioniam-access-manager-fastcgi-server \
  --detach=true \
  --no-hosts \
  --network=slirp4netns:allow_host_loopback=true \
  --entrypoint='["/bin/bash","/run-ct.sh","llng-fastcgi-server"]' \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-lemonldap-ng:v0.1
```

```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/llng-run:/run/llng-fastcgi-server \
  -v ./run/volumes/llng-cache:/var/cache/lemonldap-ng \
  -v ./run/volumes/llng-keys:/etc/lemonldap-ng-keys \
  --rm=true \
  -p 127.0.0.1:8080:8080 \
  --name=fusioniam-access-manager-nginx \
  --detach=true \
  --no-hosts \
  --network=slirp4netns:allow_host_loopback=true \
  --entrypoint='["/bin/bash","/run-ct.sh","nginx"]' \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-lemonldap-ng:v0.1
```

```
podman run \
  --env-file=./run/ENVVAR.example \
  -v ./run/volumes/llng-run:/run/llng-fastcgi-server \
  -v ./run/volumes/llng-cache:/var/cache/lemonldap-ng \
  -v ./run/volumes/llng-keys:/etc/lemonldap-ng-keys \
  --rm=true \
  --name=fusioniam-access-manager-cron \
  --detach=true \
  --no-hosts \
  --network=slirp4netns:allow_host_loopback=true \
  --entrypoint='["/bin/bash","/run-ct.sh","purge-sessions"]' \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-lemonldap-ng:v0.1
```

### Start reverse proxy

On your host, start a reverse proxy that will connect to containers.

For example with Apache:
```
vi /etc/apache2/sites-available/demo-fusioniam.conf
```

```
<VirtualHost *:443>
  ServerName auth.demo.fusioniam.org
  ServerAlias manager.demo.fusioniam.org
  ServerAlias api-manager.demo.fusioniam.org
  ServerAlias wp.demo.fusioniam.org
  ServerAlias sd.demo.fusioniam.org
  ServerAlias fd.demo.fusioniam.org

  SSLEngine On
  SSLCertificateFile /etc/apache2/demo.fusioniam.org.pem
  SSLCertificateKeyFile /etc/apache2/demo.fusioniam.org.key

  ProxyPreserveHost on
  ProxyPass / http://localhost:8080/
  ProxyPassReverse / http://localhost:8080/
</VirtualHost>
```

```
a2ensite demo-fusioniam.conf
```

Configure DNS or add this to your `/etc/hosts`:
```
127.0.0.1       auth.demo.fusioniam.org manager.demo.fusioniam.org api-manager.demo.fusioniam.org wp.demo.fusioniam.org sd.demo.fusioniam.org fd.demo.fusioniam.org
```

Connect to https://auth.demo.fusioniam.org and authentication with `fusioniam-admin` account.
