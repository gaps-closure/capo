BUILD=../../../../../..
INCLUDES=-I${BUILD}/src/hal/api -I../autogen
LDLIBS=-L${BUILD}/src/hal/api
LIBS=../autogen/libcodecs.a -lpthread

all: example1_purple

clean:
	make -C ../autogen clean
	rm -f *.o *~ example1_purple

example1_purple: example1_purple.c example1_purple_rpc.c
	make -C ../autogen autogen
	make -C ../autogen libraries
	gcc -c example1_purple.c example1_purple_rpc.c ${INCLUDES}
	gcc -o example1_purple example1_purple.o example1_purple_rpc.o ${LDLIBS} ${LIBS} -lxdcomms

