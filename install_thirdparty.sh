#!/bin/bash
set -e

#MPBOX_PACKAGES="http://www.uclinux.org/pub/uClinux/dist/uClinux-dist-20110603.tar.bz2 http://busybox.net/downloads/busybox-1.18.5.tar.bz2 http://r8168.googlecode.com/files/r8168-8.024.00.tar.bz2 http://www.sqlite.org/sqlite-amalgamation-3.6.23.1.tar.gz" 
MPBOX_PACKAGES="http://www.buildroot.org/downloads/buildroot-2012.02.tar.gz"

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
  #(cd mpservice; ./install_thirdparty.sh local) 
elif [ ${#} == "0" ]; then
  cd downloads
    for i in ${MPBOX_PACKAGES}
    do
      wget ${i}
    done
  cd -
  #(cd mpservice; ./install_thirdparty.sh)
else
  echo "usage: install_thirdparty.sh [local]"
fi