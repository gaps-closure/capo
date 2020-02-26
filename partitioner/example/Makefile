PROG = ex1
ENC1 = orange
ENC2 = purple

CC = gcc
INCLUDE_DIRS = -I../src
CFLAGS = -Wall -g $(INCLUDE_DIRS)
LIBPDG=../../pdg/build/libpdg.so


all: dot

.SECONDARY:

dot: $(PROG).mod.bc
	opt -load $(LIBPDG) -dot-pdg $^
	opt -load $(LIBPDG) -dot-ddg $^
	opt -load $(LIBPDG) -dot-cdg $^

%.mod.bc: %.mod.ll
	llvm-as $^

%.mod.ll: %.mod.c
	clang -S -g $(INCLUDE_DIRS) -emit-llvm $^

%.mod.c: %.c
	../../cle/preprocessor/scratch/qd_cle_preprocessor.py -f $^

clang_$(PROG): lib$(PROG).a $(PROG).mod.c
	clang -g $^ -o $@ -L. -l$(PROG)

$(PROG): lib$(PROG).a $(PROG).o
	gcc $(CFLAGS) $(PROG).o -o $(PROG) -L. -l$(PROG)

lib$(PROG).a: $(PROG)_libs.c
	gcc $(CFLAGS) -c $(PROG)_libs.c
	ar rcs lib$(PROG).a $(PROG)_libs.o

$(PROG)_$(ENC1): lib$(PROG).a
	gcc $(CFLAGS) $@.mod.c -o $@ -L. -l$(PROG) -L../src -lpartitioner
$(PROG)_$(ENC2): lib$(PROG).a
	gcc $(CFLAGS) $@.mod.c -o $@ -L. -l$(PROG) -L../src -lpartitioner
$(PROG)_parts: $(PROG)_$(ENC1) $(PROG)_$(ENC2)

packages:
	tar cf $(PROG)_$(ENC1)-enclave-gw-P.tar $(PROG)_$(ENC1)
	tar cf $(PROG)_$(ENC2)-enclave-gw-O.tar $(PROG)_$(ENC2) boats.jpg

clean:
	rm -f *~ *.o $(PROG) lib$(PROG).a clang_$(PROG) *.dot $(PROG).mod.bc $(PROG).mod.ll $(PROG).mod.c $(PROG).c.clemap.json  $(PROG)_orange $(PROG)_purple *.tar
