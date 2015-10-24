# This docker image provides a basic CentOS with IBM Integration Bus.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV WMQ_VERSION 7.5.0.3
ENV IIB_VERSION 9.0
ENV DOWNLOAD_BASE_URL http://172.16.166.1:8080

# Install helpful tools and IIB prerequisites
RUN yum -y update && yum install -y nano wget tar glibc.i686 libgcc.x86_64 libgcc.i686 && yum -y clean all

# Install WebSphere MQ
RUN wget -O /tmp/websphere_mq.tar.gz ${DOWNLOAD_BASE_URL}/websphere-mq/websphere_mq_${WMQ_VERSION}.tar.gz \
  && cd /tmp \
  && tar -zxvf ./websphere_mq.tar.gz \
  && cd /tmp/websphere_mq \
  && ./mqlicense.sh -accept \
  && rpm -ivh MQSeriesRuntime-*.rpm MQSeriesServer-*.rpm MQSeriesSamples-*.rpm MQSeriesSDK-*.rpm MQSeriesAMS-*.rpm MQSeriesFT*.rpm MQSeriesJava-*.rpm MQSeriesJRE-*.rpm \
  && cd /opt/mqm/bin \
  && ./setmqinst -p /opt/mqm -i \
  && rm -rf /tmp/*

# Install Integration Bus
RUN wget -O /tmp/integrationbus.tar.gz ${DOWNLOAD_BASE_URL}/integrationbus/integrationbus_${IIB_VERSION}.tar.gz \
  && cd /tmp \
  && tar -zxvf ./integrationbus.tar.gz \
  && /tmp/integrationbus/setuplinuxx64 -i silent -DLICENSE_ACCEPTED=TRUE; echo $?; exit 0  \
  && /tmp/integrationbus/Integration_Toolkit/installToolkit-silent.sh \
  && rm -rf /tmp/*

# Expose ports from IIB to the outside world.
EXPOSE 1414 4414 7800

# Start Bash on Startup
CMD ["/bin/bash"]
