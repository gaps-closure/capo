PROG = test1_annotated

VERSION = 1.0.0
DATE = $(shell date +'%Y.%m.%d %H:%M:%S')
HOST = $(shell cat /etc/machine-id)
USER = $(shell whoami)
DIRS =

CXX=g++

LDFLAGS +=
LLVMFLAGS = `llvm-config --cxxflags --libs --ldflags --system-libs`
LLVMFLAGS += -frtti -fexceptions -L/usr/lib/x86_64-linux-gnu  -DLLVM_ENABLE_DUMP=ON
CXXFLAGS += -g $(LLVMFLAGS) -std=c++14

ifeq ($(WITHLICENSE), yes)
  CFLAGS += -DWITHLICENSE
endif

OBJ = \
	verifier.o \
	Partition.o \
	cle_json.o \
	util.o

EXEC = verifier

default: all

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS)

.PHONY : run clean verbose

.cpp.o:
	$(CXX) $(CXXFLAGS) $< -o $@ -c

%.mod.bc: %.mod.ll
	llvm-as $^

%.mod.ll: %.mod.c
	clang -S -g -emit-llvm $^

run:
	./$(EXEC) refactored orange purple

verbose:
	./$(EXEC) -v refactored orange purple

clean:
	-rm -f *.o *~ $(EXEC)

zoom:
	./$(EXEC) -v refactored orange purple
	make -f Makefile.stitch PROG=orange
	make -f Makefile.stitch PROG=purple
	make -f Makefile.stitch capotags

squeaky:
	-rm -f *.o *~ $(EXEC) */ann_map.txt
	make -f Makefile.stitch capoclean	
	make -f Makefile.stitch capoclean PROG=purple
