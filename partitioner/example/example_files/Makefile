CC = gcc
INCLUDE_DIRS = -I../src
CFLAGS = -Wall -g $(INCLUDE_DIRS)
LIBPDG=../../pdg/build/libpdg.so


all: dot

dot: ex1.mod.bc
	opt -load $(LIBPDG) -dot-pdg ex1.mod.bc
	opt -load $(LIBPDG) -dot-ddg ex1.mod.bc
	opt -load $(LIBPDG) -dot-cdg ex1.mod.bc

ex1.mod.bc: ex1.mod.ll
	llvm-as ex1.mod.ll

ex1.mod.ll: ex1.mod.c
	clang -S -g $(INCLUDE_DIRS) -emit-llvm ex1.mod.c

ex1.mod.c: ex1.c
	../../cle/preprocessor/scratch/qd_cle_preprocessor.py -f ex1.c

clang_ex1: ex1.mod.c
	clang -g ex1.mod.c -o ex1.mod.out -L. -lex1

ex1: libex1.a ex1.o
	gcc $(CFLAGS) ex1.o -o ex1 -L. -lex1

libex1.a: ex1_libs.c
	gcc $(CFLAGS) -c ex1_libs.c
	ar rcs libex1.a ex1_libs.o

ex1_orange: libex1.a
	gcc $(CFLAGS) $@.mod.c -o $@ -L. -lex1 -L../src -lpartitioner
ex1_purple: libex1.a
	gcc $(CFLAGS) $@.mod.c -o $@ -L. -lex1 -L../src -lpartitioner
ex1_parts: ex1_orange ex1_purple

clean:
	rm -f *~ *.o ex1 libex1.a clang_ex1 *.dot ex1.mod.bc ex1.mod.ll ex1.mod.c ex1.c.clemap.json  ex1_orange ex1_purple
