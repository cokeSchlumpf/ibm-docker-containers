# IBM Docker Images

This project contains several docker containers for the following purposes:

* `ibm/build` - A complete buildserver containing Jenkins, Artifactory and Gitlab. [More ...](./build)
* `ibm/dev` - An image which can be used to run builds webapp maven projects with NodeJS during development. [More ...](./dev)
* `ibm/iib` - A container containing IBM Integration Bus v9 for development and testing. [More...](./ibm-iib)
* `ibm/wlp` - A container containing WebSphere Liberty Profile for running JEE Applications. [More...](./ibm-wlp)

There some more abstract images. The dependencies between the images is shown below:

```
ubuntu:14.05
  └ ibm/base-dev
    ├ ibm/dev
    └ ibm/build

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

Some helpful scripts to manage docker and this repository are located within the [scripts](./scripts) directory. There is also a script to build the images easily. Just execute the following steps:

* Serve the [installation-files](./installation-files) as described in the [installation-files/README.md](./installation-files/README.md).
* Make sure that you have configured `${http_proxy}` if required by your docker host machine, e.g. `export http_proxy=proxy-web.group.local:3128`.
* Execute the [scripts/build-all.sh](./scripts/build-all.sh), e.g. `build-all.sh -d localhost:8080`.

## Tips & Tricks
### Volumes on CentOS

If we want to use volumes on a CentOS Docker host we need to execute:

```
su -c "setenforce 0"
```

before...
