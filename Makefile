#
# Top level makefile that can make the uClinux-dist based project and
# package up all of the images into a *.fw file.
#
THIRDPARTY_DOWNLOADED_FLAG=downloads/.downloaded
BUILDROOT_INSTALLED_FLAG=buildroot/.installed
BUILDROOT_PACKAGE=buildroot-2012.02.tar.gz
BUILDROOT_BASE=$(shell \basename $(BUILDROOT_PACKAGE) | sed -e 's/.tar.gz//')
PROJECT_ROOT=$(shell pwd)
BUILDROOT_CUSTOMIZATION=$(PROJECT_ROOT)/mpbox_buildroot

.PHONY: help
help:
	@echo
	@echo "Top level makefile for mpbox."
	@echo
	@echo "Usage:"
	@echo "  make help - Display this help screen (default)."
	@echo "  make image - Make an firmware image for mpbox."
	@echo "  make download - Download 3rd party dependencies from net"
	@echo "  make download-local - Set up build system to use source"
	@echo "                        packages that have already been" 
	@echo "                        downloaded to the directory specified"
	@echo "                        by environment variable"
	@echo "                        THIRDPARTY_PACKAGE_DIR."
	@echo "  make clean-downloads - Clean the downloads directory"
	@echo "                         (effectively undoes 'make download'"
	@echo "                         or 'make download-local')."
	@echo "  make clean-staging - "
	@echo "  make clean - "
	@echo

default: help

.PHONY: all
all: linux firmwarepackage

.PHONY: images
images: image

.PHONY: image
image: all

.PHONY: linux
linux: $(BUILDROOT_INSTALLED_FLAG) 
	make -C buildroot

.PHONY: menuconfig
menuconfig: 
	make -C buildroot menuconfig

.PHONY: download
download: $(THIRDPARTY_DOWNLOADED_FLAG)
$(THIRDPARTY_DOWNLOADED_FLAG):
	./install_thirdparty.sh
	rm -rf $(BUILDROOT_CUSTOMIZATION)/dl
	mkdir $(BUILDROOT_CUSTOMIZATION)/dl
	touch $(THIRDPARTY_DOWNLOADED_FLAG)

.PHONY: download-local
download-local:
	./install_thirdparty.sh local
	rm -rf $(BUILDROOT_CUSTOMIZATION)/dl
	ln -s $(THIRDPARTY_PACKAGE_DIR) $(BUILDROOT_CUSTOMIZATION)/dl
	touch $(THIRDPARTY_DOWNLOADED_FLAG)

.PHONY: clean-downloads
clean-downloads:
	rm -f downloads/* $(THIRDPARTY_DOWNLOADED_FLAG)

$(BUILDROOT_INSTALLED_FLAG): $(THIRDPARTY_DOWNLOADED_FLAG)
	tar xzf downloads/$(BUILDROOT_PACKAGE)
	mv $(BUILDROOT_BASE) buildroot
	ln -s $(BUILDROOT_CUSTOMIZATION) buildroot/target/mpbox
	cp $(BUILDROOT_CUSTOMIZATION)/config/buildroot_config buildroot/.config
	echo "\"$(ESCAPED_TPD)\""
	touch $(BUILDROOT_INSTALLED_FLAG)

.PHONY: firmwarepackage
firmwarepackage:
	rm -rf images; mkdir images
	cp buildroot/output/images/bzImage images
	cp buildroot/output/images/rootfs.ext2 images/initrd.ext2
	gzip images/initrd.ext2
	mv images/initrd.ext2.gz images/initrd.bin
	tar czf images.tgz images
	rm -rf images
	mv images.tgz mpbox.fw

clean-staging:
	#rm -rf uClinux-dist/romfs/*
	rm -f mpbox.fw

clean:
	make -C buildroot clean
	rm -f mpbox.fw

distclean:
	rm -rf buildroot
	rm -f mpbox.fw

clean_all: distclean
	rm -f downloads/*
	rm -rf $(BUILDROOT_CUSTOMIZATION)/dl
	rm -f $(THIRDPARTY_DOWNLOADED_FLAG)
