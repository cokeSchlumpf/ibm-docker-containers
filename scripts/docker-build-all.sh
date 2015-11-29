#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script builds all docker images.
# 
# Usage:
# docker-build-all [ -h | --help | OPTIONS ]
# 
# Options:
#   -f|--files
#     Optional.
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
  
  HTTP_STARTED=$(./docker-exec.sh --args ps | grep "http-server" > /dev/null && echo "0" || echo "1")
  
  echo "http-server started: ${HTTP_STARTED}"
  
  if [ -z ${FILES} ] && [ ${HTTP_STARTED} -eq 1 ]; then
  	>&2 echo "No installation-files directory defined and http-server not started yet. Specifiy installation files the http-server container."
  	exit 1
  fi
  
  if [ ! -z ${FILES} ]; then
  	echo "Stoping and removing container http-server ..."
  	./docker-exec.sh --args rm -f http-server || true
  
  	LINKS=($(find ${FILES} -type l -ls | awk -F\> '{ print $2 }' | sed -e 's/^[ \t]*//' | tr '\n' ' '))
  	VOLUMES="-v ${FILES}:/var/opt/http"
  
  	if [ ${#LINKS[@]} -gt 0 ]; then
  		VOLUME_PATH=`longest_common_prefix ${LINKS[@]}`
  		VOLUMES="${VOLUMES} -v ${VOLUME_PATH}:${VOLUME_PATH}"
  
  		echo "Using volumes ${VOLUMES} ..."
  	fi;
  
  	# Build and start http-server
  	echo "Building ibm/http-server ..."
  	./docker-build.sh -p http-server
  
  	# Start http-server
  	echo "Running ibm/http-server ..."
  	./docker-exec.sh --args run -id \
  		--privileged=true \
  	  ${VOLUMES} \
  		-P \
  	  --name http-server \
  	  --hostname http-server \
  	  ibm/http-server
  fi
  
  ./docker-build.sh -p base-dev
  ./docker-build.sh -p build/build-dvc -t build-dvc
  ./docker-build.sh -p build
  
  ./docker-build.sh -p base-centos
  ./docker-build.sh -p ibm-wlp -t wlp
  ./docker-build.sh -p ibm-iib -t iib
  cd ${CURRENTDIR}
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
  echo "docker-build-all [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  -f|--files"
  echo "    Optional."
  echo "    Directory which contains the installation files - must be an absolute path."
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}

longest_common_prefix() {
  declare -a names
    declare -a parts
    declare i=0
  
    names=("$@")
    name="$1"
    while x=$(dirname "$name"); [ "$x" != "/" ]
    do
        parts[$i]="$x"
        i=$(($i + 1))
        name="$x"
    done
  
    for prefix in "${parts[@]}" /
    do
        for name in "${names[@]}"
        do
            if [ "${name#$prefix/}" = "${name}" ]
            then continue 2
            fi
        done
        echo "$prefix"
        break
    done
}

main "$@"
