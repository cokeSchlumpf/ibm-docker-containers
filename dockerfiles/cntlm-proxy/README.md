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
./scripts/docker-build.sh --project base-dev --download-host "http://10.90.14.29" --download-port "11080"
./scripts/docker-build.sh --project dev --download-host "http://10.90.14.29" --download-port "11080"

touch ~/.gitconfig ~/.git-credentials \
  && docker run -id \
    -e UID=`id -u $(whoami)` \
    -e GID=`id -g $(whoami)` \
    -v ~/.gitconfig:/home/dev/.gitconfig \
    -v ~/.git-credentials:/home/dev/.git-credentials \
    -v ~/.m2:/home/dev/.m2 \
    -v ~/.npm:/home/dev/.npm \
    -v ~/.ssh:/home/dev/.ssh \
    -v ~/Workspaces:/var/opt/workspace \
    -p 7080:8080 \
    -p 7443:8443 \
    --name dev \
    --hostname dev \
    ibm/dev

./scripts/docker-dns.sh --dns 10.90.14.1 --domain rodenstock.com
```

## Building the image
You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/cntlm-proxy.
```
or
```
./scripts/docker-build.sh -p cntlm-proxy

docker run -id   --privileged=true   -v /etc/cntlm.conf:/etc/cntlm.conf   -p 5865:3128   -P   --name cntlm-proxy   --hostname cntlm-proxy   ibm/cntlm-proxy
```

## Starting or running the image
You can run an instance of the image with the following command (run the command from this directory):
```
docker start cntlm-proxy
```
