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

all: $(OBJDIR)/libxdcomms.a

$(OBJDIR)/%.o: %.c
	$(CC) -c $< -o $@
	$(CC) -c -o $@ partitioner.c

$(OBJDIR)/libxdcomms.a: $(OBJDIR)/partitioner.o
	$(AR) rcs $@ $^

clean:
	rm -rf $(OBJDIR)/*~ $(OBJDIR)/*.o $(OBJDIR)/libxdcomms*.a $(OBJDIR)/__pycache__
