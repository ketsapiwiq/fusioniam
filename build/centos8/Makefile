FVERSION=../VERSION

CTN=`which podman >/dev/null 2>&1 && echo podman || echo docker`
VVERSION=`cat $(FVERSION)`

all:
	make -B base

base:
	$(CTN) build --no-cache -t fusioniam-centos8:$(VVERSION) .

clean:
	$(CTN) rmi -f fusioniam-centos8:$(VVERSION)
