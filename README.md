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
  ├ ibm/base-dev
  │ ├ ibm/dev
  │ └ ibm/build
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

## Scripts

The [scripts](./scripts) directory contains several management scripts. Ensure that the scripts are executable.

```
chmod +x ./scripts/*.sh
```

## Building the images

Depending on the goal and environment you need to execute different steps.

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
./scripts/docker-dns.sh

# If you like to use your cooperate DNS
./scripts/docker-dns.sh --dns 10.99.14.10
```

#### 3. Build all containers

Execute `docker-build-all` script:

```
# First run
./scripts/docker-build-all.sh --files ${INSTALLATION_FILES}

# Every other (with running http-server)
./scripts/docker-build-all.sh
```

This will build all images necessary for the build environment. Afterwards list docker images to check if everything is created:

```
./scripts/docker-exec.sh --args images
```

Result should look like:

```
REPOSITORY              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ibm/iib                 latest              561589f9ee3c        8 minutes ago       8.268 GB
ibm/wlp                 latest              e2dcd03d119f        45 hours ago        1.057 GB
ibm/base-centos         latest              5a4122d0721e        45 hours ago        461.3 MB
ibm/build               latest              4d78b9fa366a        45 hours ago        2.37 GB
ibm/base-dev            latest              1bf286835f2f        2 days ago          1.152 GB
ibm/http-server         latest              ff7785697601        2 days ago          211.4 MB
ibm/dev                 latest              7c2b0dd44e21        7 days ago          1.187 GB
ibm/build-dvc           latest              e58d548e657c        2 weeks ago         187.9 MB
ubuntu                  latest              e9ae3c220b23        3 weeks ago         187.9 MB
ubuntu                  14.04               1d073211c498        5 weeks ago         187.9 MB
centos                  6.6                 bec9806dbc09        6 weeks ago         202.6 MB
crosbymichael/skydock   latest              294adbed0885        20 months ago       510.7 MB
crosbymichael/skydns    latest              d7a3877e5c61        22 months ago       137.5 MB
```

#### 4. Create the build-dvc container

If not present, create the build-dvc container manually:

```
./scripts/docker-exec.sh --args ps -a | grep "build-dvc" || docker create \
  -v /var/opt/artifactory \
  -v /var/opt/gitlab \
  -v /var/opt/jenkins \
  --name build-dvc \
  ibm/build-dvc
```

#### 5. Start the build environment

Use docker-compose to start the build environment:

```
./scripts/docker-compose.sh --project build --cmd up -d
```

## Tips & Tricks
### Volumes on CentOS

If we want to use volumes on a CentOS Docker host we need to execute:

```
su -c "setenforce 0"
```

before...
