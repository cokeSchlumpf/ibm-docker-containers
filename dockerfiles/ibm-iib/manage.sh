#!/bin/bash

start() {
  # Start IIB
  BROKERS=($(su -c "mqsilist" mqm | grep BIP128 | awk -F "'" '{print $2}'))

  for BROKER in "${BROKERS[@]}"; do
    echo "*** Stopping broker ${BROKER}"
    su -c "mqsistart ${BROKER}"
  done

  # Start SSH server
  /sbin/service sshd start
}

stop() {
  # echo "Stopping all Message Brokers..."
  BROKERS=($(su -c "mqsilist" mqm | grep BIP128 | awk -F "'" '{print $2}'))

  for BROKER in "${BROKERS[@]}"; do
    echo "*** Stopping broker ${BROKER}"
    su -c "mqsistop ${BROKER}"
  done
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
