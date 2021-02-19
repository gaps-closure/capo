#Build libxdcomms.a
#
# By default builds to the native system,
# to cross compile libxdcomms-arm64.a run with
# CC=aarch64-none-linux-gnu-gcc

GCC = gcc

CC ?= $(GCC)
AR ?= ar
CFLAGS ?= -Wall -g
LDFLAGS ?=
OBJDIR ?= .

mergeNodeFiless:	mergeNodeFiless.o
	$(CC) -g mergeNodeFiless.o -o mergeNodesFiles

mergeNodeFiles.o:	mergeNodeFiles.c
	$(CC) -g -c mergeNodeFiles.c

createEntryPath:	createEntryPath.o
	$(CC) -g createEntryPath.o -o createEntryPath

createEntryPath.o:	createEntryPath.c
	$(CC) -g -c createEntryPath.c


createAncestorArray:	createAncestorArray.o
	$(CC) -g createAncestorArray.o -o createAncestorArray

createAncestorArray.o:	createAncestorArray.c
	$(CC) -g -c createAncestorArray.c

clean:
	rm createAncestorArray.o createAncestorArray
