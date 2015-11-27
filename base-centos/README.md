# CentOS Base Docker Image (ibm/base-centos)

This docker image extends the base CentOS with some additional packages often needed:

* nano
* wget
* tar
* unzip
* sudo

## Run the image

The image can be run in the following way:

```
docker run -id ibm/base-centos
```

... but the indent of this image to be a base image for other images.

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/base-centos .
```

To build the image behind a proxy use:

```
export DOWNLOAD_HOST=`docker inspect http-server | grep "\"IPA" | awk -F\" '{ print $4 }'`
export DOWNLOAD_BASE_URL="${DOWNLOAD_HOST}:8080"
echo "Using ${DOWNLOAD_HOST}, ${DOWNLOAD_BASE_URL} ..."

cat Dockerfile \
  | sed "s#http_proxy_disabled#http_proxy=${http_proxy}#g" \
  | sed "s#https_proxy_disabled#https_proxy=${https_proxy}#g" \
  | sed "s#no_proxy_disabled#no_proxy=\"${DOWNLOAD_HOST},docker,${no_proxy}\"#g" \
  | sed "s#DOWNLOAD_BASE_URL=\"\([^\"]*\)\"#DOWNLOAD_BASE_URL=\"${DOWNLOAD_BASE_URL}\"#g" \
  > Dockerfile.proxy

docker build -t ibm/base-centos -f Dockerfile.proxy .
```
