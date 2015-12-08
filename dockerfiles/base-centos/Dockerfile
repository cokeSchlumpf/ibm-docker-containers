# This docker image provides a basic CentOS Setup for further installations.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Define Proxy
ENV \
  http_proxy_disabled \
  https_proxy_disabled \
  no_proxy_disabled

# Install helpful tools
RUN yum -y update \
  && yum install -y nano wget tar unzip sudo which rsync \
  && yum -y clean all

RUN cat ~/.bashrc

CMD ["/bin/bash"]
