#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script sets up the DNS environment for docker containers.
# 
# Usage:
# docker-dns [ -h | --help | OPTIONS ]
# 
# Options:
#   --dns
#     Optional. Default: 8.8.8.8.
#     DNS Server to be used for forwarded DNS calls (calls outside docker).
#   --domain
#     Optional. Default: ibm.com.
#     The domain to be used within the docker network.
#   --docker-machine-name
#     Optional. Default: default.
#     Name of docker-machine if running with docker-machine.
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)
DNS=
DOMAIN=
DOCKER_MACHINE_NAME=


main() {
  cd ${BASEDIR} 
  read_variables "$@"
  init_defaults
  
  echo "Configuring docker DNS environment ..."
  
  DOCKER_MACHINE_PRESENT=`which docker-machine > /dev/null && echo 0 || echo 1`
  DOCKER_MACHINE=""
  
  if [ $DOCKER_MACHINE_PRESENT -eq 0 ]; then
  	DOCKER_MACHINE="docker-machine ssh ${DOCKER_MACHINE_NAME} "
  fi
  
  IFCONFIG_PRESENT=`${DOCKER_MACHINE}which ifconfig > /dev/null && echo 0 || echo 1`
  DOCKER_BRIDGE_IP=""
  
  if [ $IFCONFIG_PRESENT -eq 0 ]; then
  	DOCKER_BRIDGE_IP=`${DOCKER_MACHINE}ifconfig docker0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
  else
  	DOCKER_BRIDGE_IP=`${DOCKER_MACHINE}ip addr show docker0 | grep "inet " | awk -F' ' '{ print $2 }' | awk -F/ '{ print $1 }'`
  fi
  
  echo "docker0 ip is ${DOCKER_BRIDGE_IP} ..."
  
  ./docker-compose.sh --project dns --args "DOCKER_BRIDGE_IP=${DOCKER_BRIDGE_IP},DOMAIN=${DOMAIN},DNS=${DNS}" --cmd "up --force-recreate -d"
  cd ${CURRENTDIR}
}

init_defaults() {
	if [ -z "${DNS}" ]; then
	  DNS="8.8.8.8"
	fi;
	if [ -z "${DOMAIN}" ]; then
	  DOMAIN="ibm.com"
	fi;
	if [ -z "${DOCKER_MACHINE_NAME}" ]; then
	  DOCKER_MACHINE_NAME="default"
	fi;
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      --dns)
        DNS="$2";;
      --domain)
        DOMAIN="$2";;
      --docker-machine-name)
        DOCKER_MACHINE_NAME="$2";;
      -h|--help)
        show_help_and_exit 0;;
      *)
        >&2 echo "Unkown option $1 with value $2."
        echo
        show_help_and_exit 2
        ;;
    esac
    shift # past argument
    shift # past argument
  done
}

show_help_and_exit() {
  echo "This script sets up the DNS environment for docker containers."
  echo ""
  echo "Usage:"
  echo "docker-dns [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  --dns"
  echo "    Optional. Default: 8.8.8.8."
  echo "    DNS Server to be used for forwarded DNS calls (calls outside docker)."
  echo "  --domain"
  echo "    Optional. Default: ibm.com."
  echo "    The domain to be used within the docker network."
  echo "  --docker-machine-name"
  echo "    Optional. Default: default."
  echo "    Name of docker-machine if running with docker-machine."
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}


main "$@"
