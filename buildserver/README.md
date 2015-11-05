# Buildserver Docker Image

This docker image contains a complete buildserver with the following features:

* Artifactory
* GitLab
* Java 8
* Jenkins
* Maven

Detailed versions are defined within the Dockerfile.

## Run the image
Start the image with the following command:
```
docker run -id \
  -p 8080:8080 \
  -p 9080:9080 \
  -p 222:22 \
  -v /var/opt/artifactory \
  -v /var/opt/gitlab \
  -v /var/opt/jenkins \
  --hostname buildserver \
  --name buildserver \
  ibm/buildserver
```
**Note:** It's important that you use 9080 and 222 as external ports as shown in the example due to the configuration of gitlab. You should also made your docker host available via `buildserver` in `/etc/hosts`.

It may take a few minutes until all applications are started up. If so you can access:

* `http://${DOCKER_HOST}:8080/artifactory` for Artifactory Web UI
* `http://${DOCKER_HOST}:8080/jenkins` for Jenkins Web UI
* `http://${DOCKER_HOST}:9080` for GitLab Web UI

### Available volumes

The image offers the following persistent volumes:

* `/var/opt/artifactory` - Artifactory configuration and repository
* `/var/opt/gitlab` - GitLab data
* `/var/opt/jenkins` - Jenkins configurations and projects

### Available ports

The image exposes the following ports:

* `22` - SSH Port for git remote access
* `8080` - Tomcat HTTP Port for artifactory and jenkins
* `9080` - GitLab HTTP Port

## Building the image

You can build the image with the following command (run the command from this directory):

```
docker build -t ibm/buildserver .
```

During the installation you need to make the following files available. See also [installation-files](../installation-files).

```
installation-files
  ├ apache-tomcat
  │ └ apache-tomcat_${TOMCAT_VERSION}.tar.gz
  ├ artifactory
  │ └ artifactory_${ARTIFACTORY_VERSION}.war
  ├ jdk
  │ └ jdk_${JDK_VERSION}.tar.gz
  └ jenkins
    └ jenkins_${JENKINS_VERSION}.war
```
