GCC = gcc
CC = $(GCC)
CFLAGS = -Wall -g

all: libxdcomms.a

libxdcomms.a: partitioner.o
	ar rcs $@ $^

clean:
	rm -rf *~ *.o libxdcomms.a __pycache__
