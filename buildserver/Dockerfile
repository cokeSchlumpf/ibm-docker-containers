# This image contains a simple build server with Java 8, Git, Jenkins, Artifactory and GitLab.
FROM ibm/centos-base
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Define Versions
ENV DOWNLOAD_BASE_URL=http://172.16.166.1:8080 \
  ARTIFACTORY_VERSION=4.2.1 \
  JDK_VERSION=1.8.0_66 \
  JENKINS_VERSION=1.625.1 \
  TOMCAT_VERSION=8.0.28

# Install Java 8
RUN wget -O /tmp/jdk.tar.gz ${DOWNLOAD_BASE_URL}/jdk/jdk_${JDK_VERSION}.tar.gz \
  && cd /tmp \
  && tar -zxvf ./jdk.tar.gz \
  && mv /tmp/jdk${JDK_VERSION} /opt/jdk \
  && alternatives --install /usr/bin/java java /opt/jdk/bin/java 2 \
  && alternatives --install /usr/bin/jar jar /opt/jdk/bin/jar 2 \
  && alternatives --install /usr/bin/javac javac /opt/jdk/bin/javac 2 \
  && alternatives --set java /opt/jdk/bin/java \
  && alternatives --set jar /opt/jdk/bin/jar \
  && alternatives --set javac /opt/jdk/bin/javac \
  && rm -rf /tmp/* \
  && export JAVA_HOME=/opt/jdk \
  && export JRE_HOME=/opt/jdk/jre \
  && export PATH=$PATH:/opt/jdk/bin:/opt/jdk/jre/bin \
  && java -version \
  && which java

# Install Tomcat
RUN wget -O /tmp/apache-tomcat.tar.gz ${DOWNLOAD_BASE_URL}/apache-tomcat/apache-tomcat_${TOMCAT_VERSION}.tar.gz \
  && cd /tmp \
  && tar -xzvf ./apache-tomcat.tar.gz \
  && mv /tmp/apache-tomcat-${TOMCAT_VERSION} /usr/local/apache-tomcat

# Deploy Jenkins
ENV JENKINS_HOME /var/jenkins
RUN wget -O /usr/local/apache-tomcat/webapps/jenkins.war ${DOWNLOAD_BASE_URL}/jenkins/jenkins_${JENKINS_VERSION}.war \
  && mkdir ${JENKINS_HOME}
VOLUME [${}]

# Deploy Artifactory
ENV ARTIFACTORY_HOME /var/artifactory
RUN wget -O /usr/local/apache-tomcat/webapps/artifactory.war ${DOWNLOAD_BASE_URL}/artifactory/artifactory_${ARTIFACTORY_VERSION}.war \
  && mkdir ${ARTIFACTORY_HOME}
VOLUME ["/var/artifactory"]

# Install gitlab
RUN yum install -y curl openssh-server postfix cronie \
  && service postfix start \
  && chkconfig postfix on \
  && curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash \
  && yum install -y gitlab-ce \
  && gitlab-ctl reconfigure

# Copy SSH Configuration (SSH Keys should always be the same)
COPY ssh-keys.zip /tmp/
RUN cd /tmp \
  && unzip ssh-keys.zip -d ./ \
  && /bin/cp -f ssh_host* /etc/ssh/ \
  && chmod 600 /etc/ssh/*key \
  && chown root /etc/ssh/* \
  && rm -rf /tmp/*

# Add manage script
COPY buildserver-manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Expose Ports
EXPOSE 8080

# Set entrypoint to run management script
ENTRYPOINT ["buildserver-manage.sh"]
