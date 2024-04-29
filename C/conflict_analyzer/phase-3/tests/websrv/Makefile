PROG    ?= websrv
SRCS     = $(wildcard *.c)
CFLAGS   = -I ./Communications -I ./Utils \
           -Wno-unused-result -Wno-deprecated-declarations \
           -D_GNU_SOURCE -DMG_ENABLE_MBEDTLS=1 -DMG_ENABLE_MD5=1 -DMG_ENABLE_LINES=1 \
           -DORION_COMM_=1
LDFLAGS  = -L ./Communications -lOrionComm -L ./Utils -lOrionUtils \
           -lavformat -lavcodec -lavutil -lswscale -lswresample \
           -lmbedtls -lmbedcrypto -lmbedx509 \
           -lz -lpthread -lm
SLIBS    = Utils/libOrionUtils.a Communications/libOrionComm.a
COMSRCS  = $(wildcard Communications/*.c)
UTISRCS  = $(wildcard Utils/*.c)
COMOBJS := $(COMSRCS:%.c=%.o)
UTIOBJS := $(UTISRCS:%.c=%.o)

$(PROG): $(SRCS) $(SLIBS)
	$(CC) $(CFLAGS) -o $(PROG) $^ $(LDFLAGS) 

Utils/libOrionUtils.a: $(UTIOBJS)
	$(AR) -crs $@ $^
	rm -f $^

Communications/libOrionComm.a: $(COMOBJS)
	$(AR) -crs $@ $^
	rm -f $^

clean:
	rm -rf $(PROG) $(SLIBS) *.o */*.o 

