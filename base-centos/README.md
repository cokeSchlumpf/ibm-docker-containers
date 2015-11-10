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
