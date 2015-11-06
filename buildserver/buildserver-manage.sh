#!/bin/bash

start() {
  # Start Tomcat
  /usr/local/apache-tomcat/bin/startup.sh

  # Start necessary services for gitlab
  service postfix start
  service ssh start

  # Start gitlab
  echo "Configuring gitlab ..."
  echo "unicorn['port'] = 9090" >> /etc/gitlab/*.rb
  echo "gitlab_rails['gitlab_shell_ssh_port'] = 222" >> /etc/gitlab/*.rb
  echo "external_url 'http://`hostname`:9080'" >> /etc/gitlab/*.rb

  echo "Starting gitlab ..."
  sleep 3 && gitlab-ctl reconfigure & /opt/gitlab/embedded/bin/runsvdir-start
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
