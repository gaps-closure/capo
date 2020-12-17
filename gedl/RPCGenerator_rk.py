#!/usr/bin/python3
import json
import sys
import copy
import os
import re
from argparse import ArgumentParser
from shutil import copyfile

#####################################################################################################################################################
def argparser():
  parser = ArgumentParser(description='CLOSURE RPC File and Wrapper Generator')
  parser.add_argument('-o','--odir', required=True, type=str, help='Output Directory')
  parser.add_argument('-g','--gedl', required=True, type=str, help='Input GEDL Filepath')
  parser.add_argument('-i','--ipc', required=True, type=str, help='IPC Type (Singlethreaded/Multithreaded)')
  parser.add_argument('-a','--hal', required=True, type=str, help='HAL Api Directory Path')
  parser.add_argument('-n','--inuri', required=True, type=str, help='Input URI')
  parser.add_argument('-t','--outuri', required=True, type=str, help='Output URI')
  parser.add_argument('-x','--xdconf', required=True, type=str, help='Hal Config Map Filename')
  parser.add_argument('-e','--edir', required=True, type=str, help='Input Directory')
  parser.add_argument('-E','--enclave_list', required=True, type=str, nargs='+', help='List of enclaves')
  parser.add_argument('-M','--mux_base', required=False, type=int, default=0, help='Application mux base index for tags')
  parser.add_argument('-S','--sec_base', required=False, type=int, default=0, help='Application sec base index for tags')
  parser.add_argument('-T','--typ_base', required=False, type=int, default=0, help='Application typ base index for tags')
  parser.add_argument('-m','--mainprog', required=True, type=str, help='Application program name, <mainprog>.c must exsit')
  return parser.parse_args()

def remove_prefix(t,pfx): return t[len(pfx):] if t.startswith(pfx) else t

def gotMain(fn): # XXX: will fail on #ifdef'd out main, consider using clang.cindex to determine if there is indeed a main function
  with open(fn,'r') as fp:
    for row in fp:
      if re.match(r'\s*int\s+main\s*\(',row): return True
  return False
  
