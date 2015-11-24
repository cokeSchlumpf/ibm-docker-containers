#!/bin/bash

start() {
  # Change GID and UID of dev if necessary.
  if [ ! -z $UID ] && [ ! -z $GID ]; then
    echo "Changing uid and gid of user 'dev' to uid=$UID and gid=$GID ..."

    ls -n "/var/opt/workspace"

    OLDUID=`id -u dev`
    OLDGID=`id -g dev`

    usermod -u $UID dev
    groupmod -g $GID dev
    find /home -user $OLDUID -exec chown -h $UID {} \;
    find /home -group $OLDGID -exec chgrp -h $GID {} \;
    usermod -g $GID dev
    chmod -R dev /home/dev
    chgrp -R dev /home/dev

    ls -n "/var/opt/workspace"
  fi

  # Add internal DNS Servers if necessary.
  INTRANET=`(ping -c 1 -W 5 10.99.14.10 | grep "1 received");echo $?`

  if [ 0 -eq $INTRANET ]; then
    echo "Setting resolv.conf to intranet DNS server ..."

    echo "search group.local" > /etc/resolv.conf
    echo "nameserver 10.99.14.10" >> /etc/resolv.conf
    echo "nameserver 10.99.14.11" >> /etc/resolv.conf
  else
    echo "Using docker default DNS settings ..."
    cat /etc/resolv.conf
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
