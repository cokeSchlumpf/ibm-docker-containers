# CentOS Base Docker Image

This docker image extends the base CentOS with some additional packages often needed:

* nano
* wget
* tar
* unzip
* sudo

## Run the image

The image can be run in the following way:

```
docker run -id ibm/centos-base
```

... but the indent of this image to be a base image for other images.

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/centos-base .
```
