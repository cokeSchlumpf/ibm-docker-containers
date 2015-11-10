#!/bin/bash

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)

cd $BASEDIR

# Update host if first parameter is set.
if [ -n $1 ]; then
  ./update-host.sh $1
fi

# Build images
cd ../centos-base && docker build -t ibm/centos-base . && cd -
cd ../ibm-iib && docker build -t ibm/iib . && cd -
cd ../ibm-wlp && docker build -t ibm/wlp . && cd -
cd ../devserver-base && docker build -t devserver-base . && cd -
cd ../devserver && docker build -t devserver . && cd -
cd ../buildserver/buildserver-dvc && docker build -t buildserver-dvc . && cd -
cd ../buildserver && docker build -t buildserver . && cd -

cd $CURRENTDIR
docker images
