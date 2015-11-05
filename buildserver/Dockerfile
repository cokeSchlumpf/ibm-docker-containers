# This image contains a simple build server with Java 8, Git, Jenkins and Artifactory.
FROM rodenstock/centos-base
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Define Versions
ENV DOWNLOAD_BASE_URL http://172.16.166.1:8080
ENV JDK_VERSION 8u66

# Install Java 8
RUN wget -O /tmp/jdk.tar.gz ${DOWNLOAD_BASE_URL}/jdk/jdk_${JDK_VERSION}.tar.gz \
  && cd /tmp \
  && tar -zxvf ./jdk.tar.gz \
  && mv /tmp/jdk /opt/ \
  && alternatives --install /usr/bin/java java /opt/jdk/bin/java 2 \
  && alternatives --install /usr/bin/jar jar /opt/jdk/bin/jar 2 \
  && alternatives --install /usr/bin/javac javac /opt/jdk/bin/javac 2 \
  && alternatives --set java /opt/jdk/bin/java \
  && alternatives --set jar /opt/jdk/bin/jar \
  && alternatives --set javac /opt/jdk/bin/javac \
  && export JAVA_HOME=/opt/jdk \
  && export JRE_HOME=/opt/jdk/jre \
  && export PATH=$PATH:/opt/jdk/bin:/opt/jdk/jre/bin \
  && java -version \
  && which java

CMD["/bin/bash"]
