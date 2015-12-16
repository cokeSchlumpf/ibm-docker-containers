#!/bin/bash

start() {
  # Start IIB
  su -c "manage-iib.sh" mqm

  # Start SSH server
  /sbin/service sshd start
}

stop() {
  echo "Stopping Message Broker..."
  su -c "mqsistop ${BROKER_NAME}" mqm

  echo "Stopping Queue Manager..."
  su -c "endmqm ${QUEUE_MGR_NAME}" mqm
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
