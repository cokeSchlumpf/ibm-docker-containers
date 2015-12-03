# This docker image provides a NTLM based proxy such as cntlm for fast NTLM authentication proxy with tunneling.
FROM ubuntu:14.04
MAINTAINER "Tom Weber" <tom.weber@rodenstock.com>

# Define Proxy
ENV \
  http_proxy_disabled \
  https_proxy_disabled \
  no_proxy_disabled

# Install cntlm proxy
RUN apt-get -y update && apt-get install -y sudo wget sysv-rc cntlm curl && apt-get -y clean all

# Add manage script
COPY manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Volume for configuration files
#VOLUME [ "/etc" ]
#WORKDIR /etc

# Volume
EXPOSE 3128

ENTRYPOINT ["manage.sh"]
