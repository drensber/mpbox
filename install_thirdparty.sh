#!/bin/bash
set -e

MPBOX_PACKAGES="http://www.buildroot.org/downloads/buildroot-2012.02.tar.gz https://github.com/downloads/drensber/mpservice/mpservice-0.2.8.tar.bz"

if [ ${#} == "1" ] && [ ${@} == "local" ]; then
  if [ "${THIRDPARTY_PACKAGE_DIR}" == "" ]; then
    echo "THIRDPARTY_PACKAGE_DIR environment variable must be set to use \"local\" option."
    exit 1
  fi

  cd downloads 
    for i in ${MPBOX_PACKAGES}
    do
      ln -sf ${THIRDPARTY_PACKAGE_DIR}/`basename ${i}`
    done
  cd -
  (cd mpservice; ./install_thirdparty.sh local) 
elif [ ${#} == "0" ]; then
  cd downloads
    for i in ${MPBOX_PACKAGES}
    do
      wget ${i}
    done
  cd -
  (cd mpservice; ./install_thirdparty.sh)
else
  echo "usage: install_thirdparty.sh [local]"
fi