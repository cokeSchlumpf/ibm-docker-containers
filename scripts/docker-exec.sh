#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script detects whether to call docker with sudo or not. Just calls docker with the given arguments.
# 
# Usage:
# docker-exec [ -h | --help | OPTIONS ]
# 
# Options:
#   --args
#     Arguments passed to docker.
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)
ARGS=


main() {
  cd ${BASEDIR} 
  read_variables "$@"
  check_required
  
  SUDO=`(docker ps > /dev/null || false);echo $?`
  
   if [ "$SUDO" -gt 0 ]; then
  	echo "Executing docker with sudo ..."
  	sudo docker ${ARGS[@]}
  else
  	echo "Executing docker ..."
  	docker ${ARGS[@]}
  fi
  cd ${CURRENTDIR}
}

check_required() {
  if [ -z "${ARGS}" ]; then
    >&2 echo "Missing required parameter: --args."
    show_help_and_exit 1
  fi;
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      --args)
        ARGS="${@:2}";break;;
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
  echo "This script detects whether to call docker with sudo or not. Just calls docker with the given arguments."
  echo ""
  echo "Usage:"
  echo "docker-exec [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  --args"
  echo "    Arguments passed to docker."
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}


main "$@"
