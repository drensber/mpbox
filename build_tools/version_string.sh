#!/bin/sh

MAJOR=`fgrep version__major__ ${PROJECT_ROOT}/mpservice/src/mps-config/mpservice_constants.xml | awk '{ print $3 }' | awk -F \" '{ print $2 }'`
MINOR=`fgrep version__minor__ ${PROJECT_ROOT}/mpservice/src/mps-config/mpservice_constants.xml | awk '{ print $3 }' | awk -F \" '{ print $2 }'`
RELEASE=`fgrep version__release__ ${PROJECT_ROOT}/mpservice/src/mps-config/mpservice_constants.xml | awk '{ print $3 }' | awk -F \" '{ print $2 }'`
BUILD=`fgrep version__build__ ${PROJECT_ROOT}/mpservice/src/mps-config/mpservice_constants.xml | awk '{ print $3 }' | awk -F \" '{ print $2 }'`

echo -n "${MAJOR}.${MINOR}.${RELEASE}"

if [ "${BUILD}" != "" ]; then
  echo ".${BUILD}"
else
  echo
fi
