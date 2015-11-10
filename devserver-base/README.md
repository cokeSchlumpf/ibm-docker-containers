# Development Base Server Docker Image

This docker image contains a base development server to develop JEE based web applications with the following features:

* Git
* Java 8
* Maven
* NPM managed by NVM

Detailed versions are defined within the Dockerfile.

## Run the image

Don't run this image directly. Use [ibm/devserver](../devserver) instead.

### Available volumes

This image contains no volumes.

### Available ports

This image doesn't expose any ports.

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/devserver-base .
```

During the installation you need to make the following files available. Before running the build make sure that the versions defined in the Dockerfile are available in `installation-files`. See also [installation-files](../installation-files).

```
installation-files
  └ jdk
    └ jdk_${TOMCAT_VERSION}.tar.gz
```
