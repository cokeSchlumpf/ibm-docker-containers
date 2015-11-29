# HTTP Server Docker Image (ibm/http-server)

This docker image starts a simple HTTP Server serving files located in `var/opt/http` on port `8080`.

## Run the image

Start the image with the following command:

```
docker run -id \
  --privileged=true \
  -v ~/installation-files:/var/opt/http \
  -P \
  --name http-server \
  --hostname http-server \
  ibm/http-server
```

### Available volumes

The image offers the following persistent volumes:

* `/var/opt/http` - Files served via HTTP

### Available ports

The container exposes the following ports:

* `8080` - HTTP Port which serves the files

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/http-server .
```
