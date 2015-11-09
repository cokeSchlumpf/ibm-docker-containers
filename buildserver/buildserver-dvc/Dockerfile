# Data volume container for ibm/buildserver
FROM ubuntu:14.04

# Define Versions
ENV \
  ARTIFACTORY_HOME=/var/opt/artifactory \
  JENKINS_HOME=/var/opt/jenkins \
  GITLAB_HOME=/var/opt/gitlab

# Define volumes
VOLUME [ "${ARTIFACTORY_HOME}", "${JENKINS_HOME}", "${GITLAB_HOME}" ]

# Startup command
CMD ["/bin/bash"]