#####################################################################################################################################################
class GEDLProcessor:
  def __init__(self, gedlfile, enclaveList, muxbase, secbase, typbase):
    with open(gedlfile) as edl_file: self.gedl = json.load(edl_file)['gedl']
    self.xdcalls     = [c['func'] for x in self.gedl for c in x['calls']]
    self.specials    = ['nextrpc', 'okay']
    self.muxbase     = muxbase
    self.secbase     = secbase
    self.typbase     = typbase
    self.enclaveList = enclaveList
    cartesian        = [(i,j) for i in enclaveList for j in enclaveList if i != j]
    self.muxAssign   = {x: i for i,x in enumerate(cartesian)}
    self.secAssign   = {x: i for i,x in enumerate(cartesian)}
    self.masters     = []
    self.affected    = {}
    y = [x for x in self.gedl if x['caller'] not in enclaveList or x['callee'] not in enclaveList]
    if len(y) > 0: raise Exception('Enclaves referenced in GEDL not in provided enclave list: ' + ','.join(y))
    if len(self.xdcalls) != len(set(self.xdcalls)): raise Exception('Cross-domain function calls are not unique')
    for x in self.gedl:
      for c in x['calls']:
        for f in c['occurs']:
          canon = os.path.abspath(f['file'])
          if not canon in self.affected: self.affected[canon] = {}
          for line in f['lines']:
            if not line in self.affected[canon]: self.affected[canon][line] = []
            self.affected[canon][line].append(c['func'])

  ##############################################################################################################
  def callees(self, e):  return [x['callee'] for x in self.gedl if x['caller'] == e]
  def callers(self, e):  return [x['caller'] for x in self.gedl if x['callee'] == e]
  def inCalls(self, e):  return [(x['caller'],x['callee'],c['func'],c) for x in self.gedl for c in x['calls'] if x['callee'] == e]
  def outCalls(self, e): return [(x['caller'],x['callee'],c['func'],c) for x in self.gedl for c in x['calls'] if x['caller'] == e]

  ##############################################################################################################
  def const(self, caller, callee, func, outgoing=True):
    if func in self.specials: dnm = func.upper() 
    else:                     dnm = 'REQUEST_'  + func.upper() if outgoing else 'RESPONSE_' + func.upper()
    y            = {}
    y['from']    = caller if outgoing else callee
    y['to']      = callee if outgoing else caller
    y['dnm']     = dnm
    y['muxdef']  = 'MUX_'      + dnm
    y['secdef']  = 'SEC_'      + dnm
    y['typdef']  = 'DATA_TYP_' + dnm
    y['clelabl'] = 'TAG_'      + dnm
    y['mux']     = (self.muxAssign[(caller,callee)] + 1) if outgoing else (self.muxAssign[(callee,caller)] + 1)
    y['sec']     = (self.secAssign[(caller,callee)] + 1) if outgoing else (self.secAssign[(callee,caller)] + 1)
    y['typ']     = self.specials.index(func) + 1 if func in self.specials else len(self.specials) + self.xdcalls.index(func) * 2 + (1 if outgoing else 2)
    return y

  ##############################################################################################################
  def genXDConf(self, inu, outu):
    def amap(caller,callee,func,o):
      y = self.const(caller,callee,func,o)
      return {'from':y['from'],'to':y['to'],'mux':y['mux']+self.muxbase,'sec':y['sec']+self.secbase,'typ':y['typ']+self.typbase,'name':y['dnm']}
    def getmaps(e): 
      m = []
      if e in self.masters: # XXX: revisit for multi-enclave
        for p in self.callees(e): m.extend([amap(e,p,'nextrpc',True), amap(e,p,'okay',False)])
      else:
        for p in self.masters:    m.extend([amap(p,e,'nextrpc',True), amap(p,e,'okay',False)])
      for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e): m.extend([amap(x,y,f,True), amap(x,y,f,False)])
      return m
    return dict(enclaves=[dict(enclave=e,inuri=inu+e,outuri=outu+e,halmaps=getmaps(e)) for e in self.enclaveList])

  ##############################################################################################################
  def genrpcH(self, e, inu, outu, ipc):
    n,t = '\n','    '
    def boiler(): 
      s  = '#ifndef _' + e.upper() + '_RPC_' + n
      s += '#define _' + e.upper() + '_RPC_' + n + n
      s += '#include "codec.h"' + n
      s += '#include <pthread.h>' + n if ipc != 'Singlethreaded' and e not in self.masters else n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += '#include <assert.h>'  + n
      s += '#include <zmq.h>'  + n
      s += '#else' + n
      s += '#include "xdcomms.h"' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n + n
      s += '#define INURI "' + inu + e + '"' + n
      s += '#define OUTURI "' + outu + e + '"' + n + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += '#define MY_IPC_ADDR_DEFAULT_IN  "ipc:///tmp/halpub1"' + n
      s += '#define MY_IPC_ADDR_DEFAULT_OUT "ipc:///tmp/halsub1"' + n + n
      s += '#define ADU_SIZE_MAX_C  2000' + n
      s += '#define MY_DATA_TYP_MAX 200' + n
      s += '#define RX_FILTER_LEN   12' + n + n
      s += '/* Closure tag structure */' + n
      s += 'typedef struct _tag {' + n
      s += t + 'uint32_t mux;      /* APP ID */' + n
      s += t + 'uint32_t sec;      /* Security tag */' + n
      s += t + 'uint32_t typ;      /* data type */' + n
      s += '} gaps_tag;' + n + n
      s += '/* CLOSURE packet */' + n
      s += 'typedef struct _sdh_ha_v1 {' + n
      s += t + 'gaps_tag tag;' + n
      s += t + 'uint32_t data_len;' + n
      s += t + 'uint8_t   data[ADU_SIZE_MAX_C];' + n
      s += '} sdh_ha_v1;' + n + n
      s += 'typedef void (*codec_func_ptr)(void *, void *, size_t *);' + n
      s += 'typedef struct _codec_map {' + n
      s += t + 'int valid;' + n
      s += t + 'codec_func_ptr encode;' + n
      s += t + 'codec_func_ptr decode;' + n
      s += '} codec_map;' + n 
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n + n
      s += '#define MUX_BASE ' + str(self.muxbase) + n + n
      s += '#define SEC_BASE ' + str(self.secbase) + n + n
      s += '#define TYP_BASE ' + str(self.typbase) + n + n
      if e in self.masters: s += 'extern void _master_rpc_init();' + n + n
      else:                 s += 'extern int _slave_rpc_loop();' + n + n
      return s
    def muxsec(l): return '#define ' + l['muxdef'] + ' MUX_BASE + ' + str(l['mux']) + n + '#define ' + l['secdef'] + ' SEC_BASE + ' + str(l['sec']) + n
    def tagcle(x,y,f,outgoing=True): 
      l  = self.const(x,y,f,outgoing)
      s  = '#pragma cle def ' + l['clelabl'] + ' {"level": "' + e + '", \\' + n
      s += t + '"cdf": [{"remotelevel": "' + l['to'] + '", "direction": "egress", \\' + n
      s += t + t + t + '"guarddirective": {"operation": "allow", "gapstag": [' + ','.join([str(l['mux']+self.muxbase),str(l['sec']+self.secbase),str(l['typ']+self.typbase)]) + ']}}]}' + n + n
      return s
    def specialstags(x,y):
      s  = muxsec(self.const(x,y,'nextrpc',True))
      s += muxsec(self.const(x,y,'okay',False)) + n
      return s
    def specialscle(x,y):
      s  = tagcle(x,y,'nextrpc',outgoing=True) 
      s += tagcle(x,y,'okay',outgoing=False) 
      return s
    def fundecl(fd, wrap=True): 
      s  = 'extern ' + fd['return']['type'] + ' ' + ('_rpc_' if wrap else '') + fd['func'] + '('
      s += ','.join([p['type'] + ' ' + p['name'] + ('[]' if 'sz' in p else '') for p in fd['params']]) + ');' + n  # XXX: check array/pointer
      return s
    def trailer(): return n + '#endif /* _' + e.upper() + '_RPC_ */' + n

    s = boiler()
    if len(self.enclaveList) == 2 and len(self.masters) == 1:   # XXX: multi-enclave scenario not handled, NEXTRPC will have different mux,sec per peer
      if e in self.masters:
        for p in self.callees(e): s +=  specialscle(e,p)
      else:
        for p in self.masters:    s +=  specialscle(p,e)
    for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e): s += tagcle(x,y,f,outgoing=True)    + tagcle(x,y,f,outgoing=False) 
    if len(self.enclaveList) == 2 and len(self.masters) == 1:   # XXX: multi-enclave scenario not handled, NEXTRPC will have different mux,sec per peer
      if e in self.masters:
        for p in self.callees(e): s +=  specialstags(e,p)
      else:
        for p in self.masters:    s +=  specialstags(p,e)
    for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e): s += muxsec(self.const(x,y,f,True)) + muxsec(self.const(x,y,f,False))
    s += n
    for (x,y,f,fd) in self.outCalls(e): s += fundecl(fd, wrap=True)
    for (x,y,f,fd) in self.inCalls(e):  s += fundecl(fd, wrap=False)
    s += trailer()
    return s

  ##############################################################################################################
  def genrpcC(self, e, ipc): 
    n,t = '\n','    '
    def boiler():
      s  = '#include "' + e + '_rpc.h"' + n
      s += '#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)' + n
      s += '#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }' + n + n
      return s
    def xdclib():
      s  = ''
      s += '#ifndef __LEGACY_XDCOMMS__' + n + n
      s += 'void my_type_check(uint32_t typ, codec_map *cmap) {' + n
      s += t + 'if ( (typ >= MY_DATA_TYP_MAX) || (cmap[typ].valid==0) ) {' + n
      s += t + t + 'exit (1);' + n
      s += t + '}' + n
      s += '}' + n + n
      s += 'void my_xdc_register(codec_func_ptr encode, codec_func_ptr decode, int typ, codec_map *cmap) {' + n
      s += t + 'cmap[typ].valid=1;' + n
      s += t + 'cmap[typ].encode=encode;' + n
      s += t + 'cmap[typ].decode=decode;' + n
      s += '}' + n + n
      s += '/* Serialize tag onto wire (TODO, Use DFDL schema) */' + n
      s += 'void my_tag_encode (gaps_tag *tag_out, gaps_tag *tag_in) {' + n
      s += t + 'tag_out->mux = htonl(tag_in->mux);' + n
      s += t + 'tag_out->sec = htonl(tag_in->sec);' + n
      s += t + 'tag_out->typ = htonl(tag_in->typ);' + n
      s += '}' + n + n
      s += '/* Convert tag to local host format (TODO, Use DFDL schema) */' + n
      s += 'void my_tag_decode (gaps_tag *tag_out, gaps_tag *tag_in) {' + n
      s += t + 'tag_out->mux = ntohl(tag_in->mux);' + n
      s += t + 'tag_out->sec = ntohl(tag_in->sec);' + n
      s += t + 'tag_out->typ = ntohl(tag_in->typ);' + n
      s += '}' + n + n
      s += '/* Convert tag to local host format (TODO, Use DFDL schema) */' + n
      s += 'void my_len_encode (uint32_t *out, size_t len) {' + n
      s += t + '*out = ntohl((uint32_t) len);' + n
      s += '}' + n + n
      s += '/* Convert tag to local host format (TODO, Use DFDL schema) */' + n
      s += 'void my_len_decode (size_t *out, uint32_t in) {' + n
      s += t + '*out = (uint32_t) htonl(in);' + n
      s += '}' + n + n
      s += 'void my_gaps_data_encode(sdh_ha_v1 *p, size_t *p_len, uint8_t *buff_in, size_t *len_out, gaps_tag *tag, codec_map *cmap) {' + n
      s += t + 'uint32_t typ = tag->typ;' + n
      s += t + 'my_type_check(typ, cmap);' + n
      s += t + 'cmap[typ].encode (p->data, buff_in, len_out);' + n
      s += t + 'my_tag_encode(&(p->tag), tag);' + n
      s += t + 'my_len_encode(&(p->data_len), *len_out);' + n
      s += t + '*p_len = (*len_out) + sizeof(p->tag) + sizeof(p->data_len);' + n
      s += '}' + n + n
      s += '/* Decode data from packet */' + n
      s += 'void my_gaps_data_decode(sdh_ha_v1 *p, size_t p_len, uint8_t *buff_out, size_t *len_out, gaps_tag *tag, codec_map *cmap) {' + n
      s += t + 'uint32_t typ = tag->typ;' + n
      s += t + 'my_type_check(typ, cmap);' + n
      s += t + 'my_tag_decode(tag, &(p->tag));' + n
      s += t + 'my_len_decode(len_out, p->data_len);' + n
      s += t + 'cmap[typ].decode (buff_out, p->data, &p_len);' + n
      s += t + '}' + n + n
      s += 'void my_xdc_asyn_send(void *socket, void *adu, gaps_tag *tag, codec_map *cmap) {' + n
      s += t + 'sdh_ha_v1    packet, *p=&packet;' + n
      s += t + 'size_t       packet_len;' + n
      s += t + 'size_t adu_len;         /* Size of ADU is calculated by encoder */' + n
      s += t + 'my_gaps_data_encode(p, &packet_len, adu, &adu_len, tag, cmap);' + n
      s += t + 'int bytes = zmq_send (socket, (void *) p, packet_len, 0);' + n
      s += t + 'if (bytes <= 0) fprintf(stderr, "send error %s %d ", zmq_strerror(errno), bytes);' + n
      s += '}' + n + n
      s += 'void my_xdc_blocking_recv(void *socket, void *adu, gaps_tag *tag, codec_map *cmap) {' + n
      s += t + 'sdh_ha_v1 packet;' + n
      s += t + 'void *p = &packet;' + n
      s += t + 'int size = zmq_recv(socket, p, sizeof(sdh_ha_v1), 0);' + n
      s += t + 'size_t adu_len;' + n
      s += t + 'my_gaps_data_decode(p, size, adu, &adu_len, tag, cmap);' + n
      s += '}' + n + n
      s += 'void *my_xdc_pub_socket(void *ctx) {' + n
      s += t + 'int err;' + n
      s += t + 'void *socket;' + n
      s += t + 'socket = zmq_socket(ctx, ZMQ_PUB);' + n
      s += t + 'err = zmq_connect(socket, OUTURI);' + n
      s += t + 'return socket;' + n
      s += '}' + n + n
      s += 'void *my_xdc_sub_socket(gaps_tag tag, void *ctx) {' + n
      s += t + 'int err;' + n
      s += t + 'gaps_tag tag4filter;' + n
      s += t + 'void *socket;' + n
      s += t + 'socket = zmq_socket(ctx, ZMQ_SUB);' + n
      s += t + 'err = zmq_connect(socket, INURI);' + n
      s += t + 'my_tag_encode(&tag4filter, &tag);' + n
      s += t + 'err = zmq_setsockopt(socket, ZMQ_SUBSCRIBE, (void *) &tag4filter, RX_FILTER_LEN);' + n
      s += t + 'assert(err == 0);' + n
      s += t + 'return socket;' + n
      s += '}' + n + n
      s += 'void my_tag_write (gaps_tag *tag, uint32_t mux, uint32_t sec, uint32_t typ) {' + n
      s += t + 'tag->mux = mux;' + n
      s += t + 'tag->sec = sec;' + n
      s += t + 'tag->typ = typ;' + n
      s += '}' + n + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n + n
      return s
    def regdtyp(x,y,f,outgoing=True,pfx='',sfx=''): 
      l  = self.const(x,y,f,outgoing)
      if outgoing:
        return pfx + 'xdc_register(request_' + f.lower() + "_data_encode, request_" + f.lower() + '_data_decode, ' + l['typdef'] + sfx + ');' + n
      else:
        return pfx + 'xdc_register(response_' + f .lower()+ "_data_encode, response_" + f.lower() + '_data_decode, ' + l['typdef'] + sfx + ');' + n
    def myregdtyp(x,y,f,outgoing=True,pfx='my_',sfx=', mycmap'): 
      return regdtyp(x,y,f,outgoing,pfx,sfx)
    def halinit(e):    # XXX: hardcoded tags, should use self.const
      s  = 'void _hal_init(char *inuri, char *outuri) {' + n 
      s += '#ifdef __LEGACY_XDCOMMS__' + n 
      s += t + 'xdc_set_in(inuri);' + n 
      s += t + 'xdc_set_out(outuri);' + n
      s += t + 'xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);' + n  
      s += t + 'xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);' + n           
      for (x,y,f,fd) in self.inCalls(e) + self.outCalls(e):
        s += t + regdtyp(x,y,f,True)
        s += t + regdtyp(x,y,f,False)
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n 
      s += '}' + n + n
      return s
    def BLOCK1():
      s  = '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'void *psocket;' + n
      s += t + 'void *ssocket;' + n
      s += t + 'gaps_tag t_tag;' + n
      s += t + 'gaps_tag o_tag;' + n
      s += t + 'codec_map  mycmap[MY_DATA_TYP_MAX];' + n
      s += t + 'for (int i=0; i < MY_DATA_TYP_MAX; i++)  mycmap[i].valid=0;' + n
      s += t + 'my_xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC, mycmap);' + n  
      s += t + 'my_xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY, mycmap);' + n           
      for (x,y,f,fd) in self.inCalls(e) + self.outCalls(e):
        s += t + myregdtyp(x,y,f,True)
        s += t + myregdtyp(x,y,f,False)
      s += '#else' + n
      s += t + 'static int inited = 0;' + n
      s += t + 'static void *psocket;' + n
      s += t + 'static void *ssocket;' + n
      s += t + 'gaps_tag t_tag;' + n
      s += t + 'gaps_tag o_tag;' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s;
    def BLOCK2(tag):
      s  = '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'void * ctx = zmq_ctx_new();' + n
      s += t + 'psocket = my_xdc_pub_socket(ctx);' + n
      s += t + 'ssocket = my_xdc_sub_socket(' + tag + ', ctx);' + n
      s += t + 'sleep(1); /* zmq socket join delay */' + n
      s += '#else' + n
      s += t + 'if (!inited) {' + n
      s += t + t + 'inited = 1;' + n
      s += t + t + 'psocket = xdc_pub_socket();' + n
      s += t + t + 'ssocket = xdc_sub_socket(' + tag + ');' + n
      s += t + t + 'sleep(1); /* zmq socket join delay */' + n
      s += t + '}' + n 
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s;
    def notify_nxtag(): # XXX: hardcoded tags, should use self.const
      s  = 'void _notify_next_tag(gaps_tag* n_tag) {' + n
      s += BLOCK1()
      s += t + '#pragma cle begin TAG_NEXTRPC' + n                                              
      s += t + 'nextrpc_datatype nxt;' + n
      s += t + '#pragma cle end TAG_NEXTRPC' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += '#else' + n
      s += t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + '#pragma cle begin TAG_OKAY' + n
      s += t + 'okay_datatype okay;' + n
      s += t + '#pragma cle end TAG_OKAY' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += '#else' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += BLOCK2('o_tag')
      s += t + 'nxt.mux = n_tag->mux;' + n
      s += t + 'nxt.sec = n_tag->sec;' + n
      s += t + 'nxt.typ = n_tag->typ;' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_xdc_asyn_send(psocket, &nxt, &t_tag, mycmap);' + n
      s += t + 'my_xdc_blocking_recv(ssocket, &okay, &o_tag, mycmap);' + n
      s += t + 'zmq_close(psocket);' + n
      s += t + 'zmq_close(ssocket);' + n
      s += t + 'zmq_ctx_shutdown(ctx);' + n
      s += '#else' + n
      s += t + 'xdc_asyn_send(psocket, &nxt, &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &okay, &o_tag);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + '// XXX: check that we got valid OK?' + n
      s += '}' + n + n
      return s
    def rpcwrapdef(x,y,f,fd,ipc):
      def mparam(q): return q['type'] + ' ' + q['name'] + ('[]' if 'sz' in q else '') # XXX: check array/pointer issues
      s = fd['return']['type'] + ' _rpc_' + f + '(' + ','.join([mparam(q) for q in fd['params']]) +') {' + n
      s += BLOCK1()
      l  = self.const(x,y,f,True)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'request_' + f.lower() + '_datatype req_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#else' + n
      s += t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      l  = self.const(x,y,f,False)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'response_' + f.lower() + '_datatype res_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#else' + n
      s += t + 'tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      if len(fd['params']) == 0:
        s += t + 'req_' + f + '.dummy = 0;'  + n  # matches IDL convention on void 
      else:
        for q in fd['params']:
          if 'sz' in q and 'dir' in q and q['dir'] in ['in','inout']: 
            s += t + 'for(int i=0; i<' + str(q['sz']) + '; i++) req_' + f + '.' + q['name'] + '[i] = ' + q['name'] + '[i];' + n
          else:
            s += t + 'req_' + f + '.' + q['name'] + ' = ' + q['name'] + ';' + n
      s += BLOCK2('o_tag')
      if ipc == "Singlethreaded": s += t + '_notify_next_tag(&t_tag);' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_xdc_asyn_send(psocket, &req_' + f + ', &t_tag, mycmap);' + n
      s += t + 'my_xdc_blocking_recv(ssocket, &res_' + f + ', &o_tag, mycmap);' + n
      s += t + 'zmq_close(psocket);' + n
      s += t + 'zmq_close(ssocket);' + n
      s += t + 'zmq_ctx_shutdown(ctx);' + n
      s += '#else' + n
      s += t + 'xdc_asyn_send(psocket, &req_' + f + ', &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &res_' + f + ', &o_tag);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      # XXX: marshaller needs to copy output arguments (including arrays) from res here !!
      s += t + 'return (res_' + f + '.ret);' + n
      s += '}' + n + n
      return s
    def handlernextrpc(): #XXX: hardcoded tags
      s = 'void _handle_nextrpc(gaps_tag* n_tag) {' + n
      s += BLOCK1()
      s += t + '#pragma cle begin TAG_NEXTRPC' + n
      s += t + 'nextrpc_datatype nxt;' + n
      s += t + '#pragma cle end TAG_NEXTRPC' + n
      s += t + '#pragma cle begin TAG_OKAY' + n
      s += t + 'okay_datatype okay;' + n
      s += t + '#pragma cle end TAG_OKAY' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += '#else' + n
      s += t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += BLOCK2('t_tag')
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_xdc_blocking_recv(ssocket, &nxt, &t_tag, mycmap);' + n
      s += t + 'my_tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += t + 'okay.x = 0;' + n
      s += t + 'my_xdc_asyn_send(psocket, &okay, &o_tag, mycmap);' + n
      s += t + 'zmq_close(psocket);' + n
      s += t + 'zmq_close(ssocket);' + n
      s += t + 'zmq_ctx_shutdown(ctx);' + n
      s += '#else' + n
      s += t + 'xdc_blocking_recv(ssocket, &nxt, &t_tag);' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += t + 'okay.x = 0;' + n
      s += t + 'xdc_asyn_send(psocket, &okay, &o_tag);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + 'n_tag->mux = nxt.mux;' + n
      s += t + 'n_tag->sec = nxt.sec;' + n
      s += t + 'n_tag->typ = nxt.typ;' + n
      s += '}' + n + n
      return s
    def handlerdef(x,y,f,fd,ipc):
      s  = 'void _handle_request_' + f + '(gaps_tag* tag) {' + n
      s += BLOCK1()
      l  = self.const(x,y,f,True)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'request_' + f.lower() + '_datatype req_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#else' + n
      s += t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      l  = self.const(x,y,f,False)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'response_' + f.lower() + '_datatype res_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#else' + n
      s += t + 'tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += BLOCK2('t_tag')
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_xdc_blocking_recv(ssocket, &req_' + f + ', &t_tag, mycmap);' + n
      s += '#else' + n
      s += t + 'xdc_blocking_recv(ssocket, &req_' + f + ', &t_tag);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + ('res_' + f + '.ret = ' if fd['return']['type'] != 'void' else '') + f + '(' + ','.join(['req_' + f + '.' + q['name'] for q in fd['params']]) + ');' + n
      # XXX: marshaller needs to copy output arguments (including arrays) to res here !!
      s += '#ifndef __LEGACY_XDCOMMS__' + n 
      s += t + 'my_xdc_asyn_send(psocket, &res_' + f + ', &o_tag, mycmap);' + n
      s += t + 'zmq_close(psocket);' + n
      s += t + 'zmq_close(ssocket);' + n
      s += t + 'zmq_ctx_shutdown(ctx);' + n
      s += '#else' + n
      s += t + 'xdc_asyn_send(psocket, &res_' + f + ', &o_tag);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += '}' + n + n
      return s
    def masterdispatch(e,ipc):
      return 'void _master_rpc_init() {' + n + t + '_hal_init((char*)INURI, (char *)OUTURI);' +n + '}' + n + n
    def slavedispatch(e,ipc):
      s = ''
      if ipc == "Multithreaded":
        calls = self.inCalls(e);
        s += '#define NXDRPC ' + str(len(calls) + 1) + n
        s += 'WRAP(nextrpc)' + n
        for (x,y,f,fd) in calls: s += 'WRAP(request_' + f + ')' + n
        s += n
        s += 'int _slave_rpc_loop() {' + n
        s += t + 'gaps_tag n_tag;' + n
        s += t + 'pthread_t tid[NXDRPC];'  + n
        s += t + '_hal_init((char *)INURI, (char *)OUTURI);' + n
        tidIndex = 0
        s += t + 'pthread_create(&tid[' + str(tidIndex) + '], NULL, _wrapper_nextrpc, &n_tag);' + n
        tidIndex += 1
        for (x,y,f,fd) in self.inCalls(e):  
          s += t + 'pthread_create(&tid[' + str(tidIndex) + '], NULL, _wrapper_request_' + f + ', &n_tag);' + n
          tidIndex += 1
        s += t + 'for (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL);' + n
        s += t + 'return 0;' + n
        s += '}' + n + n
      else: 
        s += 'int _slave_rpc_loop() {' + n
        s += t + 'gaps_tag t_tag;' + n
        s += t + 'gaps_tag o_tag;' + n
        s += t + '_hal_init((char *)INURI, (char *)OUTURI);' + n + n
        s += t + 'while (1) {' + n
        s += t + t + '_handle_nextrpc(&o_tag);' + n
        s += '#ifndef __LEGACY_XDCOMMS__' + n 
        s += t + t + 'my_tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n    # XXX: hardcoded labels
        s += '#else' + n
        s += t + t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n    # XXX: hardcoded labels
        s += '#endif /* __LEGACY_XDCOMMS__ */' + n
        s += t + t + 'if(TAG_MATCH(o_tag, t_tag)) { continue; }' + n
        for (x,y,f,fd) in self.inCalls(e):  
          l  = self.const(x,y,f,False)
          s += '#ifndef __LEGACY_XDCOMMS__' + n 
          s += t + t + 'my_tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
          s += '#else' + n
          s += t + t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
          s += '#endif /* __LEGACY_XDCOMMS__ */' + n
          s += t + t + 'if (TAG_MATCH(o_tag, t_tag)) {' + n
          s += t + t + t + '_handle_request_'+ f + '(NULL);' + n
          s += t + t + t + '}' + n
          s += t + t + 'continue;' + n
          s += t + '}' + n
          s += '}' + n + n
      return s

    s = boiler() + xdclib() + halinit(e)
    s += notify_nxtag() if e in self.masters else handlernextrpc()
    for (x,y,f,fd) in self.inCalls(e):  s += handlerdef(x,y,f,fd,ipc)
    for (x,y,f,fd) in self.outCalls(e): s += rpcwrapdef(x,y,f,fd,ipc)
    s += masterdispatch(e, ipc) if e in self.masters else slavedispatch(e, ipc)
    return s

  ##############################################################################################################
  def findMaster(self,enclaves,idirp,prog): 
    idir   = idirp.rstrip('/')
    for e in enclaves:
      fn = idir + '/' + e + '/' + prog + '.c'
      if gotMain(fn): self.masters.append(e)

  ##############################################################################################################
  def processSourceTree(self,prog,enclaves,idirp,odirp):
    idir   = idirp.rstrip('/')
    odir   = odirp.rstrip('/')
    os.makedirs(odir, mode=0o755, exist_ok=True)  
    for e in enclaves: 
      os.makedirs(odir + '/' + e, mode=0o755, exist_ok=True)  
      for root, dirs, files in os.walk(idir + '/' + e):
        rel = remove_prefix(root,idir).lstrip('/')
        for name in dirs:
          newd = os.path.join(odir, rel, name)
          os.makedirs(newd, mode=0o755, exist_ok=True)  
        for fname in files: self.processFile(prog,e,idir,odir,rel,fname)

  ##############################################################################################################
  def processFile(self, prog, e, idir, odir, rel, fname): # XXX: ought to use a C Parser, not regex
    canonold  = os.path.abspath(idir + '/' + rel + '/' + fname)
    canonmain = os.path.abspath(idir + '/' + e   + '/' + prog + '.c')
    canonnew  = os.path.abspath(odir + '/' + rel + '/' + fname)
    if canonold == canonmain or canonold in self.affected:
      with open(canonold, 'r') as oldf:
        with open(canonnew, 'w') as newf:
          newf.write('#include "' + e + '_rpc.h"' + '\n')
          oldfLines = list(oldf)
          for index, line in enumerate(oldfLines):
            if "int main(" in line:
              print('Adding rpc init to master main in: ' + canonnew)
              newf.write(line)
              newf.write("  _master_rpc_init();\n")
              continue
            if canonold in self.affected:
              if index+1 in self.affected[canonold]:
                for func in self.affected[canonold][index+1]:
                  if line.find(func) == -1: raise Exception(func + ' not found in ' + canonold + ' at line ' + str(index) + ':' + line)
                  line = line.replace(func, '_rpc_' + func)
                  print('Replacing ' + func +' with _rpc_' + func + ' on line ' + str(index) + ' in file ' + canonnew)
            newf.write(line)
          if e not in self.masters:
            print('Adding slave main to: ' + canonnew)
            newf.write('int main(int argc, char *argv[]) {\n  return _slave_rpc_loop();\n}')
    else:
      copyfile(idir + '/' + rel + '/' + fname, odir + '/' + rel + '/' + fname)

