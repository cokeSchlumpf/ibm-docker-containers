# Development Server Docker Image (ibm/dev)

This docker image contains a development server to develop JEE based web applications with the following features:

* Git
* Java 8
* Maven
* NPM managed by NVM

The image is based on [base-dev](../base-dev).

## Run the image

Start the image with the following command:

```
touch ~/.gitconfig ~/.git-credentials \
  && docker run -id \
    -v ~/.gitconfig:/root/.gitconfig \
    -v ~/.git-credentials:/root/.git-credentials \
    -v ~/.m2:/root/.m2 \
    -v ~/.npm:/root/.npm \
    -v ~/.ssh:/root/.ssh \
    -v ~/Workspaces:/var/opt/workspace \
    -p 7080:80 \
    -p 7443:443 \
    --name dev \
    --hostname dev \
    ibm/dev
```

If you like to share your workspace within a linux host you should provide your user UID and GID:

```
touch ~/.gitconfig ~/.git-credentials \
  && docker run -id \
    -e UID=`id -u $(whoami)` \
    -e GID=`id -g $(whoami)` \
    -v ~/.gitconfig:/root/.gitconfig \
    -v ~/.git-credentials:/root/.git-credentials \
    -v ~/.m2:/root/.m2 \
    -v ~/.npm:/root/.npm \
    -v ~/.ssh:/root/.ssh \
    -v ~/Workspaces:/var/opt/workspace \
    -p 7080:80 \
    -p 7443:443 \
    --name dev \
    --hostname dev \
    ibm/dev

# Afterwards you should run docker exec with -u option to use 'dev' user:
docker exec -it -u dev /bin/bash
```

Or, if you need to connect to a running [build container](../build):

```
touch ~/.gitconfig ~/.git-credentials \
  && docker run -id \
    -v ~/.gitconfig:/root/.gitconfig \
    -v ~/.git-credentials:/root/.git-credentials \
    -v ~/.m2:/root/.m2 \
    -v ~/.npm:/root/.npm \
    -v ~/.ssh:/root/.ssh \
    -v ~/Workspaces:/var/opt/workspace \
    -p 7080:80 \
    -p 7443:443 \
    --link build:build \
    --name dev \
    --hostname dev \
    ibm/dev
```

Afterwards you are able to run build and tests within the container:

```
> docker exec -it dev /bin/bash

root@devserver:/# cd /var/opt/workspace/${PROJECT_DIR}
root@devserver:/# npm install
```

### Available volumes

The image offers the following persistent volumes:

* `/var/opt/workspace` - Volume to mount workspace including necessary project folders and files
* `/root/.m2` - Local Maven repository and settings
* `/root/.npm` - Local NPM repository and settings

### Available ports

The container exposes the following ports:

* `80` - HTTP Port for testing
* `443` - HTTPS Port for testing

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/dev .
```
