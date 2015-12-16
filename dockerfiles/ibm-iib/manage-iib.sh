#!/bin/bash

mqsiservice -v

. /opt/mqm/bin/setmqenv -s

QEUEUE_MGR_EXISTS=`dspmq | grep ${QUEUE_MGR_NAME} > /dev/null ; echo $?`

if [  ${QUEUE_MGR_EXISTS} -ne 0 ]; then
  echo "Qeue Manager ${QUEUE_MGR_NAME} does not exist..."
  echo "Creating Queue Manager ${QUEUE_MGR_NAME}"
  crtmqm ${QUEUE_MGR_NAME}
  dspmqinf -o command ${QUEUE_MGR_NAME}
fi

echo "Starting Queue Manager ${QUEUE_MGR_NAME}..."
strmqm ${QUEUE_MGR_NAME}

NODE_EXISTS=`mqsilist | grep ${BROKER_NAME} > /dev/null ; echo $?`

if [ ${NODE_EXISTS} -ne 0 ]; then
  echo "Node ${BROKER_NAME} does not exist..."
  echo "Creating node ${BROKER_NAME}"
  mqsicreatebroker ${BROKER_NAME} -q ${QUEUE_MGR_NAME}
fi

echo "Starting Message Broker ${BROKER_NAME}..."
mqsistart ${BROKER_NAME}
