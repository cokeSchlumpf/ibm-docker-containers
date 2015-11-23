# This docker image provides a basic CentOS Setup for further installations.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

ENV \
  http_proxy=proxy-web.group.local:3128 \
  https_proxy=proxy-web.group.local:3128 \
  no_proxy="10.90.14.29,127.0.0.1,localhost"

# Install helpful tools
RUN yum -y update \
  && yum install -y nano wget tar unzip sudo which \
  && yum -y clean all

RUN ([ ! -z http_proxy ] && echo "http_proxy=${http_proxy}" >> ~/.bashrc) || exit 0
RUN ([ ! -z https_proxy ] && echo "https_proxy=${https_proxy}" >> ~/.bashrc) || exit 0
RUN ([ ! -z no_proxy ] && echo "no_proxy=${no_proxy}" >> ~/.bashrc) || exit 0

CMD ["/bin/bash"]
