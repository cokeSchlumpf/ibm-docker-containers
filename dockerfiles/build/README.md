# Buildserver Docker Image (ibm/build)

This docker image contains a complete buildserver with the following features:

* Artifactory
* Git
* GitLab
* Java 8
* Jenkins
* Maven
* NPM managed by NVM

The image is based on [base-dev](../base-dev). Detailed versions are defined within the Dockerfile.

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
  -v ~/.m2:/root/.m2 \
  -v ~/.npm:/root/.npm \
  --hostname build \
  --name build \
  ibm/build
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
  -v ~/.m2:/root/.m2 \
  -v ~/.npm:/root/.npm \
  --hostname build \
  --name build \
  ibm/build
```

Due to a [bug](https://github.com/boot2docker/boot2docker/issues/581) in boot2docker on Mac OS it's currently not possible to use a local directory from Mac OS as gitlab Home directory:

```
mkdir -p \
  ~/docker-data/artifactory \
  ~/docker-data/jenkins \
&& docker run -id \
  -p 8080:8080 \
  -p 9080:9080 \
  -p 222:22 \
  -v ~/docker-data/artifactory:/var/opt/artifactory \
  -v /var/opt/gitlab \
  -v ~/docker-data/jenkins:/var/opt/jenkins \
  -v ~/.m2:/root/.m2 \
  -v ~/.npm:/root/.npm \
  --hostname build \
  --name build \
  ibm/build
```

Alternatively you could use a [data volume container](./build-dvc) for the purpose.

**Note:** It's important that you use 9080 and 222 as external ports as shown in the example due to the configuration of gitlab. You should also made your docker host available via `build` in `/etc/hosts`.

It may take a few minutes until all applications are started up. To check if everything started up, you can use:

```
> docker logs -f build
[...]
gitlab Reconfigured! # Indicates that everything is started up.
```

Afterwords you can access:

* `http://build:8080/artifactory` for Artifactory Web UI
* `http://build:8080/jenkins` for Jenkins Web UI
* `http://build:9080` for GitLab Web UI

### Necessary configuration after first startup

The initial Log-In for GitLab is:

```
root
5iveL!fe
```

You must login with this user and change the password. You may create additional users in GitLab afterwords.

To allow Jenkins to access the git repositories execute the following steps:

* Go to gitlab and create as user for Jenkins with `jenkins@buildserver.com` as mail address.
* For this user, add the SSH-Key you obtain from the Buildserver in the following way:

```
# On docker host
> docker exec -it build /bin/bash -c "cat ~/.ssh/id_rsa.pub"
```

* Ensure that every project you'd like to manage with Jenkins needs to have the Jenkins Gitlab user as member (if the project is private).

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
docker build -t ibm/build .
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
