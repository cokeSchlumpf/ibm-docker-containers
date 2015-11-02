# This docker image provides a Websphere Liberty Profile Server.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV WLP_VERSION 8.5.5
ENV DOWNLOAD_BASE_URL http://172.16.166.1:8080

# Install helpful tools and IIB prerequisites
RUN yum -y update && yum install -y nano wget tar && yum -y clean all

# Install WebSphere MQ
RUN wget -O /tmp/websphere-liberty.tar.gz ${DOWNLOAD_BASE_URL}/websphere-liberty/websphere-liberty_${WMQ_VERSION}.tar.gz \
  && cd /tmp \
  && tar -zxvf ./websphere-liberty.tar.gz /opt/wlp \
  && ls -l /opt && ls -l /opt/wlp

# Start Bash on Startup
CMD ["/bin/bash"]
