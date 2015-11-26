# This image contains a simple build server with Java 8, Git, Maven, NPM, Jenkins, Artifactory and GitLab.
FROM ibm/base-dev
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Install helpful tools
RUN apt-get -y update \
  && apt-get install -y openssh-server ca-certificates postfix jq \
  && apt-get -y clean all

# Define Versions
ENV \
  DOWNLOAD_BASE_URL="http-server.docker:8080" \
  ARTIFACTORY_VERSION=4.2.1 \
  JENKINS_VERSION=1.625.2 \
  GITLAB_VERSION=8.1.2 \
  TOMCAT_VERSION=8.0.28 \
  ARTIFACTORY_HOME=/var/opt/artifactory \
  JENKINS_HOME=/var/opt/jenkins \
  GITLAB_HOME=/var/opt/gitlab \
  TOMCAT_HOME=/usr/local/apache-tomcat \
  TOMCAT_PORT=8080 \
  GITLAB_PORT=9080 \
  GITLAB_UNICORN_PORT=9090 \
  EXTERNAL_SSH_PORT=222

# Install Tomcat
RUN wget -O /tmp/apache-tomcat.tar.gz ${DOWNLOAD_BASE_URL}/apache-tomcat/apache-tomcat_${TOMCAT_VERSION}.tar.gz \
  && cd /tmp \
  && tar -xzvf ./apache-tomcat.tar.gz \
  && mv /tmp/apache-tomcat-${TOMCAT_VERSION} /usr/local/apache-tomcat

# Deploy Jenkins
RUN wget -O ${TOMCAT_HOME}/webapps/jenkins.war ${DOWNLOAD_BASE_URL}/jenkins/jenkins_${JENKINS_VERSION}.war \
  && mkdir -p ${JENKINS_HOME}
VOLUME ["${JENKINS_HOME}"]

# Deploy Artifactory
RUN wget -O ${TOMCAT_HOME}/webapps/artifactory.war ${DOWNLOAD_BASE_URL}/artifactory/artifactory_${ARTIFACTORY_VERSION}.war \
  && mkdir -p ${ARTIFACTORY_HOME}
VOLUME ["${ARTIFACTORY_HOME}"]

# Install gitlab
RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash \
  && apt-get install gitlab-ce \
  && echo "Configuring gitlab ..." \
  && echo "unicorn['port'] = ${GITLAB_UNICORN_PORT}" >> /etc/gitlab/gitlab.rb \
  && echo "gitlab_rails['gitlab_shell_ssh_port'] = ${EXTERNAL_SSH_PORT}" >> /etc/gitlab/gitlab.rb
VOLUME ["${GITLAB_HOME}"]

# Copy SSH Configuration (SSH Keys should always be the same)
COPY ssh-keys.zip /tmp/
RUN cd /tmp \
  && unzip ssh-keys.zip -d ./ \
  && /bin/cp -f ssh_host* /etc/ssh/ \
  && chmod 600 /etc/ssh/*key \
  && chown root /etc/ssh/* \
  && rm -rf /tmp/*

# Add manage-jenkins script
COPY manage-jenkins.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Add SSH-Keys to allow Jenkins to use SSH for Git
# The SSH Key which is added to known_hosts relates to the keys stored in ssh-keys.zip
COPY ssh-keys.own.zip /tmp/
RUN cd /tmp \
  && unzip ssh-keys.own.zip -d ./ \
  && mkdir ~/.ssh \
  && cp id_rsa* ~/.ssh/ \
  && chmod 0600 ~/.ssh/id_rsa* \
  && rm -rf /tmp/* \
  && echo "|1|I4hFTXEb30uD0YfbYAUwCGVVdts=|6u8pKolY1GdXCBMZIuGY18pmAg8= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMn5k7S2Gxngvdz12CNf/R52P6NeZg1Llx8P24qoLJ2WFoKWWriQCXEQEDyJD7+PqOvmeqCuW+sik9g1PIxODz0=" >> ~/.ssh/known_hosts

# Configure Git
RUN git config --global user.email "jenkins@buildserver.com" \
  && git config --global user.name "Jenkins"

# Add manage script
COPY manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Expose Ports
EXPOSE 22 "${TOMCAT_PORT}" ${GITLAB_PORT}

# Set TERM again
ENV TERM=xterm

# Set entrypoint to run management script
ENTRYPOINT ["manage.sh"]
