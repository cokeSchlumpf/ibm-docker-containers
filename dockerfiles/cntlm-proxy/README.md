# NTLM based proxy server (ibm/cntlm-proxy)

This docker image starts a NTLM based proxy on port `3128`.

## Run the image

Start the image with the following command:

```
docker run -id \
  --privileged=true \
  -v /etc/cntlm.conf:/etc/cntlm.conf \
  -p 5865:3128 \
  -P \
  --name cntlm-proxy \
  --hostname cntlm-proxy \
  ibm/cntlm-proxy
```

### Available ports

The container exposes the following ports:

* `3128` - Port which serves the proxy requests

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/cntlm-proxy.
```
