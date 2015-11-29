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
export DOWNLOAD_HOST=`docker inspect http-server | grep "\"IPA" | awk -F\" '{ print $4 }'`
export DOWNLOAD_BASE_URL="${DOWNLOAD_HOST}:8080"
echo "Using ${DOWNLOAD_HOST}, ${DOWNLOAD_BASE_URL} ..."

cat Dockerfile \
  | sed "s#http_proxy_disabled#http_proxy=http://${http_proxy}#g" \
  | sed "s#https_proxy_disabled#https_proxy=http://${https_proxy}#g" \
  | sed "s#no_proxy_disabled#no_proxy=\"${DOWNLOAD_HOST},docker,${no_proxy}\"#g" \
  | sed "s#DOWNLOAD_BASE_URL=\"\([^\"]*\)\"#DOWNLOAD_BASE_URL=\"${DOWNLOAD_BASE_URL}\"#g" \
  > Dockerfile.proxy

docker build -t ibm/base-dev -f Dockerfile.proxy .
```

### Installation files

During the installation you need to make the following files available. Before running the build make sure that the versions defined in the Dockerfile are available in `installation-files`. See also [installation-files](../installation-files).

```
installation-files
  └ jdk
    └ jdk_${JDK_VERSION}.tar.gz
```
