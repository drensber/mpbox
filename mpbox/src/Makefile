# Makefile for all the stuff in mpbox/src
#
include ../makefile.inc

#LIB_DIRS=sqlite
EXE_DIRS=linklocal media_mount_management upgrade_firmware \
	mpb-commands realtek-driver

ALL_DIRS=$(LIB_DIRS) $(EXE_DIRS)

all: executables

.PHONY: libraries
libraries:
	@for DIR in $(LIB_DIRS) ; do \
	make -C $$DIR ; done

.PHONY: executables
executables: libraries
	@for DIR in $(EXE_DIRS) ; do \
	make -C $$DIR ; done

.PHONY: install
install: 
	@for DIR in $(ALL_DIRS) ; do \
	make -C $$DIR install; done

clean:
	@for DIR in $(ALL_DIRS) ; do \
	make -C $$DIR clean ; done

clean_all:
	@for DIR in $(ALL_DIRS) ; do \
	make -C $$DIR clean_all ; done
