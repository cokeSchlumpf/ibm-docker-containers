#!/bin/bash

start() {
  # Start Tomcat
  /usr/local/apache-tomcat/bin/startup.sh

  # Update Jenkins after startup
  manage-jenkins.sh ${TOMCAT_HOME}/webapps/jenkins/WEB-INF/jenkins-cli.jar http://localhost:${TOMCAT_PORT}/jenkins

  # Start necessary services for gitlab
  service postfix start
  service ssh start

  # Start gitlab
  echo "Configuring gitlab ..."
  echo "external_url 'http://`hostname`:${GITLAB_PORT}'" >> /etc/gitlab/gitlab.rb

  echo "Starting gitlab ..."
  sleep 3 && gitlab-ctl reconfigure & /opt/gitlab/embedded/bin/runsvdir-start

  ssh-keyscan -p 22 build >> ~/.ssh/known_hosts
}

monitor() {
  echo "Running - stop container to exit"

	# Loop forever by default - container must be stopped manually.
	while [ -z "$EXIT_CONTAINER" ]; do
		sleep 1
	done

  echo "Received stopping signal. Stopping now."
  service postfix stop
  service ssh stop
  gitlab-ctl stop
}

stop() {
  export EXIT_CONTAINER=1
}

start
trap stop SIGTERM SIGINT
monitor
