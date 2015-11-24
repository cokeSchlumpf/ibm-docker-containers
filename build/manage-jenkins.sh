#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# Updates and installs necessary jenkins plugins. Usage:
#
# manage-jenkins [JENKINS_CLI] [JENKINS_URL]
#
# JENKINS_CLI. Optional. Default = /usr/local/apache-tomcat/webapps/jenkins/WEB-INF/jenkins-cli.jar
#   - Location of jenkins-cli.jar (contained within jenkins.war).
#
# JENKINS_URL. Optional. Default = http://localhost:8080/jenkins
#   - URL of Jenkins instance to configure.

ERROR_JENKINS_NOT_STARTED=1;

if [ $1 = "--help" ] || [ $1 = "-h" ]; then
  echo "Updates and installs necessary jenkins plugins. Usage:"
  echo
  echo "manage-jenkins [JENKINS_CLI] [JENKINS_URL] [JAVA_HOME]"
  echo
  echo "JENKINS_CLI. Optional. Default = /usr/local/apache-tomcat/webapps/jenkins/WEB-INF/jenkins-cli.jar"
  echo "  - Location of jenkins-cli.jar (contained within jenkins.war)."
  echo
  echo "JENKINS_URL. Optional. Default = http://localhost:8080/jenkins"
  echo "  - URL of Jenkins instance to configure."
  echo
  echo "JAVA_HOME. Optional. Default = /opt/jdk"
  echo "  - Java home path."
  echo
  sleep 3;
  exit 0;
fi;

# Match arguments or use default values
jenkins_cli=${1-"/usr/local/apache-tomcat/webapps/jenkins/WEB-INF/jenkins-cli.jar"};
jenkins_url=${2-"http://localhost:8080/jenkins"};
java_home=${3-"/opt/jdk"};

main() {
  check_started
  update_plugins

  # Declare necessary plugins for Jenkins
  install_plugins "gitlab-hook" "job-dsl" "greenballs" "uno-choice"

  setJDK

  if [ ! -z "$JENKINS_CHANGED" ]; then
    restart
    unset JENKINS_CHANGED
  fi;
}

check_started() {
  # Wait until Jenkins is started
  for i in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0; do
    java -jar $jenkins_cli -s $jenkins_url list-plugins && export JENKINS_STARTED=1

    if [ ! -z "$JENKINS_STARTED" ]; then
      echo "Jenkins started."
      break;
    else
      echo "Waiting for Jenkins to start. $i cycles remaining ..."
      sleep 20
    fi;
  done

  if [ -z "$JENKINS_STARTED" ]; then
    >&2 echo "Jenkins not Started. Unable to configure."
    exit $ERROR_JENKINS_NOT_STARTED;
  fi;
}

install_plugins() {
  java -jar $jenkins_cli -s $jenkins_url install-plugin $@
  export JENKINS_CHANGED=1
}

restart() {
  echo "Restarting Jenkins ..."
  java -jar $jenkins_cli -s $jenkins_url safe-restart;
  check_started
}

update_plugins() {
  echo "Checking for plugin updates ..."

  UPDATE_LIST=$( java -jar $jenkins_cli -s $jenkins_url list-plugins | grep -e ')$' | awk '{ print $1 }' );

  if [ ! -z "$UPDATE_LIST" ]; then
    echo Updating Jenkins Plugins: $UPDATE_LIST;
    java -jar $jenkins_cli -s $jenkins_url install-plugin $UPDATE_LIST;
    export JENKINS_CHANGED=1
  else
    echo "Everything up-to-date. Nothing to do."
  fi
}

setJDK() {
  rm configure-jdk.groovy && touch configure-jdk.groovy
  echo 'name = "Native Java";' >> configure-jdk.groovy
  echo 'home = "/opt/jdk";' >> configure-jdk.groovy
  echo '' >> configure-jdk.groovy
  echo 'dis = new hudson.model.JDK.DescriptorImpl();' >> configure-jdk.groovy
  echo 'dis.setInstallations( new hudson.model.JDK(name, home));' >> configure-jdk.groovy
  echo '' >> configure-jdk.groovy
  echo 'println "$name defined with $home";' >> configure-jdk.groovy

  curl --data-urlencode "script=$(<./test)" $jenkins_url/scriptText
  rm configure-jdk.groovy
}

setGit() {
  # TODO
  echo "TODO"
}

setMaven() {
  # TODO
  echo "TODO"
}

main
