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

# Add IIB user
RUN useradd --user-group --create-home --password $(echo "mqm" | openssl passwd -1 -stdin) mqm \
  && sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers

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

RUN usermod -G mqbrkrs mqm

# Install openssh-server to deploy applications
RUN yum install -y openssh-server openssh-clients

# Configure authorized keys
RUN mkdir -p /home/mqm/.ssh \
  && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyod44T9cOtQu8njkehz2aKiA4Nm6RiQc2AYcj7tjYwxRB0WGQcu4rUZVd2xbAfT0lWuDB5XPK5NPmgKrNEgWIDMPSKCH+9dLL6RRlU72vkBSgEQG6Rz5YVA2LMuJCycf3zFEvH0fYWqMdZiI4GAcKVBS73vtCd2rFKkRTmRKLoziGKqqsrkimXClS57mAiqCo0jrQxcf4V8jpGe+4NYXTk1rgeWozspy5CktmYN6NPDxLKVbeB7dwik2SVvF1592Fv8a5ZsRdvvNha9W8PZM+45p4pEiDcG0/5tct34V0OrhbqqZUJDcFYGOGhBHhDdmQ7T/5BQXQr28m6zdY1k9P jenkins@buildserver.com" >> /home/mqm/.ssh/authorized_keys \
  && chown -R mqm:mqm /home/mqm/.ssh \
  && chmod 700 /home/mqm/.ssh \
  && chmod 600 /home/mqm/.ssh/authorized_keys \
  && chown -R mqm:mqm /opt/mqm \
  && chown -R mqm:mqm /opt/ibm/mqsi

# Configure system, use lsof to overcome "Bad Interpreter Error"
COPY kernel-settings.sh /tmp/
RUN chmod +x /tmp/kernel-settings.sh \
  && lsof \
  && /tmp/kernel-settings.sh

# Copy in script files
COPY manage.sh manage-iib.sh manage-maven.sh iib-env.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib-env.sh

# Expose ports from IIB to the outside world.
EXPOSE 1414 4414 7800

# Install necessary tools for Jenkins access
RUN yum install -y java-1.7.0-openjdk git \
  && manage-maven.sh

ENV \
  QUEUE_MGR_NAME=IIB_QM \
  BROKER_NAME=IIB_NODE \
  TERM=xterm

# Set entrypoint to run management script
ENTRYPOINT ["manage.sh"]
