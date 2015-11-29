#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script creates a docker-compose.yml from compose/_PROJECT_/docker-compose.abstract.yml and executes it.
# 
# Usage:
# docker-compose [ -h | --help | OPTIONS ]
# 
# Options:
#   -p|--project
#     compose project to be used.
#   -c|--cmd
#     docker-compose command.
#   -y|--yaml
#     Optional. Default: ../compose/${PROJECT}/docker-compose.yml.
#     The yaml file to be used.
#   -a|--args
#     Optional.
#     Arguments which will be replaced in the form key=value,key=value,...
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)
PROJECT=
CMD=
YAML=
ARGS=


main() {
  cd ${BASEDIR} 
  read_variables "$@"
  check_required
  init_defaults
  
  echo "Executing docker-compose in '../compose/${PROJECT}' with '${CMD[@]}', arguments: '${ARGS}' ..."
  
  echo "Creating ${YAML} ..."
  cat ../compose/${PROJECT}/docker-compose.abstract.yml > ${YAML}
  
  if [ ! -z "${ARGS}" ]; then
  	ARGUMENTS=($(echo "${ARGS}" | tr ',' ' '))
  
  	for ARGUMENT in "${ARGUMENTS[@]}" /
     do
     	KEY=`echo "${ARGUMENT}" | awk -F= '{print $1}'`
  		VALUE=`echo "${ARGUMENT}" | awk -F= '{print $2}'`
  
  		echo "Replacing '${KEY}' with '${VALUE}' ..."
  
  		./sed.sh --args "s#\${${KEY}}#${VALUE}#g" ${YAML}
     done
  fi;
  
  echo "Using docker-compose.yaml:"
  echo "######################################################################"
  cat ${YAML}
  echo "######################################################################"
  
  echo ${CMD[@]}
  
  docker-compose -f ${YAML} ${CMD[@]} && echo "Successfully executed docker-compose." ||  echo "Error during docker-compose."
  rm ${YAML} || true
  cd ${CURRENTDIR}
}

check_required() {
  if [ -z "${PROJECT}" ]; then
    >&2 echo "Missing required parameter: -p|--project."
    show_help_and_exit 1
  fi;
  if [ -z "${CMD}" ]; then
    >&2 echo "Missing required parameter: -c|--cmd."
    show_help_and_exit 1
  fi;
}

init_defaults() {
	if [ -z "${YAML}" ]; then
	  YAML="../compose/${PROJECT}/docker-compose.yml"
	fi;
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      -p|--project)
        PROJECT="$2";;
      -c|--cmd)
        CMD="${@:2}";break;;
      -y|--yaml)
        YAML="$2";;
      -a|--args)
        ARGS="$2";;
      -h|--help)
        show_help_and_exit 0;;
      *)
        >&2 echo "Unkown option $1 with value $2."
        echo
        show_help_and_exit 2
        ;;
    esac
    shift # past argument
    shift # past argument
  done
}

show_help_and_exit() {
  echo "This script creates a docker-compose.yml from compose/_PROJECT_/docker-compose.abstract.yml and executes it."
  echo ""
  echo "Usage:"
  echo "docker-compose [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  -p|--project"
  echo "    compose project to be used."
  echo "  -c|--cmd"
  echo "    docker-compose command."
  echo "  -y|--yaml"
  echo "    Optional. Default: ../compose/\${PROJECT}/docker-compose.yml."
  echo "    The yaml file to be used."
  echo "  -a|--args"
  echo "    Optional."
  echo "    Arguments which will be replaced in the form key=value,key=value,..."
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}


main "$@"
