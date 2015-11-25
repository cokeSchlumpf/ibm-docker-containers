# This image contains an image which starts a simple HTTPServer, serving files from /var/opt/http.
FROM ubuntu:14.04
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Define Proxy
ENV \
  http_proxy_disabled \
  https_proxy_disabled \
  no_proxy_disabled

RUN apt-get install -y python

# Add manage script
COPY manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Volume for installation files
VOLUME [ "/var/opt/http" ]
WORKDIR /var/opt/http

# Volume
EXPOSE 8080

ENTRYPOINT ["manage.sh"]
