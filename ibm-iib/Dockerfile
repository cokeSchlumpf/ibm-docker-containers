# This docker image provides a basic CentOS with IBM Integration Bus.
FROM centos:6.6
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV WMQ_VERSION 7.5.0.3
ENV IIB_VERSION 9.0
ENV DOWNLOAD_BASE_URL http://172.16.166.1:8080

# Install helpful tools and IIB prerequisites
RUN yum -y update && yum install -y nano wget tar glibc.i686 libgcc.x86_64 libgcc.i686 sudo && yum -y clean all

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

# Add IIB user
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs iibuser \
  && sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers.d/docker

# Configure system
COPY kernel_settings.sh /tmp/
RUN chmod +x /tmp/kernel_settings.sh && /tmp/kernel_settings.sh


# Copy in script files
COPY iib_manage.sh /usr/local/bin/
COPY iib_env.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib_env.sh

# Expose ports from IIB to the outside world.
EXPOSE 1414 4414 7800

# Set entrypoint to run management script
ENTRYPOINT ["iib_manage.sh"]
