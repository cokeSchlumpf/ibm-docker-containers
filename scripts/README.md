# scripts

This directory contains scripts for easier execution of docker management tasks.

## docker-build-all.sh

This script builds all docker images.

Usage:

```
docker-build-all.sh [ -h | --help | OPTIONS ]
```

Options:
  * **-f|--files** - Directory which contains the installation files - must be an absolute path. *Optional.*

## docker-build.sh

This script builds the docker image for the Dockerfile within the given directory, may modify proxy settings for Dockerfile if http_proxy is set within environment.

Usage:

```
docker-build.sh [ -h | --help | OPTIONS ]
```

Options:
  * **-p|--project** - The project to be build (directory names in dockerfiles/, e.g. base-dev, ibm-iib, ...). 
  * **-d|--download-host** - The host to download the installation files. *Optional.*
  * **-p|--download-port** - The of the download-host to download the installation files. *Optional. Default: 8080.*
  * **--no-download** - Set this argument to true if no download-host should be set. *Optional.*
  * **-t|--tagname** - The tagname of the docker image - Will be prefixed with 'ibm/...'. *Optional. Default: ${PROJECT}.*

## docker-clean.sh

This script cleans docker environment.

Usage:

```
docker-clean.sh [ -h | --help | OPTIONS ]
```


## docker-compose.sh

This script creates a docker-compose.yml from compose/_PROJECT_/docker-compose.abstract.yml and executes it.

Usage:

```
docker-compose.sh [ -h | --help | OPTIONS ]
```

Options:
  * **-p|--project** - compose project to be used. 
  * **-c|--cmd** - docker-compose command. 
  * **-y|--yaml** - The yaml file to be used. *Optional. Default: ../compose/${PROJECT}/docker-compose.yml.*
  * **-a|--args** - Arguments which will be replaced in the form key=value,key=value,... *Optional.*

## docker-dns.sh

This script sets up the DNS environment for docker containers.

This scripts starts a DNS environment based on [skydock](https://github.com/crosbymichael/skydock). Before running the script configure docker bridge ip and default DNS of docker daemon:

```
DOCKER_OPTS="--bip=172.17.42.1/16 --dns=172.17.42.1"
```

**NOTE:** You must restart the docker daemon after changing `DOCKER_OPTS`.

After running the script all docker containers can be reached from another container using ${CONTAINER_NAME}.${IMAGE_NAME}.docker.${DOMAIN}.

Usage:

```
docker-dns.sh [ -h | --help | OPTIONS ]
```

Options:
  * **--dns** - DNS Server to be used for forwarded DNS calls (calls outside docker). *Optional. Default: 8.8.8.8.*
  * **--domain** - The domain to be used within the docker network. *Optional. Default: ibm.com.*
  * **--docker-machine-name** - Name of docker-machine if running with docker-machine. *Optional. Default: default.*

## docker-exec.sh

This script detects whether to call docker with sudo or not. Just calls docker with the given arguments.

Usage:

```
docker-exec.sh [ -h | --help | OPTIONS ]
```

Options:
  * **--args** - Arguments passed to docker. 

## sed.sh

This script checks for different versions of sed and executes inplace replacement.

Usage:

```
sed.sh [ -h | --help | OPTIONS ]
```

Options:
  * **-a|--args** - Arguments passed to sed. 

