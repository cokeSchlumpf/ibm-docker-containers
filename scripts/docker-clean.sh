#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script cleans docker environment.
# 
# Usage:
# docker-clean [ -h | --help | OPTIONS ]
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)


main() {
  cd ${BASEDIR} 
  read_variables "$@"
  
  ./docker-exec.sh --args ps -a | grep 'Exited' | awk '{print $1}' | xargs ./docker-exec.sh --args rm -v  || true
  ./docker-exec.sh --args images | grep "<none>" | awk '{print $3}' | xargs ./docker-exec.sh --args rmi || true
  ./docker-exec.sh --args volume ls | grep local | awk '{print $2}' | xargs ./docker-exec.sh --args volume rm || true
  cd ${CURRENTDIR}
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
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
  echo "This script cleans docker environment."
  echo ""
  echo "Usage:"
  echo "docker-clean [ -h | --help | OPTIONS ]"
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}


main "$@"
