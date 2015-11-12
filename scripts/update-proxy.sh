#!/bin/bash
# Use this shell script to update proxy configuration within Dockerfiles before build.
#
# Usage:
# update-proxy disable
#              enable PROXY_HOST:PROXY_PORT

if [ -z "$1" ] || ([ "$1" = "enable" ] && [ -z "$2" ]) || [ ! "$1" = "disable" ]; then
  echo "Usage:"
  echo "update-proxy disable"
  echo "             enable PROXY_HOST:PROXY_PORT"
else
  CURRENTDIR=`pwd`
  BASEDIR=$(dirname $0)

  cd $BASEDIR

  if [ "$1" = "disable" ]; then
    find .. -name Dockerfile -exec sed -i '' -e "s#http_proxy=#http_proxy_disabled=#g" {} +
    find .. -name Dockerfile -exec sed -i '' -e "s#https_proxy=#https_proxy_disabled=#g" {} +
  else
    find .. -name Dockerfile -exec sed -i '' -e "s#http_proxy_disabled=#http_proxy=#g" {} +
    find .. -name Dockerfile -exec sed -i '' -e "s#https_proxy_disabled=#https_proxy=#g" {} +

    find .. -name Dockerfile -exec sed -i '' -e "s#http_proxy=\(http://\)\{0,1\}[^[:space:]]*#http_proxy=\1$2#g" {} +
    find .. -name Dockerfile -exec sed -i '' -e "s#https_proxy=\(http://\)\{0,1\}[^[:space:]]*#https_proxy=\1$2#g" {} +
  fi;

  git status
  cd $CURRENTDIR
fi
