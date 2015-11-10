# This image contains a simple development server with Java 8, Git, Maven and NPM.
FROM ibm/devserver-base
MAINTAINER "Michael Wellner" <michael.wellner@de.ibm.com>

# Export TERM
ENV TERM=xterm

# Install senseful npm packages
RUN npm install -g npm-check-updates

# Volume for workspace
VOLUME [ "/var/opt/workspace", "/root/.m2", "/root/.npm" ]
WORKDIR /var/opt/workspace

# Expose Port for JEE Server
EXPOSE 80 443

# Start Bash on Startup
CMD ["/bin/bash"]
