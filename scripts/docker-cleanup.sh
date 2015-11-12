#!/bin/bash
#
# (c) michael.wellner@de.ibm.com
#
# Cleans your docker environment:
#
# * Deletes all containers with status `Exited`
# * Removes all root images which don't have a tag (results from unsuccessful `docker build` executions)
# * Removes all unused volumes
#
# Usage:
#
# docker-cleanup

docker ps -a | grep 'Exited' | awk '{print $1}' | xargs docker rm -v
docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
docker volume ls | grep local | awk '{print $2}' | xargs docker volume rm
