#!/bin/bash

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)

cd $BASEDIR

# Update host if first parameter is set.
if [ ! -z $1 ]; then
  ./update-host.sh $1
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