#####################################################################################################################################################
if __name__ == '__main__':
  args = argparser()
  gp   = GEDLProcessor(args.gedl,args.enclave_list,args.mux_base,args.sec_base,args.typ_base)
  if len(args.enclave_list) != 2: raise Exception('Only supporting two enclaves for now')
  gp.findMaster(args.enclave_list,args.edir,args.mainprog)
  if len(gp.masters) != 1: raise Exception('Need one master, got:' + ' '.join(gp.masters))
  print('Processing source tree from ' + args.edir + ' to ' + args.odir)
  gp.processSourceTree(args.mainprog,args.enclave_list,args.edir,args.odir)
  for e in args.enclave_list:
    print('Generating RPC Header for:', e)
    with open(args.odir + '/' + e + '/' + e + '_rpc.h', 'w') as rh: rh.write(gp.genrpcH(e, args.inuri, args.outuri, args.ipc))
    print('Generating RPC Code for:', e)
    with open(args.odir + '/' + e + '/' + e + '_rpc.c', 'w') as rc: rc.write(gp.genrpcC(e, args.ipc))
  print('Generating cross domain configuration')
  with open(args.odir + "/" + args.xdconf, "w") as xf: json.dump(gp.genXDConf(args.inuri, args.outuri), xf, indent=2)

