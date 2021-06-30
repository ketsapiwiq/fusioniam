# FusionIAM

This is the main [FusionIAM](https://www.fusioniam.org) project.

FusionIAM is a software federation to offer a global open source IAM solution.

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

A file named `ENVVAR` is mounted in every container root, all configuration settings are set in this file.

| Variable name                     | Description                                   |
|-----------------------------------|-----------------------------------------------|
| ACCCONFIGROOTPW                   | Password of OpenLDAP cn=config admin          |
| ACCDATAROOTPW                     | Password of OpenLDAP main database admin      |
| ADMIN_LDAP_PASSWORD               | Password of admin account                     |
| CUSTOMERID                        | ID of the organization / customer             |
| FUSIONDIRECTORY_LDAP_PASSWORD     | Password of FD service account                |
| FUSIONDIRECTORY_LDAP_USERNAME     | Identifier of FD service account              |
| LDAP_HOST                         | Hostname of LDAP server                       |
| LDAP_PORT                         | Port of LDAP server                           |
| LSC_LDAP_PASSWORD                 | Password of LSC service account               |
| LSC_LDAP_USERNAME                 | Identifier of LSC service account             |
| SERVICEDESK_LDAP_PASSWORD         | Password of SD service account                |
| SERVICEDESK_LDAP_USERNAME         | Identifier of SD service account              |
| WHITEPAGES_LDAP_PASSWORD          | Password of WP service account                |
| WHITEPAGES_LDAP_USERNAME          | Identifier of WP service account              |

An example in this file is available in `run/ENVVAR.example`.

### Launch containers

We use the following options:
* `-v /path/to/ENVVAR:/ENVVAR`: mount the ENVVAR file
* `--rm=true`: Remove old container
* `-p PORT:PORT`: bind ports
* `--name=NAME`: friendly name
* `--entrypoint='["command","arg1","arg2"]'`: override entryoint if needed
* `--detach=true`: detach container

#### Directory server

Start:
```
podman run \
  -v ./run/ENVVAR.example:/ENVVAR \
  --rm=true \
  -p 33389:33389 \
  --name=fusioniam-directory-server \
  --detach=true \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-openldap-ltb:v0.1
```

Stop:
```
podman stop fusioniam-directory-server
```

#### White pages

Start:
```
podman run \
  -v ./run/ENVVAR.example:/ENVVAR \
  --rm=true \
  -p 8080:8080 \
  --name=fusioniam-white-pages-nginx \
  --detach=true \
  --entrypoint='["/bin/bash","/run-ct.sh","nginx"]' \
  gitlab.ow2.org:4567/fusioniam/fusioniam/fusioniam-centos8-white-pages:v0.1
```

Stop:
```
podman stop fusioniam-white-pages-nginx
```
