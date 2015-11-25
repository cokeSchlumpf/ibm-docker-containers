# Development Base Server Docker Image (ibm/base-dev)

This docker image contains a base development server to develop JEE based web applications with the following features:

* Git
* Java 8
* Maven
* NPM managed by NVM

Detailed versions are defined within the Dockerfile.

## Run the image

Don't run this image directly. Use [ibm/dev](../dev) instead.

### Available volumes

This image contains no volumes.

### Available ports

This image doesn't expose any ports.

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/base-dev .
```

To build the image behind a proxy use:

```
cat Dockerfile \
  | sed "s#http_proxy_disabled#$http_proxy=${http_proxy}#g" \
  | sed "s#https_proxy_disabled#$https_proxy=${https_proxy}#g" \
  | sed "s#no_proxy_disabled#no_proxy=\"`docker inspect http-server | grep "\"IPA" | awk -F\" '{ print $4":8080" }'`,docker,${no_proxy}\""
docker build -t ibm/base-dev -
```

### Installation files

During the installation you need to make the following files available. Before running the build make sure that the versions defined in the Dockerfile are available in `installation-files`. See also [installation-files](../installation-files).

```
installation-files
  └ jdk
    └ jdk_${JDK_VERSION}.tar.gz
```
