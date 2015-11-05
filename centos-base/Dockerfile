# This docker image provides a basic CentOS Setup for further installations.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Install helpful tools
RUN yum -y update && yum install -y nano wget tar unzip sudo which && yum -y clean all

# Workaround to get nano running
ENV TERM=xterm

CMD ["/bin/bash"]
