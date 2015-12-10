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

## Building the image prerequisites
```
# For more information see https://docs.docker.com/compose/install/
sudo -i curl -L https://github.com/docker/compose/releases/download/1.5.2/run.sh > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo service docker restart

# You can also set the domain (default is ibm.com)
./scripts/docker-dns.sh --dns 10.90.14.1 --domain rodenstock.com
```

## Building the image
You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/cntlm-proxy.
```
or via
```
./scripts/docker-build.sh -p cntlm-proxy

docker run -id   --privileged=true   -v /etc/cntlm.conf:/etc/cntlm.conf   -p 5865:3128   -P   --name cntlm-proxy   --hostname cntlm-proxy   ibm/cntlm-proxy
```

## Starting or running the image
You can run an instance of the image with the following command (run the command from this directory):
```
docker start cntlm-proxy
```
If the docker service has been stopped or has been restarted then it is necessary to start the dependent container in the following sequence:
```
docker start skydns
docker start skydock
docker start cntlm-proxy
```
