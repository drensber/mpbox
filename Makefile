#
# Top level makefile that can make the uClinux-dist based project and
# package up all of the images into a *.fw file.
#
THIRDPARTY_DOWNLOADED_FLAG=downloads/.downloaded
BUILDROOT_INSTALLED_FLAG=buildroot/.installed
MPSERVICE_INSTALLED_FLAG=mpservice/.installed
BUILDROOT_PACKAGE=buildroot-2012.02.tar.gz
MPSERVICE_PACKAGE=mpservice-0.2.8.tar.bz
BUILDROOT_BASE=$(shell \basename $(BUILDROOT_PACKAGE) | sed -e 's/.tar.gz//')
MPSERVICE_BASE=$(shell \basename $(MPSERVICE_PACKAGE) | sed -e 's/.tar.bz//')
PROJECT_ROOT=$(shell pwd)
BUILDROOT_CUSTOMIZATION=$(PROJECT_ROOT)/mpbox_buildroot
BR_OUTPUT=buildroot/output
BR_BUILD=$(BR_OUTPUT)/build

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
linux: $(BUILDROOT_INSTALLED_FLAG) $(MPSERVICE_INSTALLED_FLAG)
	make -C buildroot

.PHONY: menuconfig
buildroot-menuconfig: 
	make -C buildroot menuconfig
	cp buildroot/.config mpbox_buildroot/config/buildroot_config

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
	touch $(BUILDROOT_INSTALLED_FLAG)

$(MPSERVICE_INSTALLED_FLAG): $(THIRDPARTY_DOWNLOADED_FLAG)
	tar xjf downloads/$(MPSERVICE_PACKAGE)
	mv $(MPSERVICE_BASE) mpservice
	touch $(MPSERVICE_INSTALLED_FLAG)


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

clean-target:
	rm -rf $(BR_OUTPUT)/target $(BR_OUTPUT)/staging $(BR_OUTPUT)/stamps $(BR_BUILD)/.root $(BR_BUILD)/*/.stamp_target_installed $(BR_BUILD)/*/.stamp_staging_installed $(BR_BUILD)/linux-*/.stamp_installed $(BR_BUILD)/*/.built
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
