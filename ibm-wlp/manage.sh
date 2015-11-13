#!/bin/bash

start() {
  # Start SSH server
  /sbin/service sshd start

  # Start WLP as user wlp
  su -c "/opt/wlp/bin/server run" wlp
}

monitor() {
  echo "Running - stop container to exit"

	# Loop forever by default - container must be stopped manually.
	while [ -z "$EXIT_CONTAINER" ]; do
		tail -f /op/wlp/usr/servers/defaultServer/logs/messages.log
	done

  echo "Received stopping signal. Stopping now."
  su -c "/opt/wlp/bin/server stop" wlp
  /sbin/service sshd stop
}

stop() {
  export EXIT_CONTAINER=1
}

start
trap stop SIGTERM SIGINT
monitor
