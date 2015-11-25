# scripts

This directory contains scripts for easier execution of docker management tasks.

## build-all.sh

This script builds all docker images.


Usage:

```
build-all [ -h | --help | OPTIONS ]
```

Options:
  * **-f|--files** - Directory which contains the installation files - must be an absolute path. 

## docker-build.sh

This script builds the docker image for the Dockerfile within the given directory, may modify proxy settings for Dockerfile if http_proxy is set within environment.


Usage:

```
docker-build [ -h | --help | OPTIONS ]
```

Options:
  * **-p|--project** - The project to be build, e.g. base-dev, ibm-iib, ... 
  * **-t|--tagname** - The tagname of the docker image - Will be prefixed with ibm/... *Optional. Default: ${PROJECT}.*

## docker-exec.sh

This script detects whether to call docker with sudo or not. Just calls docker with the given arguments.


Usage:

```
docker-exec [ -h | --help | OPTIONS ]
```

Options:
  * **--args** - Arguments passed to docker. 

