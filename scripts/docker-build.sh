#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script builds the docker image for the Dockerfile within the given directory, may modify proxy settings for Dockerfile if http_proxy is set within environment.
#
# Usage:
# docker-build [ -h | --help | OPTIONS ]
#
# Options:
#   -p|--project
#     The project to be build, e.g. base-dev, ibm-iib, ...
#   -t|--tagname
#     Optional. Default: ${PROJECT}.
#     The tagname of the docker image - Will be prefixed with ibm/...
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)
PROJECT=
TAGNAME=


main() {
  cd ${BASEDIR}
  read_variables "$@"
  check_required
  init_defaults

  HTTP_SERVER_EXISTS=$(./docker-exec.sh --args ps -a | grep "http-server" > /dev/null && echo 0 || echo 1)

  if [ $HTTP_SERVER_EXISTS -eq 0 ]; then
  	export DOWNLOAD_HOST=`./docker-exec.sh --args inspect http-server | grep "\"IPA" | awk -F\" '{ print $4 }'`
  	export DOWNLOAD_BASE_URL="${DOWNLOAD_HOST}:8080"
  	echo "Using ${DOWNLOAD_BASE_URL} for installation files ..."
  else
  	unset DOWNLOAD_HOST
  	unset DOWNLOAD_BASE_URL
  fi

  if [ ! -z ${http_proxy} ]; then
  	echo "Using proxy ${http_proxy} to build ${PROJECT}/Dockerfile ..."

  	NEED_HTTP=$(cat ../${PROJECT}/Dockerfile | grep "FROM ubuntu" > /dev/null && echo 0 || echo 1)
    HOST_OS_DISTRIBUTION=`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`

  	httpProxy=${http_proxy}
  	httpsProxy=${https_proxy}

  	if [ $NEED_HTTP -eq 0 ]; then
      echo "OS: $HOST_OS_DISTRIBUTION"
      if [ "$HOST_OS_DISTRIBUTION" != "Ubuntu" ]; then
  		    echo "Using Proxy with http:// ..."
  		    httpProxy="http://${httpProxy}"
  		    httpsProxy="http://${httpsProxy}"
      fi
  	fi

  	cat ../${PROJECT}/Dockerfile | sed "s#http_proxy_disabled#http_proxy=${httpProxy}#g" > ../${PROJECT}/Dockerfile.proxy
  	sed -i "s#https_proxy_disabled#https_proxy=${httpsProxy}#g" ../${PROJECT}/Dockerfile.proxy

  	if [ "${DOWNLOAD_HOST}" = "" ]; then
  		sed -i "s#no_proxy_disabled#no_proxy=\"docker,${no_proxy}\"#g" ../${PROJECT}/Dockerfile.proxy
  	else
  		sed -i "s#no_proxy_disabled#no_proxy=\"${DOWNLOAD_HOST},docker,${no_proxy}\"#g" ../${PROJECT}/Dockerfile.proxy
  		sed -i "s#DOWNLOAD_BASE_URL=\"\([^\"]*\)\"#DOWNLOAD_BASE_URL=\"${DOWNLOAD_BASE_URL}\"#g" ../${PROJECT}/Dockerfile.proxy
  	fi

  	echo "Transformed Dockerfile:"
  	cat ../${PROJECT}/Dockerfile.proxy

  	./docker-exec.sh --args build -t ibm/${TAGNAME} -f ../${PROJECT}/Dockerfile.proxy ../${PROJECT}/
  	rm ../${PROJECT}/Dockerfile.proxy
  else
  	if [ "${DOWNLOAD_HOST}" = "" ]; then
  		cat ../${PROJECT}/Dockerfile > ../${PROJECT}/Dockerfile.tmp
  	else
  		cat ../${PROJECT}/Dockerfile | sed "s#DOWNLOAD_BASE_URL=\"\([^\"]*\)\"#DOWNLOAD_BASE_URL=\"${DOWNLOAD_BASE_URL}\"#g" > ../${PROJECT}/Dockerfile.tmp
  	fi

  	echo "Transformed Dockerfile:"
  	cat ../${PROJECT}/Dockerfile.tmp

  	./docker-exec.sh --args build -t ibm/${TAGNAME} -f ../${PROJECT}/Dockerfile.tmp ../${PROJECT}/
  	rm ../${PROJECT}/Dockerfile.tmp
  fi

  unset DOWNLOAD_HOST
  unset DOWNLOAD_BASE_URL
  cd ${CURRENTDIR}
}

check_required() {
  if [ -z "${PROJECT}" ]; then
    >&2 echo "Missing required parameter: -p|--project."
    show_help_and_exit 1
  fi;
}

init_defaults() {
	if [ -z "${TAGNAME}" ]; then
	  TAGNAME="${PROJECT}"
	fi;
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      -p|--project)
        PROJECT="$2";;
      -t|--tagname)
        TAGNAME="$2";;
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
  echo "This script builds the docker image for the Dockerfile within the given directory, may modify proxy settings for Dockerfile if http_proxy is set within environment."
  echo ""
  echo "Usage:"
  echo "docker-build [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  -p|--project"
  echo "    The project to be build, e.g. base-dev, ibm-iib, ..."
  echo "  -t|--tagname"
  echo "    Optional. Default: \${PROJECT}."
  echo "    The tagname of the docker image - Will be prefixed with ibm/..."
  echo
  sleep 3

  cd ${CURRENTDIR}
  exit $1
}


main "$@"
