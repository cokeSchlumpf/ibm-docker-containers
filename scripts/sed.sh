#!/bin/bash
#
# (c) michael.wellner@de.ibm.com
#
# Executes sed in different ways depending on the OS.
#

CHECK_SED=`sed -h 2>&1 >/dev/null | grep "i extension"`

if [ ! -z $CHECK_SED ]; then
  # Mac OS
  sed -i '' -e $@
else
  sed -e $@
fi;
