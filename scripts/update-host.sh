#!/bin/bash
# Use this shell script to update docker host Address within Dockerfiles before build.
#
# Usage:
# update-host NEW_HOST

if [ -z "$1" ]; then
  echo "Usage:"
  echo "update-host NEW_HOST"
else
  CURRENTDIR=`pwd`
  BASEDIR=$(dirname $0)

  cd $BASEDIR
  find .. -name Dockerfile -exec sed -i '' -e "s#DOWNLOAD_BASE_URL=http://[^:]*:[^[:space:]]*#DOWNLOAD_BASE_URL=http://$1#g" {} +
  git status
  cd $CURRENTDIR
fi
