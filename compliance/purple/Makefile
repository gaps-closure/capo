BUILD=../../../../../..
INCLUDES=-I${BUILD}/src/hal/api -I../autogen
LDLIBS=-L${BUILD}/src/hal/api
LIBS=../autogen/libcodecs.a -lpthread

all: test1_purple

clean:
	make -C ../autogen clean
	rm -f *.o *~ test1_purple

test1_purple: test1_purple.c test1_purple_rpc.c
	make -C ../autogen autogen
	make -C ../autogen libraries
	gcc -c test1_purple.c test1_purple_rpc.c ${INCLUDES}
	gcc -o test1_purple test1_purple.o test1_purple_rpc.o ${LDLIBS} ${LIBS} -lxdcomms

