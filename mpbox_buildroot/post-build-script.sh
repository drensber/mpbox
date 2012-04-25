#!/bin/sh

TARGET_ROOTFS=$1

MPBOX_TOPDIR=`pwd`/..


#echo "Running post-build-script.  TARGET_ROOTFS=${TARGET_ROOTFS} MYDIR=${MYDIR}"

cp -r ${MPBOX_TOPDIR}/mpbox_buildroot/fs/rootfs_customization/* ${TARGET_ROOTFS}

