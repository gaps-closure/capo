BUILD=../../../../../..
INCLUDES=-I${BUILD}/src/hal/api -I../autogen
LDLIBS=-L${BUILD}/src/hal/api
LIBS=../autogen/libcodecs.a -lpthread

all: test1_orange

clean:
	make -C ../autogen clean
	rm -f *.o *~ test1_orange

test1_orange: test1_orange.c test1_orange_rpc.c
	make -C ../autogen autogen
	make -C ../autogen libraries
	gcc -c test1_orange.c test1_orange_rpc.c ${INCLUDES}
	gcc -o test1_orange test1_orange.o test1_orange_rpc.o ${LDLIBS} ${LIBS} -lxdcomms

