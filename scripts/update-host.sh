#!/bin/bash
# Use this shell script to update docker host Address within Dockerfiles before build.
#
# Usage:
# update-host OLD_IP NEW_IP

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage:"
  echo "update-host OLD_IP NEW_IP"
else
  find .. -name Dockerfile -exec echo {} +
  find .. -name Dockerfile -exec sed -i '' -e "s/DOWNLOAD_BASE_URL=http\:\/\/[a-zA-Z0-9\.]+(\:[0-9]+)?)/DOWNLOAD_BASE_URL=http\:\/\/$2/g" {} +
fi
