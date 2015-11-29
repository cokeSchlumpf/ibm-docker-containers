# IBM Integration Bus v9 Docker Image (ibm/iib)

This docker image contains an IBM Integration Bus v9. It's based on [ibm/base-centos](../base-centos). See Dockerfile for version details.

## Run the image
Start the image with the following command:
```
docker run -id \
  -h iib \
  -n iib \
  ibm/iib
```

### Available volumes

This image contains no volumes.

### Available ports

The image exposes the following ports:

* `1414` - Remote Admin port.
* `4414` - Web Admin port.
* `7800` - Default HTTP Port for SOAP- and HTTP Input Nodes.

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/iib .
```

During the installation you need to make the following files available. See also [installation-files](../installation-files).

```
installation-files
  ├ integrationbus
  │ └ integrationbus_${IIB_VERSION}.tar.gz
  └ websphere-mq
    └ websphere-mq_${WMQ_VERSION}.tar.gz
```
