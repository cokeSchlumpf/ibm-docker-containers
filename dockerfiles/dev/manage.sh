#!/bin/bash

start() {
  # Change GID and UID of dev if necessary.
  if [ ! -z $UID ] && [ ! -z $GID ]; then
    echo "Changing uid and gid of user 'dev' to uid=$UID and gid=$GID ..."

    ls -n "/var/opt/workspace"
    ls -al "/home/dev/.ssh"

    OLDUID=`id -u dev`
    OLDGID=`id -g dev`

    usermod -u $UID dev
    groupmod -g $GID dev
    find /home -user $OLDUID -exec chown -h $UID {} \;
    find /home -group $OLDGID -exec chgrp -h $GID {} \;
    usermod -g $GID dev
    chown -R dev:dev /home/dev

    ls -n "/var/opt/workspace"
  fi

  # Add internal DNS Servers if necessary.
  ping -c 1 -W 5 10.90.14.1 | grep "1 received"
  INTRANET=$(echo $?)

  echo "Ping result: ${INTRANET}"

  if [ 0 = "${INTRANET}" ]; then
    echo "Setting resolv.conf to intranet DNS server ..."

    echo "search group.local localdomain" > /etc/resolv.conf
    echo "nameserver 10.90.14.1" >> /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  else
    echo "Using docker default DNS settings ..."
    cat /etc/resolv.conf
  fi

  if [ ! -z $http_proxy ]; then
    npm config set proxy ${http_proxy}
    npm config set https-proxy ${https_proxy:-$http_proxy}
    echo "proxy=${http_proxy}" >> /home/dev/.npmrc
    echo "https-proxy=${http_proxy}" >> /home/dev/.npmrc
  fi
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
