#!/bin/bash
docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm
docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
