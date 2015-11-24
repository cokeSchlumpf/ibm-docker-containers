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
VOLUME [ "/var/opt/workspace", "/home/dev/.m2", "/home/dev/.npm" ]
WORKDIR /var/opt/workspace

# Expose Port for JEE Server
EXPOSE 80 443

# Set entrypoint to run management script
ENTRYPOINT ["manage.sh"]
