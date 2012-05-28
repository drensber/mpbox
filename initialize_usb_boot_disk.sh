#!/bin/bash
#
set -e

if [ `whoami` != "root" ]; then
  echo "This script must be run as superuser."
  exit
fi


# assume that partition 1 in target disk has already been created
TARGET_BOOT_DEV_NAME="/dev/sda"
DEV_NAME="/dev/sdb"
PART_NAME="/dev/sdb1"
MOUNT_POINT="bootmnt"

echo "umounting ${PART_NAME}"
sudo umount ${PART_NAME} 

echo 
echo "Building boot disk on ${DEV_NAME}"
echo "  Creating temporary mount point bootmnt"
mkdir ${MOUNT_POINT}

echo "  Making ext2 filesystem on $PART_NAME"
/sbin/mke2fs -j ${PART_NAME} > build_system_disk.err 2>&1

echo "  Mounting target root partition at $MOUNT_POINT"
mount ${PART_NAME} ${MOUNT_POINT}


tar xzf mpbox.fw

echo "  Copying kernel and ramfs image to $MOUNT_POINT"
cp -a images/bzImage ${MOUNT_POINT}
cp -a images/initrd.bin ${MOUNT_POINT}
cp -a images/bzImage ${MOUNT_POINT}/bzImage_safe
cp -a images/initrd.bin ${MOUNT_POINT}/initrd_safe.bin

rm -rf images

echo "  Initializing GRUB files in $MOUNT_POINT"
mkdir ${MOUNT_POINT}/boot
mkdir ${MOUNT_POINT}/boot/grub

#    cat > ${MOUNT_POINT}/boot/grub/grub.conf <<EOF
    cat > ${MOUNT_POINT}/boot/grub/grub.cfg <<EOF
# grub.conf 
#
#boot=${PART_NAME}
default=0
timeout=3

#serial console
#serial --unit=0 --speed=115200
#terminal --timeout=3 serial console

menuentry "mpbox kernel" {
        set root='(hd0,1)'
        linux /bzImage ro root=/dev/ram0 init=/linuxrc console=tty0 console=ttyS0,115200n8
        initrd /initrd.bin
}

menuentry "mpbox kernel (safe-mode)" {
        set root='(hd0,1)'
        linux /bzImage_safe ro root=/dev/ram0 init=/linuxrc console=tty0 console=ttyS0,115200n8
        initrd /initrd_safe.bin
}

menuentry "mpbox kernel - monitor console" {
        set root='(hd0,1)'
        linux /bzImage ro root=/dev/ram0 init=/linuxrc
        initrd /initrd.bin
}

menuentry "mpbox kernel (safe-mode) - monitor console" {
        set root='(hd0,1)'
        linux /bzImage_safe ro root=/dev/ram0 init=/linuxrc
        initrd /initrd_safe.bin
}

EOF

#title mpbox kernel (2.6.x)
#        root (hd0,1)
#        kernel /vmlinuz ro root=/dev/ram0 console=tty0 console=ttyS0,115200n8
#        initrd /initrd.bin
#
#    cat > ${MOUNT_POINT}/boot/grub/device.map <<EOF
#(hd0)   ${TARGET_BOOT_DEV_NAME}
#EOF


echo "  Installing grub on the boot sector"
grub-install --no-floppy --root-directory=${MOUNT_POINT} ${DEV_NAME} > build_system_disk.err 2>&1

echo "  Unmounting target root partition at $MOUNT_POINT" 
umount ${PART_NAME}

echo "  Removing mount point bootmnt"
rmdir bootmnt

echo "Done"

