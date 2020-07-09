/* This file is autogenerated by CAPO to support RPC */

#include "test1_orange_rpc.h"

#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)

#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }

void _handle_requesta(__attribute__((unused))void* tag) {
    static int inited = 0;
    static void *psocket;
    static void *ssocket;
    gaps_tag t_tag;
    gaps_tag o_tag;
#pragma clang attribute push (__attribute__((annotate("TAG_REQUEST_GET_A"))), apply_to = any(function,type_alias,record,enum,variable,field))
    #pragma cle begin TAG_REQUEST_GET_A
    requesta_datatype  reqA; 
    #pragma cle end TAG_REQUEST_GET_A
#pragma clang attribute pop
#pragma clang attribute push (__attribute__((annotate("TAG_RESPONSE_GET_A"))), apply_to = any(function,type_alias,record,enum,variable,field))
    #pragma cle begin TAG_RESPONSE_GET_A
    responsea_datatype resA;
    #pragma cle end TAG_RESPONSE_GET_A
#pragma clang attribute pop
                               
    tag_write(&t_tag, MUX_REQUESTA, SEC_REQUESTA, DATA_TYP_REQUESTA);
    if (!inited) {
      inited = 1;
      psocket = xdc_pub_socket();
      ssocket = xdc_sub_socket(t_tag); 
      sleep(1); /* zmq socket join delay */
    }

    xdc_blocking_recv(ssocket, &reqA, &t_tag);
    resA.a = get_a();

    // function needs a bunch of input, output, both, and return assignment vars
    // cross-domain call needs one struct going forward and anotehr coming back
    // here we manage all of the marshalling and unmarshalling

    tag_write(&o_tag, MUX_RESPONSEA, SEC_RESPONSEA, DATA_TYP_RESPONSEA);
    xdc_asyn_send(psocket, &resA, &o_tag);
}

void _handle_nxtrpc(gaps_tag* n_tag) {
    static int inited = 0;
    static void *psocket;
    static void *ssocket;
    gaps_tag t_tag;
    gaps_tag o_tag;
#pragma clang attribute push (__attribute__((annotate("TAG_NEXTRPC"))), apply_to = any(function,type_alias,record,enum,variable,field))
    #pragma cle begin TAG_NEXTRPC
    nextrpc_datatype nxt;
    #pragma cle end TAG_NEXTRPC
#pragma clang attribute pop
#pragma clang attribute push (__attribute__((annotate("TAG_OKAY"))), apply_to = any(function,type_alias,record,enum,variable,field))
    #pragma cle begin TAG_OKAY
    okay_datatype okay;
    #pragma cle end TAG_OKAY
#pragma clang attribute pop

    tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);
    if (!inited) {
      inited = 1;
      psocket = xdc_pub_socket();
      ssocket = xdc_sub_socket(t_tag); 
      sleep(1); /* zmq socket join delay */
    }

    xdc_blocking_recv(ssocket, &nxt, &t_tag); 
    // XXX: validate receive?

    tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);
    okay.x = 0;
    xdc_asyn_send(psocket, &okay, &o_tag);

    n_tag->mux = nxt.mux;
    n_tag->sec = nxt.sec;
    n_tag->typ = nxt.typ; 
}

void _hal_init(char *inuri, char *outuri)
{
  xdc_set_in(inuri);
  xdc_set_out(outuri);
  xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);
  xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);
  xdc_register(requesta_data_encode, requesta_data_decode, DATA_TYP_REQUESTA);
  xdc_register(responsea_data_encode, responsea_data_decode, DATA_TYP_RESPONSEA);
}

#define NXDRPC 2   
WRAP(nxtrpc)
WRAP(requesta)

int _slave_rpc_loop() {
  gaps_tag n_tag;        // for _handle_nxtrpc return value, other handlers ignore
  pthread_t tid[NXDRPC]; // one thread per cross-domain RPC handler
  _hal_init((char *)INURI, (char *)OUTURI);
  pthread_create(&tid[0], NULL, _wrapper_nxtrpc, &n_tag); 
  pthread_create(&tid[1], NULL, _wrapper_requesta, &n_tag);
  for (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL); 
  return 0;
}
