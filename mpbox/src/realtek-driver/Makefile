# Makefile for Realtek 8168 driver package
#
include ../../makefile.inc

CC=$(CROSS_COMPILE)gcc
STRIP=$(CROSS_COMPILE)strip
KVER=2.6.39.4
UNPACKAGED_FLAG=.unpackaged

PKGNAME:=r8168-8.024.00
PKGTAR:=$(shell \ls $(MPBOX_THIRDPARTY)/$(PKGNAME)*bz2)
PKGDIR:=$(shell \basename $(PKGTAR) | sed -e 's/.tar.bz2//')

KERNELDIR=$(ROOTDIR)/output/build/linux-${KVER}

EXTRA_MAKE_ARGS=LINUX_SRC=$(KERNELDIR)

KDIR := $(KERNELDIR)
OUTPUTDIR=$(MPBOX_INSTALL_DIR)/mpservice/modules

all: driver

.PHONY: unpackage
unpackage: $(UNPACKAGED_FLAG)
$(UNPACKAGED_FLAG):
	tar xjf $(PKGTAR)
	touch $(UNPACKAGED_FLAG)

driver: $(UNPACKAGED_FLAG)
	make -C $(PKGDIR)/src V=1 PWD=$(shell \pwd)/$(PKGDIR) KDIR=$(KDIR) $(EXTRA_MAKE_ARGS) modules

install:
	mkdir -p $(OUTPUTDIR)
	cp -f $(PKGDIR)/src/r8168.ko $(OUTPUTDIR)

clean_all:
	rm -rf $(PKGDIR) $(UNPACKAGED_FLAG) $(EXENAME) *.o *~