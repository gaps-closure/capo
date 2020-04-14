#Build libxdcomms.a
#
# By default builds to the native system,
# to cross compile libxdcomms-arm64.a run with
# CC=aarch64-none-linux-gnu-gcc

GCC = gcc
CC ?= $(GCC)
AR = ar
CFLAGS += -Wall -g

#fix POSTFIX
POSTFIX=
ifeq ($(findstring aarch64,$(CC)),aarch64)
POSTFIX="-arm64"
AR=aarch64-none-linux-gnu-ar
endif

all: libxdcomms$(POSTFIX).a

partitioner$(POSTFIX).o:
	$(CC) -c -o $@ partitioner.c

libxdcomms$(POSTFIX).a: partitioner$(POSTFIX).o
	$(AR) rcs $@ $^

clean:
	rm -rf *~ *.o libxdcomms*.a __pycache__
