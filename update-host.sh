#!/bin/bash
# Use this shell script to update docker host Address within Dockerfiles before build.
#
# Usage:
# update-host OLD_IP NEW_IP

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage:"
  echo "update-host OLD_IP NEW_IP"
else
  find . -name Dockerfile -exec sed -i '' -e "s/$1/$2/g" {} +
fi
