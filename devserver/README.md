# Development server Docker Image

This docker image contains a development server to develop JEE based web applications with the following features:

* Git
* Java 8
* Maven
* NPM managed by NVM

Detailed versions are defined within the Dockerfile.

## Run the image

Start the image with the following command:

```
docker run -id \
  -v ~/.m2:/root/.m2 \
  -v ~/.npm:/root/.npm \
  -v ~/Workspaces:/var/opt/workspace \
  -p 7080:80 \
  -p 7443:443 \
  --name devserver \
  --hostname devserver \
  ibm/devserver
```

Afterwords you are able to run build and tests within the container:

```
> docker exec -it devserver /bin/bash

root@devserver:/# cd /var/opt/workspace/${PROJECT_DIR}
root@devserver:/# npm install
```

### Available volumes

The image offers the following persistent volumes:

* `/var/opt/workspace` - Volume to mount workspace including necessary project folders and files
* `/root/.m2` - Local Maven repository and settings
* `/root/.npm` - Local NPM repository and settings

### Available ports

The container exposes the following ports:

* `80` - HTTP Port for testing
* `443` - HTTPS Port for testing

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/devserver .
```

During the installation you need to make the following files available. Before running the build make sure that the versions defined in the Dockerfile are available in `installation-files`. See also [installation-files](../installation-files).

```
installation-files
  └ jdk
    └ jdk_${TOMCAT_VERSION}.tar.gz
```
