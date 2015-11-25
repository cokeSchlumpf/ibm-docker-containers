#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script builds all docker images.
# 
# Usage:
# build-all [ -h | --help | OPTIONS ]
# 
# Options:
#   -f|--files
#     Directory which contains the installation files - must be an absolute path.
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)
FILES=


main() {
  cd ${BASEDIR} 
  read_variables "$@"
  check_required
  
  echo "Stoping and removing container http-server ..."
  ./docker-exec.sh --args rm -f http-server || true
  
  # Build and start http-server
  echo "Building ibm/http-server ..."
  ./docker-build.sh -p http-server
  
  # Start http-server
  echo "Running ibm/http-server ..."
  ./docker-exec.sh run -id \
  	--privileged=true \
    -v ${FILES}:/var/opt/http \
  	-P \
    --name http-server \
    --hostname http-server \
    ibm/http-server
  cd ${CURRENTDIR}
}

check_required() {
  if [ -z "${FILES}" ]; then
    >&2 echo "Missing required parameter: -f|--files."
    show_help_and_exit 1
  fi;
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      -f|--files)
        FILES="$2";;
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
  echo "This script builds all docker images."
  echo ""
  echo "Usage:"
  echo "build-all [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  -f|--files"
  echo "    Directory which contains the installation files - must be an absolute path."
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}


main "$@"
