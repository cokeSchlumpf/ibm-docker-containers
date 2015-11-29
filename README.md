# IBM Docker Images

This project contains several dockerfiles to create images for the following purposes:

* `ibm/build` - A complete buildserver containing Jenkins, Artifactory and Gitlab. [More ...](./dockerfiles/build)
* `ibm/dev` - An image which can be used to run builds webapp maven projects with NodeJS during development. [More ...](./dockerfiles/dev)
* `ibm/http-server` - An image which provides installation-files via HTTP to build the other containers. [More ...](./dockerfiles/http-server)
* `ibm/iib` - A container containing IBM Integration Bus v9 for development and testing. [More...](./dockerfiles/ibm-iib)
* `ibm/wlp` - A container containing WebSphere Liberty Profile for running JEE Applications. [More...](./dockerfiles/ibm-wlp)

There some more abstract images. The dependencies between the images is shown below:

```
ubuntu:14.05
  | ibm/base-dev
  | ├ ibm/dev
  | └ ibm/build
  └ ibm/http-server

centos:6.6
  └ ibm/base-centos
    ├ ibm/iib
    └ ibm/wlp
```

## Image naming conventions

All image tags should start with `ibm/`. All base images which shouldn't be started as containers are prefixed with `base` e.g. `ibm/base-...`.

## Installation Files

Files which are used during image build process are located within [installation-files](./installation-files). The actual files are not contained within the repository due to large file sizes.

## Building the images

Some helpful scripts to manage docker and this repository are located within the [scripts](./scripts) directory. Depending on the goal and environment you need to execute different steps.

### Setup whole continuous build environment

The build-environment includes the build-server, as well as a test-environment for IBM Integration Bus and IBM WebSphere Liberty Profile. Execute the following steps to get everything up and running:

#### 1. Provide installation-files

You need to provide a directory containing all required installation files to build the images. See [installation-files](./installation-files).

#### 2. Set up DNS for docker network

For an easier communication between the containers, even during build-time of the images, you need to set-up a DNS-Server which will provide name-resolution for all running containers.

First, configure the docker daemon to use its network bridge IP for DNS:

* **docker-machine/ boot2docker**
  * Connect to your docker-machine via ssh `docker-machine ssh default`
  * Then edit the docker daemon properties `vi /var/lib/boot2docker/profile`
  * Insert `EXTRA_ARGS="--bip=172.17.42.1/16 --dns=172.17.42.1"`
  * Exit the SSH-Shell and restart the docker-machine `docker-machine restart default`
* **Native Linux Docker**
  * In new docker versions (>= 1.7) do `docker daemon --bip=172.17.42.1/16 --dns=172.17.42.1`, in older docker versions do `docker -d --bip=172.17.42.1/16 --dns=172.17.42.1`
  * Restart docker service `service docker restart`

**Note:** You can also pass the -dns flag to individual containers so that the DNS options only apply to specific containers and not everything started by the daemon. But what fun is that?

To create the DNS Server execute the `./scripts/docker-dns.sh`.

```
# Simple use-case
./scripts/docker-dns

# If you like to use your cooperate DNS
./scripts/docker-dns --dns 10.99.14.10
```

## Tips & Tricks
### Volumes on CentOS

If we want to use volumes on a CentOS Docker host we need to execute:

```
su -c "setenforce 0"
```

before...
