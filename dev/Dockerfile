# This image contains a simple development server with Java 8, Git, Maven and NPM.
FROM ibm/base-dev
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Export TERM
ENV TERM=xterm

# Install senseful npm packages
RUN npm install -g npm-check-updates \
  && npm install -g npm-watch \
  && npm install -g babel-cli \
  && npm install -g node-notifier

# Volume for workspace
VOLUME [ "/var/opt/workspace", "/root/.m2", "/root/.npm" ]
WORKDIR /var/opt/workspace

# Expose Port for JEE Server
EXPOSE 80 443

# Start Bash on Startup
CMD ["/bin/bash"]
