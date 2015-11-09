# This image contains a simple development server with Java 8, Git, Maven and NPM.
FROM ubuntu:14.04
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Install helpful tools
RUN apt-get -y update && apt-get install -y nano wget tar unzip sudo curl && apt-get -y clean all

# Define Versions
ENV \
  DOWNLOAD_BASE_URL=http://192.168.2.108:8080 \
  JDK_VERSION=1.8.0_66 \
  NODE_VERSION=5.0.0 \
  NVM_VERSION=0.29.0 \
  NVM_DIR=/usr/local/nvm \
  TERM=xterm

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
  && which java

# Install Maven
RUN apt-get install -y maven git

# Install NodeJS Environment
RUN apt-get install -y build-essential libssl-dev \
  && curl https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | sh \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && node -v \
  && npm -v \
  && echo "Installing some senseful npm packages" \
  && npm install -g npm-check-updates

ENV \
  NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules \
  PATH=$NVM_DIR:$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Volume for workspace
VOLUME [ "/var/opt/workspace", "/root/.m2", "/root/.npm" ]
WORKDIR /var/opt/workspace

# Expose Port for JEE Server
EXPOSE 80 443

# Start Bash on Startup
CMD ["/bin/bash"]
