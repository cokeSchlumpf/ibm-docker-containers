#!/bin/bash

start() {
  # Start Tomcat
  /usr/local/apache-tomcat/bin/startup.sh

  # Start Postfix for gitlab
  service postfix start

  # Start gitlab
  gitlab-ctl reconfigure & sleep 40; kill $!
  pkill -f chef-client
  sleep 10
  pkill -f chef-client
  # Execute workaround for freezing reconfigure process. See https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/common_installation_problems/README.md#reconfigure-freezes-at-ruby_blocksupervise_redis_sleep-action-run.
  cp /opt/gitlab/embedded/cookbooks/runit/files/default/gitlab-runsvdir.conf /etc/init/
  initctl start gitlab-runsvdir
  gitlab-ctl reconfigure
}

monitor() {
  echo "Running - stop container to exit"
	# Loop forever by default - container must be stopped manually.
  # Here is where you can add in conditions controlling when your container will exit - e.g. check for existence of specific processes stopping or errors beiing reported
	while [ -z "$EXIT_CONTAINER" ]; do
		sleep 1
	done
}

stop() {
  service postfix stop
  export EXIT_CONTAINER=1
}

start
trap stop SIGTERM SIGINT
monitor
