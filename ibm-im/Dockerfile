# This docker image provides a basic CentOS with some additional tools and an IBM Installation Manager.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV IM_VERSION 1.6.2
ENV DOWNLOAD_BASE_URL http://172.16.166.1:8080

# Install helpful tools
RUN yum -y update && yum install -y nano wget tar

# Install IBM Installation Manager
RUN wget -O /tmp/installation_manager.tar.gz ${DOWNLOAD_BASE_URL}/installation-manager/installation_manager_${IM_VERSION}.tar.gz \
    && cd /tmp \
    && tar -zxvf ./installation_manager.tar.gz \
    && ls -l /tmp \
    && ls -l /tmp/installation_manager
