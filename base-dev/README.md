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

Optionally, you can set build-time environment variables (e.g. if you are running behind a proxy):

```
docker build \
  --build-arg http_proxy="http://proxy-web.group.local:3128"
  -t ibm/base-dev .
```

### Build time arguments

During build time you can set the following build-time arguments:

* `http_proxy`
* `https_proxy` - Default: `${http_proxy}`
* `no_proxy` - Default `docker,group.local,127.0.0.1,localhost`
* `DOWNLOAD_BASE_URL` - Default `http://http-server.docker:8080`

### Installation files

During the installation you need to make the following files available. Before running the build make sure that the versions defined in the Dockerfile are available in `installation-files`. See also [installation-files](../installation-files).

```
installation-files
  └ jdk
    └ jdk_${JDK_VERSION}.tar.gz
```
