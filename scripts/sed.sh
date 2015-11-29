#!/bin/bash
#
# (c) michael.wellner@de.ibm.com 2015.
#
# This script checks for different versions of sed and executes inplace replacement.
# 
# Usage:
# sed [ -h | --help | OPTIONS ]
# 
# Options:
#   -a|--args
#     Arguments passed to sed.
#

# Fail if one of the commands fails
set -e

CURRENTDIR=`pwd`
BASEDIR=$(dirname $0)
ARGS=


main() {
  cd ${BASEDIR} 
  read_variables "$@"
  check_required
  
  CHECK_SED=`(sed -h 2>&1 >/dev/null | grep "i extension" > /dev/null) && echo 0 || echo 1`
  
  if [ $CHECK_SED -eq 0 ]; then
    sed -i '' -e ${ARGS[@]}
  else
    sed -i -e ${ARGS[@]}
  fi;
  cd ${CURRENTDIR}
}

check_required() {
  if [ -z "${ARGS}" ]; then
    >&2 echo "Missing required parameter: -a|--args."
    show_help_and_exit 1
  fi;
}

read_variables() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      -a|--args)
        ARGS="${@:2}";break;;
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
  echo "This script checks for different versions of sed and executes inplace replacement."
  echo ""
  echo "Usage:"
  echo "sed [ -h | --help | OPTIONS ]"
  echo ""
  echo "Options:"
  echo "  -a|--args"
  echo "    Arguments passed to sed."
  echo
  sleep 3
  
  cd ${CURRENTDIR}
  exit $1
}


main "$@"
