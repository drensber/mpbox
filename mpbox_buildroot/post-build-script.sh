#!/bin/sh

TARGET_ROOTFS=$1

MPBOX_TOPDIR=`pwd`/..


echo "Running post-build-script."
echo "cp -rf --remove-destination ${MPBOX_TOPDIR}/mpbox_buildroot/fs/rootfs_customization/* ${TARGET_ROOTFS}"
cp -rf --remove-destination ${MPBOX_TOPDIR}/mpbox_buildroot/fs/rootfs_customization/* ${TARGET_ROOTFS}

