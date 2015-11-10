# IBM WebSphere Liberty Profile Docker Image (ibm/wlp)

This docker image contains an IBM WebSphere Liberty Profile. It's based on [ibm/base-centos](../base-centos). See Dockerfile for version details.

## Run the image

Start the image with the following command:

```
docker run -id \
  -p 9080:9080 \
  -p 9443:9443 \
  -p 222:22 \
  -h wlp \
  -n wlp \
  ibm/wlp
```

The image installs an OpenSSH server and configures a user to connect via SSH:

```
ssh wlp@dockerhost -p 222 # password: wlp
```

### Available volumes

This image contains no volumes.

### Available ports

The image exposes the following ports:

* `9080` - Default HTTP Port.
* `9443` - Default HTTPS Port.
* `22` - SSH Port.

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/wlp .
```

During the installation you need to make the following files available. See also [installation-files](../installation-files).

```
installation-files
  └ websphere-liberty
    └ websphere-liberty_${WLP_VERSION}.zip
```
