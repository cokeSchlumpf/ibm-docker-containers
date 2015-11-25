#!/bin/bash

start() {
  if [ ! -z ${http_proxy} ]; then
    # Inject proxy settings into Tomcat.
    httpProxyHost=`echo $http_proxy | sed "s#\(http://\)\{0,1\}\([\.]*\)#\2#g" | awk -F: '{print $1}'`
    httpProxyPort=`echo $http_proxy | sed "s#\(http://\)\{0,1\}\([\.]*\)#\2#g" | awk -F: '{print $2}'`
    httpNonProxyHosts=`$no_proxy | sed "s#,#|#g"`

    echo "JAVA_OPTS=\"-Dhttp.proxySet=true \${JAVA_OPTS}\"" > /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttp.proxyHost=${httpProxyHost} \${JAVA_OPTS}\"" >> /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttp.proxyPort=${httpProxyPort} \${JAVA_OPTS}\"" >> /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttp.nonProxyHosts=${httpNonProxyHosts} \$JAVA_OPTS\"" >> /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttps.proxySet=true \${JAVA_OPTS}\"" > /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttps.proxyHost=${httpProxyHost} \${JAVA_OPTS}\"" >> /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttps.proxyPort=${httpProxyPort} \${JAVA_OPTS}\"" >> /usr/local/apache-tomcat/bin/setenv.sh
    echo "JAVA_OPTS=\"-Dhttps.nonProxyHosts=${httpNonProxyHosts} \$JAVA_OPTS\"" >> /usr/local/apache-tomcat/bin/setenv.sh

    echo "Written /usr/local/apache-tomcat/bin/setenv.sh ..."
    cat /usr/local/apache-tomcat/bin/setenv.sh
  fi

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
