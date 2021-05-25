FVERSION=../VERSION

CTN=`which podman >/dev/null 2>&1 && echo podman || echo docker`
VERSION=`cat $(FVERSION)`

base:
	$(CTN) build --no-cache -t fusioniam-centos8:$(VERSION) .

all:
	make -B base

clean:
	$(CTN) rmi -f fusioniam-centos8:$(VERSION)
