# This image contains an image which starts a simple HTTPServer, serving files from /var/opt/http.
FROM ubuntu:14.04
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Set proxy
ENV \
  http_proxy_disabled=proxy-web.group.local:3128 \
  https_proxy_disabled=proxy-web.group.local:3128 \
  no_proxy="10.90.14.29,127.0.0.1,localhost"

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
