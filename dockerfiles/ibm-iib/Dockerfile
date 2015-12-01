# This docker image provides a basic CentOS with IBM Integration Bus.
FROM ibm/base-centos
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Define Versions
ENV \
  DOWNLOAD_BASE_URL="http-server.docker:8080" \
  WMQ_VERSION=7.5.0.3 \
  IIB_VERSION=9.0.0.2

# Install helpful tools and IIB prerequisites
RUN yum -y update \
  && yum install -y glibc.i686 libgcc.x86_64 libgcc.i686 lsof \
  && yum -y clean all

# Install WebSphere MQ
RUN wget -O /tmp/websphere_mq.tar.gz ${DOWNLOAD_BASE_URL}/websphere-mq/websphere-mq_${WMQ_VERSION}.tar.gz \
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
RUN usermod -G mqbrkrs mqm \
  && useradd -G mqm --create-home --password $(echo "iibuser" | openssl passwd -1 -stdin) iibuser \
  && usermod -a -G mqbrkrs iibuser \
  && sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers

# Configure system, use lsof to overcome "Bad Interpreter Error"
COPY kernel-settings.sh /tmp/
RUN chmod +x /tmp/kernel-settings.sh \
  && lsof \
  && /tmp/kernel-settings.sh

# Copy in script files
COPY iib-manage.sh iib-env.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib-env.sh

# Expose ports from IIB to the outside world.
EXPOSE 1414 4414 7800

# Use mqm when starting up.
USER mqm

ENV \
  QUEUE_MGR_NAME=IIB_QM \
  BROKER_NAME=IIB_NODE \
  TERM=xterm

# Set entrypoint to run management script
ENTRYPOINT ["iib-manage.sh"]