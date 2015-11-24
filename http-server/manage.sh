#!/bin/bash

start() {
  cd /var/opt/http
  python -m SimpleHTTPServer 8080
}

monitor() {
  echo "Running - stop container to exit"

	# Loop forever by default - container must be stopped manually.
	while [ -z "$EXIT_CONTAINER" ]; do
		sleep 1
	done

  echo "Received stopping signal. Stopping now."
}

stop() {
  export EXIT_CONTAINER=1
}

start
trap stop SIGTERM SIGINT
monitor
