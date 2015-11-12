#!/bin/bash
# Use this shell script to update proxy configuration within Dockerfiles before build.
#
# Usage:
# update-proxy disable
#              enable PROXY_HOST:PROXY_PORT
#              auto
#
# If mode is set to auto the script uses the environmant variable http_proxy to detect whether to set a proxy or not.

show_help() {
  echo "Usage:"
  echo "update-proxy disable"
  echo "             enable PROXY_HOST:PROXY_PORT"
  echo "             auto"
  echo
  echo "If mode is set to auto the script uses the environmant variable http_proxy to detect whether to set a proxy or not."
  echo
  sleep 3
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
  exit 0;
elif [ -z "$1" ] || ([ "$1" = "enable" ] && [ -z "$2" ]) || ([ ! "$1" = "disable" ] && [ ! "$1" = "enable" ] && [ ! "$1" = "auto" ]); then
  echo "Arguments ($1, $2) are not valid."
  echo
  show_help
  exit 1;
fi;

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)

cd $BASEDIR

if [ "$1" = "auto" ]; then
  HTTP_PROXY=$(echo ${http_proxy} | sed "s#\(http://\)\{0,1\}\([\.]*\)#\2#g")

  if [ ! -z ${HTTP_PROXY} ]; then
    MODE="enable"
  else
    MODE="disable"
  fi;
else
  HTTP_PROXY=$2
  MODE=$1
fi;

if [ "${MODE}" = "disable" ]; then
  echo "Disable proxy ..."

  find .. -name Dockerfile -exec sed -i '' -e "s#http_proxy=#http_proxy_disabled=#g" {} +
  find .. -name Dockerfile -exec sed -i '' -e "s#https_proxy=#https_proxy_disabled=#g" {} +
else
  echo "Enable proxy ${HTTP_PROXY} ..."

  find .. -name Dockerfile -exec sed -i '' -e "s#http_proxy_disabled=#http_proxy=#g" {} +
  find .. -name Dockerfile -exec sed -i '' -e "s#https_proxy_disabled=#https_proxy=#g" {} +

  find .. -name Dockerfile -exec sed -i '' -e "s#http_proxy=\(http://\)\{0,1\}[^[:space:]]*#http_proxy=\1${HTTP_PROXY}#g" {} +
  find .. -name Dockerfile -exec sed -i '' -e "s#https_proxy=\(http://\)\{0,1\}[^[:space:]]*#https_proxy=\1${HTTP_PROXY}#g" {} +
fi;

git status
cd $CURRENTDIR
