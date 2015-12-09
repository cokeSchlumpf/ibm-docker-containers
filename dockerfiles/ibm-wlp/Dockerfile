# This docker image provides a WebSphere Liberty Profile Server.
FROM ibm/base-centos
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Define Versions
ENV \
  DOWNLOAD_BASE_URL="http-server.docker:8080" \
  WLP_VERSION=8.5.5.7

# Install WebSphere Liberty Profile
RUN wget -O /tmp/websphere-liberty.zip ${DOWNLOAD_BASE_URL}/websphere-liberty/websphere-liberty_${WLP_VERSION}.zip \
  && cd /tmp \
  && unzip ./websphere-liberty.zip -d /opt \
  && rm -rf /opt/._websphere-liberty /tmp/* \
  && ([ -z $http_proxy ] && export httpProxyHost=`echo $http_proxy | sed "s#\(http://\)\{0,1\}\([\.]*\)#\2#g" | awk -F: '{print $1}'`) \
  && ([ -z $http_proxy ] && export httpProxyPort=`echo $http_proxy | sed "s#\(http://\)\{0,1\}\([\.]*\)#\2#g" | awk -F: '{print $2}'`) \
  && ([ -z $http_proxy ] && mkdir -p /opt/wlp/etc && printf "proxyHost=${httpProxyHost}\nproxyPort=${httpProxyPort}\n" > /opt/wlp/etc/repositories.properties && cat /opt/wlp/etc/repositories.properties || true) \
  && /opt/wlp/bin/featureManager install --acceptLicense jaxws-2.2 --to=usr

# Install openssh-server to deploy applications
RUN yum install -y openssh-server openssh-clients

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

# Configure authorized keys
RUN mkdir -p /home/wlp/.ssh \
  && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyod44T9cOtQu8njkehz2aKiA4Nm6RiQc2AYcj7tjYwxRB0WGQcu4rUZVd2xbAfT0lWuDB5XPK5NPmgKrNEgWIDMPSKCH+9dLL6RRlU72vkBSgEQG6Rz5YVA2LMuJCycf3zFEvH0fYWqMdZiI4GAcKVBS73vtCd2rFKkRTmRKLoziGKqqsrkimXClS57mAiqCo0jrQxcf4V8jpGe+4NYXTk1rgeWozspy5CktmYN6NPDxLKVbeB7dwik2SVvF1592Fv8a5ZsRdvvNha9W8PZM+45p4pEiDcG0/5tct34V0OrhbqqZUJDcFYGOGhBHhDdmQ7T/5BQXQr28m6zdY1k9P jenkins@buildserver.com" >> /home/wlp/.ssh/authorized_keys \
  && chown -R wlp /home/wlp/.ssh \
  && chgrp -R wlp /home/wlp/.ssh \
  && chmod 700 /home/wlp/.ssh \
  && chmod 600 /home/wlp/.ssh/authorized_keys \
  && chown -R wlp /opt/wlp \
  && chgrp -R wlp /opt/wlp

# WLP management script
COPY manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Expose ports from WLP to the outside world.
EXPOSE 9080 9443 22

# Workaround to get nano running
ENV TERM xterm

# Start WLP on Startup
ENTRYPOINT ["manage.sh"]
