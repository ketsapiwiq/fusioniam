FVERSION=../VERSION

CTN=`which podman >/dev/null 2>&1 && echo podman || echo docker`
IMAGENAME="fusioniam-centos8"
VVERSION=`cat $(FVERSION)`

all:
	make -B base

base:
	$(CTN) build --no-cache -t $(IMAGENAME):$(VVERSION) .

clean:
	$(CTN) rmi -f $(IMAGENAME):$(VVERSION)
