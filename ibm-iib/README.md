# IBM Integration Bus v9 Docker Image

This docker image contains an IBM Integration Bus v9.

## Run the image
Start the image with the following command:
```
docker run -id \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 222:22 \
  -v /var/opt/artifactory \
  -v /var/opt/gitlab \
  -v /var/opt/jenkins \
  -h buildserver \
  -n buildserver \
  ibm/buildserver
```
It may take a few seconds until all applications are started up. If so you can access:

* `http://${DOCKER_HOST}:8080/artifactory` for Artifactory Web UI
* `http://${DOCKER_HOST}:8080/jenkins` for Jenkins Web UI
* `http://${DOCKER_HOST}:8081` for GitLab Web UI

### Available volumes

The image offers the following persistent volumes:

* `/var/opt/artifactory` - Artifactory configuration and repository
* `/var/opt/gitlab` - GitLab configuration and repositories
* `/var/opt/jenkins` - Jenkins configurations and projects

### Available ports

The image exposes the following ports:

* `22` - SSH Port for git remote access
* `8080` - Tomcat HTTP Port for artifactory and jenkins
* `8081` - GitLab HTTP Port

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
