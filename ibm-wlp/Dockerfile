# This docker image provides a WebSphere Liberty Profile Server.
FROM ibm/base-centos
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set up some configuration environment variables
ENV DOWNLOAD_BASE_URL=http://192.168.2.108:8080 \
  WLP_VERSION=8.5.5.7

# Install WebSphere Liberty Profile
RUN wget -O /tmp/websphere-liberty.zip ${DOWNLOAD_BASE_URL}/websphere-liberty/websphere-liberty_${WLP_VERSION}.zip \
  && cd /tmp \
  && unzip ./websphere-liberty.zip -d /opt \
  && rm -rf /opt/._websphere-liberty /tmp/*

# Install openssh-server to deploy applications
RUN yum install -y openssh-server

# Copy SSH Configuration (SSH Keys should always be the same)
COPY ssh-keys.zip /tmp/
RUN cd /tmp \
  && unzip ssh-keys.zip -d ./ \
  && /bin/cp -f ssh_host* /etc/ssh/ \
  && chmod 600 /etc/ssh/*key \
  && chown root /etc/ssh/* \
  && rm -rf /tmp/*

# Create user for WLP
RUN useradd --user-group --create-home --password $(echo "wlp" | openssl passwd -1 -stdin) wlp \
  && chown -R wlp /opt/wlp \
  && chgrp -R wlp /opt/wlp

# WLP management script
COPY wlp-manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Expose ports from WLP to the outside world.
EXPOSE 9080 9443 22

# Workaround to get nano running
ENV TERM xterm

# Start WLP on Startup
ENTRYPOINT ["wlp-manage.sh"]
