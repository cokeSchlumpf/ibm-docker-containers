# This docker image provides a basic CentOS with some additional tools and an IBM Installation Manager.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV DOWNLOAD_BASE_URL=http://192.168.2.108:8080 \
  IM_VERSION 1.6.2

# Install helpful tools
RUN yum -y update && yum install -y nano wget tar &&  yum -y clean all

# Install IBM Installation Manager
RUN wget -O /tmp/installation_manager.tar.gz ${DOWNLOAD_BASE_URL}/installation-manager/installation_manager_${IM_VERSION}.tar.gz \
    && cd /tmp \
    && tar -zxvf ./installation_manager.tar.gz \
    && mkdir /tmp/logs \
    && /tmp/installation_manager/installc -acceptLicense -log /tmp/logs/installation_manager_install.log \
    && rm -rf /tmp/installation_manager

# Start Bash on Startup
CMD ["/bin/bash"]
