# Makefile for linklocal
#
include ../../makefile.inc 

CC=$(CROSS_COMPILE)gcc
CXX=$(CROSS_COMPILE)g++
STRIP=$(CROSS_COMPILE)strip

SOURCES=AVH-IPv4LL.c  
OBJECTS=$(SOURCES:.c=.o)

HEADERS=

LIBS=

all: linklocal

# generic rule to build a .o from any .c
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

linklocal: AVH-IPv4LL.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ AVH-IPv4LL.o $(LIBS)

.PHONY: install
install:
	cp linklocal $(MPBOX_INSTALL_DIR)/bin
	$(STRIP) $(MPBOX_INSTALL_DIR)/bin/linklocal

.PHONY: clean
clean:
	rm -f linklocal $(OBJECTS)
	rm -f *~

.PHONY: clean_all
clean_all: clean
