# This image contains a simple development server with Java 8, Git, Maven and NPM.
FROM ibm/base-dev
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Export TERM
ENV TERM=xterm

# Install senseful npm packages
RUN npm install -g npm-watch \
  && npm install -g babel-cli \
  && npm install -g node-notifier

# Create User for development
RUN useradd --create-home dev

# Add manage script
COPY manage.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Volume for workspace
VOLUME [ "/var/opt/workspace" ]
WORKDIR /var/opt/workspace

# Expose Port for JEE Server
EXPOSE 8080 8443

# Defined and export Proxy
ENV  http_proxy 'cntlm-proxy.docker.rodenstock.com:3128'
ENV  https_proxy 'cntlm-proxy.docker.rodenstock.com:3128'
ENV  HTTP_PROXY 'cntlm-proxy.docker.rodenstock.com:3128'
ENV  HTTPS_PROXY 'cntlm-proxy.docker.rodenstock.com:3128'
ENV  no_proxy_disabled

#ENV \
#  http_proxy_disabled \
#  https_proxy_disabled \
#  no_proxy_disabled

# Set entrypoint to run management script
ENTRYPOINT ["manage.sh"]
