#!/bin/bash

TARGET_ROOTFS=${1}

MPBOX_TOPDIR=`(cd ..; pwd)`

cd ${MPBOX_TOPDIR}
. ./x86-uClibc-linux.env
cd -
 
echo
echo "Running post-build-script."
echo
echo "Copying rootfs_customization:"
echo "cp -rf --remove-destination ${MPBOX_TOPDIR}/mpbox_buildroot/fs/rootfs_customization/* ${TARGET_ROOTFS}"
cp -rf --remove-destination ${MPBOX_TOPDIR}/mpbox_buildroot/fs/rootfs_customization/* ${TARGET_ROOTFS}

echo
echo "Building mpservice code:"
make -C ${MPBOX_TOPDIR}/mpservice 

echo "Installing mpservice code:"
make -C ${MPBOX_TOPDIR}/mpservice install \
    MPSERVICE_BIN_DIR=${TARGET_ROOTFS}/mpservice/bin \
    MPSERVICE_WWW_DIR=${TARGET_ROOTFS}/mpservice/www \
    MPSERVICE_CGI_DIR=${TARGET_ROOTFS}/mpservice/cgi-bin \
    MPSERVICE_LIB_DIR=${TARGET_ROOTFS}/lib \
    MPSERVICE_MISC_DIR=${TARGET_ROOTFS}/mpservice/misc \
    STRIP=${CROSS_COMPILE}strip
