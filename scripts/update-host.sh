#!/bin/bash
# (c) michael.wellner@de.ibm.com
#
# Use this shell script to update DOWNLOAD_BASE_URL within Dockerfiles before build.
#
# Usage:
# update-host DOWNLOAD_BASE_URL

if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Use this shell script to update DOWNLOAD_BASE_URL within Dockerfiles before build."
  echo
  echo "Usage:"
  echo "update-host DOWNLOAD_BASE_URL"
else
  CURRENTDIR=`pwd`
  BASEDIR=$(dirname $0)

  cd $BASEDIR
  find .. -name Dockerfile -exec sed -i '' -e "s#DOWNLOAD_BASE_URL=http://[^:]*:[^[:space:]]*#DOWNLOAD_BASE_URL=http://$1#g" {} +
  git status
  cd $CURRENTDIR
fi
