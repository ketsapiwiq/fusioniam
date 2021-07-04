FVERSION=../VERSION

CTN=`which podman >/dev/null 2>&1 && echo podman || echo docker`
IMAGENAME="fusioniam-centos8"
VVERSION=`cat $(FVERSION)`

all:
	make -B base
	make -B llng
	make -B openldap
	make -B whitepages

base:
	$(CTN) build --no-cache -t $(IMAGENAME):$(VVERSION) .

clean:
	$(CTN) rmi -f $(IMAGENAME):$(VVERSION)

llng:
	cd lemonldap-ng ; make -B all

openldap:
	cd openldap-ltb ; make -B all

whitepages:
	cd white-pages ; make -B all
