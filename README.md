# IBM Docker Images

This project contains several docker containers for the following purposes:

* `ibm/buildserver` - A complete buildserver containing Jenkins, Artifactory and Gitlab. [More ...](./buildserver)
* `ibm/devserver` - An image which can be used to run builds webapp maven projects with NodeJS during development. [More ...](./devserver)
* `ibm/iib` - A container containing IBM Integration Bus v9 for development and testing. [More...](./ibm-iib)
* `ibm/im` - A container containing an installed IBM Installation Manager. Not used yet.
* `ibm/wlp` - A container containing WebSphere Liberty Profile for running JEE Applications. [More...](./ibm-wlp)

There some more abstract images. The dependencies between the images is shown below:

```
ubuntu:14.05
  └ ibm/devserver-base
    ├ ibm/devserver
    └ ibm/buildserver

centos:6.6
  └ ibm/centos-base
    ├ ibm/iib
    ├ ibm/im
    └ ibm/wlp
```

## Volumes on CentOS

If we want to use volumes on a CentOS Docker host we need to execute:

```
su -c "setenforce 0"
```

before...
