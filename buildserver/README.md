# Buildserver Docker Image

This docker image contains a complete buildserver with the following features:

* Artifactory
* Git
* GitLab
* Java 8
* Jenkins
* Maven
* NPM managed by NVM

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

If you would like to map the persistent volumes to a local directory do:

```
mkdir -p \
  ~/docker-data/artifactory \
  ~/docker-data/gitlab \
  ~/docker-data/jenkins \
&& docker run -id \
  -p 8080:8080 \
  -p 9080:9080 \
  -p 222:22 \
  -v ~/docker-data/artifactory:/var/opt/artifactory \
  -v ~/docker-data/gitlab:/var/opt/gitlab \
  -v ~/docker-data/jenkins:/var/opt/jenkins \
  --hostname buildserver \
  --name buildserver \
  ibm/buildserver
```

**Note:** It's important that you use 9080 and 222 as external ports as shown in the example due to the configuration of gitlab. You should also made your docker host available via `buildserver` in `/etc/hosts`.

It may take a few minutes until all applications are started up. To check if everything started up, you can use:

```
> docker logs -f buildserver
[...]
gitlab Reconfigured! # Indicates that everything is started up.
```

Afterwords you can access:

* `http://buildserver:8080/artifactory` for Artifactory Web UI
* `http://buildserver:8080/jenkins` for Jenkins Web UI
* `http://buildserver:9080` for GitLab Web UI

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

During the installation you need to make the following files available. Before running the build make sure that the versions defined in the Dockerfile are available in `installation-files`. See also [installation-files](../installation-files).

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
