#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015
#
# Builds all docker images within the project. Before building the DOWNLOAD_BASE_URL and the proxy settings may be updated within Dockerfiles.
#
# Usage:
# build-all [options]
#
# Options:
#   -d|--download-base-url DOWNLOAD_BASE_URL
#           Define DOWNLOAD_BASE_URL to be passed to update-host.sh. See './update-host.sh -h' for details.
#   -m|--proxy-mode disable|enable|auto
#           Define the update mode for update-proxy.sh. See './update-proxy.sh -h' for deatils.
#   -p|--proxy PROXY_HOST:PROXY_PORT
#           Define the proxy url for update-proxy.sh. See './update-proxy.sh -h' for deatils.
#   -h|--help
#           Show this help.
#

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)

show_help() {
  echo "Builds all docker images within the project. Before building the DOWNLOAD_BASE_URL and the proxy settings may be updated within Dockerfiles."
  echo
  echo "Usage:"
  echo "build-all [options]"
  echo
  echo "Options:"
  echo "  -d|--download-base-url DOWNLOAD_BASE_URL"
  echo "          Define DOWNLOAD_BASE_URL to be passed to update-host.sh. See './update-host.sh -h' for details."
  echo "  -m|--proxy-mode disable|enable|auto"
  echo "          Define the update mode for update-proxy.sh. See './update-proxy.sh -h' for deatils."
  echo "  -p|--proxy PROXY_HOST:PROXY_PORT"
  echo "          Define the proxy url for update-proxy.sh. See './update-proxy.sh -h' for deatils."
  echo "  -h|--help"
  echo "          Show this help."
  echo
  sleep 3

  exit 0;
}

while [[ $# > 0 ]]
do
key="$1"

case $key in
    -d|--download-base-url)
    DOWNLOAD_BASE_URL="$2"
    shift # past argument
    ;;
    -m|--proxy-mode)
    PROXY_MODE="$2"
    shift # past argument
    ;;
    -p|--proxy)
    PROXY="$2"
    shift # past argument
    ;;
    -h|--help)
    show_help
    ;;
    *)
    # unknown option
    ;;
esac
shift # past argument or value
done

cd $BASEDIR

# Update host if parameter is set.
if [ ! -z ${DOWNLOAD_BASE_URL} ]; then
  ./update-host.sh ${DOWNLOAD_BASE_URL}
fi

# Update proxy
if [  -z ${PROXY_MODE} ]; then
  ./update-proxy.sh auto
else
  ./update-proxy.sh ${PROXY_MODE} ${PROXY}
fi

# Build images
cd      ../base-centos     && docker build -t ibm/base-centos .  && cd - \
  && cd ../ibm-iib         && docker build -t ibm/iib .          && cd - \
  && cd ../ibm-wlp         && docker build -t ibm/wlp .          && cd - \
  && cd ../base-dev        && docker build -t ibm/base-dev .     && cd - \
  && cd ../dev             && docker build -t ibm/dev .          && cd - \
  && cd ../build/build-dvc && docker build -t ibm/build-dvc .    && cd - \
  && cd ../build           && docker build -t ibm/build .        && cd -

cd $CURRENTDIR
docker images
