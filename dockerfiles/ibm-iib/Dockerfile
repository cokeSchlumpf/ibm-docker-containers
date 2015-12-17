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

# As seperate RUN - There was a failure when attached to the previous run command
RUN usermod -G mqbrkrs mqm

# Install openssh-server to deploy applications
RUN wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm \
  && rpm -Uvh epel-release*rpm \
  && rm epel-release*rpm \
  && yum install -y openssh-server openssh-clients jq

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

# Add SSH-Keys to allow Jenkins to use SSH for Git
# The SSH Key which is added to known_hosts relates to the keys stored in ssh-keys.zip
COPY ssh-keys.own.zip /tmp/

# Install necessary tools for Jenkins access
# Install Java 8
RUN wget -O /tmp/jdk.tar.gz ${DOWNLOAD_BASE_URL}/jdk/jdk_${JDK_VERSION}.tar.gz \
  && cd /tmp \
  && tar -zxvf ./jdk.tar.gz \
  && mv /tmp/jdk${JDK_VERSION} /opt/jdk \
  && update-alternatives --install /usr/bin/java java /opt/jdk/bin/java 2 \
  && update-alternatives --install /usr/bin/jar jar /opt/jdk/bin/jar 2 \
  && update-alternatives --install /usr/bin/javac javac /opt/jdk/bin/javac 2 \
  && update-alternatives --set java /opt/jdk/bin/java \
  && update-alternatives --set jar /opt/jdk/bin/jar \
  && update-alternatives --set javac /opt/jdk/bin/javac \
  && rm -rf /tmp/* \
  && export JAVA_HOME=/opt/jdk \
  && export JRE_HOME=/opt/jdk/jre \
  && export PATH=$PATH:/opt/jdk/bin:/opt/jdk/jre/bin \
  && java -version \
  && which java \
  && manage-maven.sh \
  && ([ ! -z $http_proxy ] \
    && echo "export http_proxy=\"${http_proxy}\"" >> /home/mqm/.bashrc \
    && echo "export https_proxy=\"${https_proxy}\"" >> /home/mqm/.bashrc \
    && echo "export no_proxy=\"${no_proxy}\"" >> /home/mqm/.bashrc) \
  && echo "export IBM_INTEGRATION_TOOLKIT_HOME=\"/opt/ibm/mqsi/${IIB_VERSION}\"" >> /home/mqm/.bashrc \
  && echo "export JAVA_HOME=${JAVA_HOME}" >> /home/mqm/.bashrc \
  && echo "export JRE_HOME=${JRE_HOME}" >> /home/mqm/.bashrc \
  && echo "export PATH=$PATH:/opt/jdk/bin:/opt/jdk/jre/bin" >> /home/mqm/.bashrc
  && echo ""
  && echo "Configure SSH ...."
  && echo ""
  && cd /tmp \
  && unzip ssh-keys.own.zip -d ./ \
  && printf "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null\n" > /home/mqm/.ssh/config \
  && cp id_rsa* /home/mqm/.ssh/ \
  && chown mqm:mqm /home/mqm/.ssh/* \
  && chmod 0600 /home/mqm/.ssh/id_rsa* \
  && rm -rf /tmp/*

ENV \
  QUEUE_MGR_NAME=IIB_QM \
  BROKER_NAME=IIB_NODE \
  TERM=xterm

# Set entrypoint to run management script
ENTRYPOINT ["manage.sh"]
