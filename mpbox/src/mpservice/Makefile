# Makefile for mpservice package
#
include ../../makefile.inc

PKGNAME:=mpservice
PKGTAR:=$(shell \ls $(MPBOX_THIRDPARTY)/$(PKGNAME)*gz)
PKGDIR:=$(shell \basename $(PKGTAR) | sed -e 's/.tar.gz//')

UNPACKAGED_FLAG=.unpackaged
BUILT_FLAG=.built

all: mpservice

.PHONY: mpservice
mpservice: $(UNPACKAGED_FLAG)
	make -C $(PKGDIR)
	touch $(BUILT_FLAG)

.PHONY: unpackage
unpackage: $(UNPACKAGED_FLAG)
$(UNPACKAGED_FLAG):
	tar -xzf $(PKGTAR)
	touch $(UNPACKAGED_FLAG)

.PHONY: install
install: $(BUILT_FLAG)
	#cp boa.conf $(MPSERVICE_MISC_DIR)
	#cp $(BOA_BINARY) $(MPSERVICE_BIN_DIR)
	#$(STRIP) $(MPSERVICE_BIN_DIR)/boa

clean:
	@if [ -r $(PKGDIR) ]; then \
	  $(MAKE) -C $(PKGDIR) $@ ; \
	fi

clean_all:
	rm -rf $(PKGDIR) $(UNPACKAGED_FLAG) *~

