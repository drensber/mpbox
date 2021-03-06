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
echo "Building mpservice/src code:"
make -C ${MPBOX_TOPDIR}/mpservice 

echo "Building mpbox/src code"
make -C ${MPBOX_TOPDIR}/mpbox

echo "Installing mpservice/src code:"
make -C ${MPBOX_TOPDIR}/mpservice install \
    MPSERVICE_BIN_DIR=${TARGET_ROOTFS}/mpservice/bin \
    MPSERVICE_WWW_DIR=${TARGET_ROOTFS}/mpservice/www \
    MPSERVICE_CGI_DIR=${TARGET_ROOTFS}/mpservice/cgi-bin \
    MPSERVICE_LIB_DIR=${TARGET_ROOTFS}/lib \
    MPSERVICE_MISC_DIR=${TARGET_ROOTFS}/mpservice/misc \
    STRIP=${CROSS_COMPILE}strip

echo "Installing mpbox/src code:"
make -C ${MPBOX_TOPDIR}/mpbox install MPBOX_INSTALL_DIR=${TARGET_ROOTFS} \
    STRIP=${CROSS_COMPILE}strip

echo "Stripping libcharset and libiconv"
${CROSS_COMPILE}strip ${TARGET_ROOTFS}/usr/lib/libcharset.so.1.0.0
${CROSS_COMPILE}strip ${TARGET_ROOTFS}/usr/lib/libiconv.so.2.5.1

echo "Removing samba startup script"
rm -f ${TARGET_ROOTFS}/etc/init.d/S91smb

