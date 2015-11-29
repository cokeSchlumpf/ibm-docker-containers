# scripts

This directory contains scripts for easier execution of docker management tasks.

## docker-build-all.sh

This script builds all docker images.


Usage:

```
docker-build-all [ -h | --help | OPTIONS ]
```

Options:
  * **-f|--files** - Directory which contains the installation files - must be an absolute path. *Optional.*

## docker-build.sh

This script builds the docker image for the Dockerfile within the given directory, may modify proxy settings for Dockerfile if http_proxy is set within environment.


Usage:

```
docker-build [ -h | --help | OPTIONS ]
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
docker-clean [ -h | --help | OPTIONS ]
```


## docker-compose.sh

This script creates a docker-compose.yml from compose/_PROJECT_/docker-compose.abstract.yml and executes it.


Usage:

```
docker-compose [ -h | --help | OPTIONS ]
```

Options:
  * **-p|--project** - compose project to be used. 
  * **-c|--cmd** - docker-compose command. 
  * **-y|--yaml** - The yaml file to be used. *Optional. Default: ../compose/${PROJECT}/docker-compose.yml.*
  * **-a|--args** - Arguments which will be replaced in the form key=value,key=value,... *Optional.*

## docker-dns.sh

This script sets up the DNS environment for docker containers.


Usage:

```
docker-dns [ -h | --help | OPTIONS ]
```

Options:
  * **--dns** - DNS Server to be used for forwarded DNS calls (calls outside docker). *Optional. Default: 8.8.8.8.*
  * **--domain** - The domain to be used within the docker network. *Optional. Default: ibm.com.*
  * **--docker-machine-name** - Name of docker-machine if running with docker-machine. *Optional. Default: default.*

## docker-exec.sh

This script detects whether to call docker with sudo or not. Just calls docker with the given arguments.


Usage:

```
docker-exec [ -h | --help | OPTIONS ]
```

Options:
  * **--args** - Arguments passed to docker. 

## sed.sh

This script checks for different versions of sed and executes inplace replacement.


Usage:

```
sed [ -h | --help | OPTIONS ]
```

Options:
  * **-a|--args** - Arguments passed to sed. 

