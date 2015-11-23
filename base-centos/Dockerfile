# This docker image provides a basic CentOS Setup for further installations.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

ENV \
  http_proxy_disabled=auto \
  https_proxy_disabled=auto \
  no_proxy="10.90.14.29,127.0.0.1,localhost"

# Install helpful tools
RUN yum -y update \
  && yum install -y nano wget tar unzip sudo which \
  && yum -y clean all

CMD ["/bin/bash"]
