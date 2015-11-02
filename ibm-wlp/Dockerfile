# This docker image provides a Websphere Liberty Profile Server.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV WLP_VERSION 8.5.5.7
ENV DOWNLOAD_BASE_URL http://172.16.166.1:8080

# Install helpful tools and IIB prerequisites
RUN yum -y update && yum install -y nano wget unzip tar && yum -y clean all

# Install WebSphere MQ
RUN wget -O /tmp/websphere-liberty.zip ${DOWNLOAD_BASE_URL}/websphere-liberty/websphere-liberty_${WLP_VERSION}.zip \
  && cd /tmp \
  && unzip ./websphere-liberty.tar.gz -d /opt \
  && rm -rf /opt/._websphere-liberty /tmp/*

# Start Bash on Startup
CMD ["/bin/bash"]
