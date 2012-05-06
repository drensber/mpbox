# Top level mpbox makefile
MAKEINC_FILE=makefile.inc
TOP_DIR=$(shell \pwd)
MPB_IDIR=$(MPBOX_INSTALL_DIR)

#FS_DIRS = \
#	bin \
#	dev \
#	etc etc/config etc/default etc/init.d etc/dhcpc etc/samba \
#	home home/httpd home/httpd/cgi-bin \
#	lib lib/modules \
#	mnt mnt/cgi \
#	proc \
#	sys \
#	sbin \
#	usr usr/bin usr/sbin \
#	mpservice mpservice/librarydb mpservice/modules \
#	mpservice/cgi-bin mpservice/bin mpservice/misc


all: mpbox

.PHONY: configure
configure: $(MAKEINC_FILE)
$(MAKEINC_FILE): 
	./configure.sh

clean_all:
	touch $(MAKEINC_FILE)
	make -C src clean_all
	rm -f $(MAKEINC_FILE)

mpbox: $(MAKEINC_FILE)
	make -C src

install:
	#for i in $(FS_DIRS); do \
	#	[ -d $(MPB_IDIR)/$$i ] || mkdir -p $(MPB_IDIR)/$$i; \
	#done
	#scp -r rootfs_customization/* $(MPB_IDIR)
	find $(MPB_IDIR) -name '.svn*' |xargs rm -rf
	#ln -sf /var/tmp/log $(MPB_IDIR)/dev/log
	#[ -e $(MPB_IDIR)/etc/init.d/net.eth0 ] || ln -s net $(MPB_IDIR)/etc/init.d/net.eth0
	date '+%Y.%m.%d-%T' > $(MPB_IDIR)/etc/build-date
	make -C src install