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
