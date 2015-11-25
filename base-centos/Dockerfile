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
  && yum install -y nano wget tar unzip sudo which \
  && yum -y clean all

RUN ([ ! -z http_proxy ] && echo "http_proxy=proxy-web.group.local:3128 " >> ~/.bashrc) || exit 0
RUN ([ ! -z https_proxy ] && echo "https_proxy=proxy-web.group.local:3128 " >> ~/.bashrc) || exit 0
RUN ([ ! -z no_proxy ] && echo "no_proxy=${no_proxy} " >> ~/.bashrc) || exit 0

RUN cat ~/.bashrc

CMD ["/bin/bash"]
