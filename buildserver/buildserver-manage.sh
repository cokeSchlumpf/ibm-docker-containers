#!/bin/bash

start() {
  # Start Tomcat
  /usr/local/apache-tomcat/bin/startup.sh
}

monitor() {
  echo "Running - stop container to exit"
	# Loop forever by default - container must be stopped manually.
  # Here is where you can add in conditions controlling when your container will exit - e.g. check for existence of specific processes stopping or errors beiing reported
	while true; do
		sleep 1
	done
}

start
trap stop SIGTERM SIGINT
monitor
