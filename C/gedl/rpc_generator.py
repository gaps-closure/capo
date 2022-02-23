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
  parser.add_argument('-s','--schema', required=False, type=str, help='override location of cle schema if required', default='/opt/closure/schemas/cle-schema.json')
  parser.add_argument('-t','--outuri', required=True, type=str, help='Output URI')
  parser.add_argument('-v','--verbose', required=False, action='store_false')
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
  def __init__(self, gedlfile, enclaveList, muxbase, secbase, typbase, schemafile):
    with open(gedlfile) as edl_file: self.gedl = json.load(edl_file)['gedl']
    self.xdcalls     = [c['func'] for x in self.gedl for c in x['calls']]
    self.specials    = ['nextrpc', 'okay']
    self.muxbase     = muxbase
    self.secbase     = secbase
    self.typbase     = typbase
    self.enclaveList = enclaveList
    # generate mux and sec assigmets per enclave pairs (e.g., orange, purple and purple, orange)
    cartesian        = [(i,j) for i in enclaveList for j in enclaveList if i != j]
    self.muxAssign   = {x: i for i,x in enumerate(cartesian)}
    self.secAssign   = {x: i for i,x in enumerate(cartesian)}
    self.masters     = []
    self.affected    = {}
    self.schemafile  = schemafile
    # Check for errors
    y = [x for x in self.gedl if x['caller'] not in enclaveList or x['callee'] not in enclaveList]
    if len(y) > 0: raise Exception('Enclaves referenced in GEDL not in provided enclave list: ' + ','.join(y))
    if len(self.xdcalls) != len(set(self.xdcalls)): raise Exception('Cross-domain function calls are not unique')
    # Use gedl to get list of affected XD functions (e.g get_a) per line number per app file (e.g example1.c)
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
  # Construct quad (caller, callee, func, other call info) list of calls (in and out) of an enclave
  def inCalls(self, e):  return [(x['caller'],x['callee'],c['func'],c) for x in self.gedl for c in x['calls'] if x['callee'] == e]
  def outCalls(self, e): return [(x['caller'],x['callee'],c['func'],c) for x in self.gedl for c in x['calls'] if x['caller'] == e]
  # NEXT/OKAY Call Flows to support RPC in enclave e
  def speCalls(self, e):
    def add_next_flows(x, y, direct_next, direct_okay):
      list.append([x,y,'nextrpc', direct_next])
      list.append([x,y,'okay',    direct_okay])
    list=[]
    for g in self.gedl:
      x,y = g['caller'], g['callee']
      if len(g['calls']) > 0 :
        if x == e : add_next_flows(x, y, True, False)  # Support Requests from e
        if y == e : add_next_flows(x, y, False, True)  # Support Requests to e
    return list
      
  ##############################################################################################################
  # Construct dictionary with per flow/function (caller, callee, func, direction) assignments
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

  # Print flows from and to enclave e (using const module) - Special flows will be redundantly printed
  def const_print(self, e):
    print ('All flows to and from enclave', e)
    for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e):
      print ('function =', f)
      for o in [True,False]:
        print ('Const func dict =', json.dumps(self.const(x,y,f,o), indent=2, default=str))
        for fs in self.specials:
          print ('Const spec dict =', json.dumps(self.const(x,y,fs,o), indent=2, default=str))

  # Print special NEXT/OKAY flows from and to enclave e (using const module)
  def const_print_spec(self):
    for g in self.gedl:
      x = g['caller']
      y = g['callee']
      num_f = len(g['calls'])
      print ('Number of calls from ' + x + ' to ' + y + ' = ' + str(num_f))
      if (num_f > 0):
        for fs in self.specials :
          for o in (True, False):
            print ('Const spec dict =', json.dumps(self.const(x,y,fs,o), indent=2, default=str))

  ##############################################################################################################
  # Generate dictioary with info needed for HAL cofiguration (via xdconf.ini json file)
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
    def boiler(f):    # ARQ mod: for each RPC functions (in and out)
      s  = '#ifndef _' + e.upper() + '_RPC_' + n
      s += '#define _' + e.upper() + '_RPC_' + n + n
      s += '#include "codec.h"' + n
      s += '#include <limits.h>' + n    # ARQ mod:
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
      # ARQ mod:
      s += ','.join([p['type'] + ' ' + p['name'] + ('[]' if 'sz' in p else '') for p in fd['params']])  # XXX: check array/pointer
      if wrap :
        if ','.join([p['type'] + ' ' + p['name'] + ('[]' if 'sz' in p else '') for p in fd['params']]) != "" :
          s += ', '
        s += 'int *error'
      s += ');' + n
      return s
    def trailer(): return n + '#endif /* _' + e.upper() + '_RPC_ */' + n

    
    for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e): s = boiler(f)   # ARQ mod: for all RPC functions (in and out)
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
  # Create Cross Domain RPC source program (string) for each enclave (e.g., purple_rpc.c)
  def genrpcC(self, e, ipc):
    # Get default ARQ parameters (num_tries, num_tries) from JSON CLE schema file
    def readfromjsonfile():
      f = open(self.schemafile,)
      data = json.load(f)
      f.close()
      return data['definitions']['cdfType']['properties']
    dict_lossndelay = readfromjsonfile()
    num_tries = dict_lossndelay['num_tries']['default']
    timeout   = dict_lossndelay['timeout']['default']
    n,t = '\n','    '
    def boiler():
      s  = '#include "' + e + '_rpc.h"' + n
      s += '#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)' + n
      s += '#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }' + n + n
      return s
    # HAL API (my_) functions to support a 0MQ Socket per RPC flow (non-legacy XDComms)
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
      # ARQ mod: recv function returns size
      s += 'int my_xdc_recv(void *socket, void *adu, gaps_tag *tag, codec_map *cmap) {' + n
      s += t + 'sdh_ha_v1 packet;' + n
      s += t + 'void *p = &packet;' + n
      s += t + 'int size = zmq_recv(socket, p, sizeof(sdh_ha_v1), 0);' + n
      s += t + 'size_t adu_len;' + n
      s += t + 'my_gaps_data_decode(p, size, adu, &adu_len, tag, cmap);' + n
      s += t + 'return size;' + n
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
      # ARQ mod:  subscribe with timeout
      s += 'void *my_xdc_sub_socket_non_blocking(gaps_tag tag, void *ctx, int timeout) {' + n
      s += t + 'int  err, len;' + n
      s += t + 'void    *socket;' + n
      s += t + 'gaps_tag tag4filter;' + n
      s += t + 'void    *filter;' + n
      s += t + 'socket = zmq_socket(ctx, ZMQ_SUB);' + n
      s += t + 'if (timeout>=0) {' + n
      s += t + t + 'err = zmq_setsockopt(socket, ZMQ_RCVTIMEO, &timeout, sizeof(timeout));' + n
      s += t + t + 'assert(err == 0);' + n
      s += t + '}' + n
      s += t + 'err = zmq_connect(socket, INURI);' + n
      s += t + 'if ((tag.mux) != 0) {' + n
      s += t + t + 'len = RX_FILTER_LEN;' + n
      s += t + t + 'my_tag_encode(&tag4filter, &tag);' + n
      s += t + t + 'filter = (void *) &tag4filter;' + n
      s += t + '} else {' + n
      s += t + t + 'len = 0;' + n
      s += t + t + 'filter = (void *) "";' + n
      s += t + '}' + n
      s += t + 'err = zmq_setsockopt(socket, ZMQ_SUBSCRIBE, filter, len);' + n
      s += t + 'assert(err == 0);' + n
      s += t + 'return socket;' + n
      s += '}' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n + n
      return s

    # Register XDC encode and decode functions (e.g. for get_a) with HAL API (legacy and non-legacy)
    def regdtyp(x,y,f,outgoing=True,pfx='',sfx='', special=False):
      type = 'request_' if outgoing==True else 'response_'
      if special: type=''
      l  = self.const(x,y,f,outgoing)
      return pfx + 'xdc_register(' + type + f.lower() + '_data_encode, ' + type + f.lower() + '_data_decode, ' + l['typdef'] + sfx + ');' + n
    def cc_reg_xdc(pfx='', sfx=''):
      s = ''
      for (x,y,fs,o) in self.speCalls(e): s += t + regdtyp(x,y,fs,o,pfx,sfx,True)
      for (x,y,f,fd) in self.inCalls(e) + self.outCalls(e) :
        for o in (True, False) : s += t + regdtyp(x,y,f,o,pfx,sfx)
      return s
    # Register non-legacy XDC encode and decode functions
    def cc_my_reg():
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'codec_map  mycmap[MY_DATA_TYP_MAX];' + n
      s += t + 'for (int i=0; i < MY_DATA_TYP_MAX; i++)  mycmap[i].valid=0;' + n
      s += cc_reg_xdc('my_', ', mycmap')
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s
    # Register legacy XDC encode and decode functions (and set URIs)
    def halinit(e):
      s  = 'void _hal_init(char *inuri, char *outuri) {' + n
      s += '#ifdef __LEGACY_XDCOMMS__' + n
      s += t + 'xdc_set_in(inuri);' + n
      s += t + 'xdc_set_out(outuri);' + n
      s += cc_reg_xdc()
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += '}' + n + n
      return s

    # Write snd (t_tag) and rcv (o_tag) tags from const dictionary
    def bi_tags(func, pfx=''):
      l  = self.const(x,y,func,True)
      s  = t + pfx + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      l  = self.const(x,y,func,False)
      s += t + pfx + 'tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      return s
    def cc_tags_write(func) :
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += bi_tags(func, 'my_')
      s += '#else' + n
      s += bi_tags(func)
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s;
      
    # RPC C code Variable definitions
    def cc_vars(counter_name, init_count_string) :
      s  = t + 'gaps_tag t_tag;' + n
      s += t + 'gaps_tag o_tag;' + n
      s += t + 'static int ' + counter_name + ' = ' + init_count_string + ';' + n
      s += t + 'static double last_processed_result;' + n
      s += t + 'static int last_processed_error = 0;' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'void *psocket;' + n
      s += t + 'void *ssocket;' + n
      s += '#else' + n
      s += t + 'static int inited = 0;' + n
      s += t + 'static void *psocket;' + n
      s += t + 'static void *ssocket;' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s;
      
    # Create Publish and Subscribe sockets (once per XD function ifndef __LEGACY_XDCOMMS__)
    # Requestor sets use_timeout=True to support ARQ. Responder sets use_timeout=False
    def cc_sockets_open(tag, use_timeout):
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'void * ctx = zmq_ctx_new();' + n
      s += t + 'psocket = my_xdc_pub_socket(ctx);' + n
      if (use_timeout==False) :
        s += t + 'ssocket = my_xdc_sub_socket(' + tag + ', ctx);' + n
      else:
        s += t + 'ssocket = my_xdc_sub_socket_non_blocking(' + tag + ', ctx, ' + str(timeout) + ');' + n
      s += t + 'sleep(1); /* zmq socket join delay */' + n
      s += '#else' + n
      s += t + 'if (!inited) {' + n
      s += t + t + 'inited = 1;' + n
      s += t + t + 'psocket = xdc_pub_socket();' + n
      if (use_timeout==False) :
        s += t + t + 'ssocket = xdc_sub_socket(' + tag + ');' + n
      else:
        s += t + t + 'ssocket = xdc_sub_socket_non_blocking(' + tag + ', ' + str(timeout) + ');' + n
      s += t + t + 'sleep(1); /* zmq socket join delay */' + n
      s += t + '}' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s
    # Close Sockets
    def cc_sockets_close():
      s  = t + 'zmq_close(psocket);' + n
      s += t + 'zmq_close(ssocket);' + n
      s += t + 'zmq_ctx_shutdown(ctx);' + n
      return s
      
    ##############################################################################################################
    # Send RPC Request and wait for RPC Responnse
    ##############################################################################################################
    # Create parameter list from fd['params'] list for calling an RPC function
    def cc_params_in_call():
      s=''
      def mparam(q): return q['name'] + ('[]' if 'sz' in q else '') # XXX: check array/pointer issues
      if ','.join([mparam(q) for q in fd['params']]) != "" :
        s = ',' + ','.join([mparam(q) for q in fd['params']])
      s += ')' + ';' + n
      return s
      
    # Create parameter list from fd['params'] list for RPC function definition variables
    def cc_params_in_func():
      def mparam(q): return q['type'] + ' ' + q['name'] + ('[]' if 'sz' in q else '') # XXX: check array/pointer issues
      s=''
      if ','.join([mparam(q) for q in fd['params']]) != "" :
        s = ',' + ','.join([mparam(q) for q in fd['params']])
      s += ')' + '{' + n
      return s

    # Define comms structures for a request and respose ('req_' + f and 'res' + f)
    def cc_datatype_req_res(tc=2) :
      l  = self.const(x,y,f,True)
      s  = t*tc + '#pragma cle begin ' + l['clelabl'] + n
      s += t*tc + 'request_' + f.lower() + '_datatype req_' + f + ';' + n
      s += t*tc + '#pragma cle end ' + l['clelabl'] + n
      l  = self.const(x,y,f,False)
      s += t*tc + '#pragma cle begin ' + l['clelabl'] + n
      s += t*tc + 'response_' + f.lower() + '_datatype res_' + f + ';' + n
      s += t*tc + '#pragma cle end ' + l['clelabl'] + n
      return s;

    # Define comms structures for a NEXT/OKAY
    def cc_datatype_next_okay(x, y, direct_next, direct_okay) :
      fs = 'nextrpc'
      l  = self.const(x,y,fs,direct_next)
      s  = t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + fs.lower() + '_datatype nxt;' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      fs = 'okay'
      l  = self.const(x,y,fs,direct_okay)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + fs.lower() + '_datatype okay;' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      return s;
      
    # Create packet reqIdto hold remote function variables in request struct (req_' + f)
    def cc_create_packet_func(pfx='', sfx=''):
      s = ''
      if len(fd['params']) == 0:
        s += t + t + 'req_' + f + '.dummy = 0;'  + n  # matches IDL convention on void
      else:
        for q in fd['params']:
          if 'sz' in q and 'dir' in q and q['dir'] in ['in','inout']:
            s += t + t + 'for(int i=0; i<' + str(q['sz']) + '; i++) req_' + f + '.' + q['name'] + '[i] = ' + q['name'] + '[i];' + n
          else:
            s += t + t + 'req_' + f + '.' + q['name'] + ' = ' + q['name'] + ';' + n
      s += t + t + 'req_' + f + '.trailer.seq = reqId;' + n
      s += t + t + pfx +'xdc_asyn_send(psocket, &req_' + f + ', t_tag' + sfx + ');' + n
      return s
    # Create sync packet in request struct ('req_' + f).  XXXXX Does a SYNC ever have params?????
    def cc_create_packet_sync(pfx='', sfx=''):
      s = ''
      if len(fd['params']) == 0:
        s += t + t + 'req_' + f + '.dummy = 0;'  + n  # matches IDL convention on void
      else:
        for q in fd['params']:
          if 'sz' in q and 'dir' in q and q['dir'] in ['in','inout']:
            s += t + t + 'for(int i=0; i<' + str(q['sz']) + '; i++) req_' + f + '.' + q['name'] + '[i] = ' + '0' + '[i];' + n   # DIFF: NO q['name']
          else:
            s += t + t + 'req_' + f + '.' + q['name'] + ' = ' + q['name'] + ';' + n
      s += t + t + 'req_' + f + '.trailer.seq = *req_counter;' + n   # DIFF: *req_counter replaces reqId
      s += t + t + pfx +'xdc_asyn_send(psocket, &req_' + f + ', t_tag' + sfx + ');' + n
      return s
      
    # Get response and resend request (continue) if xdc_recv timeout (status == -1)
    def cc_recv_response(req_id_string, pfx='', sfx='') :
      s = ''
      s += t + t + 'int status = ' + pfx + 'xdc_recv(ssocket, &res_' + f + ', o_tag' + sfx +');' + n
      s += t + t + 'int respId = res_' + f + '.trailer.seq >> 2 ;' + n
      s += t + t + 'int error = (res_' + f + '.trailer.seq >> 1)& 0x01 ;' + n
      s += t + t + 'fprintf(stderr, "REQ: ReqId=%d ResId=%d Reserr=%d status=%d tries=%d result=%f\\n", ' + req_id_string + ', respId, error, status, tries_remaining, res_' + f + '.ret)' + ';' + n
      s += t + t + 'if(status == -1){' + n
      s += t + t + t + 'tries_remaining--;' + n
      s += t + t + t + 'continue;' + n
      s += t + t + '}' + n
      return s
      
    def cc_recv_save_func() :
      s = ''
      s += t + t + 'if(respId < reqId){' + n
      s += t + t + t +'continue;' + n
      s += t + t + '}' + n
      s += t + t + 'if(error){' + n
      s += t + t + t + 'return 0;' + n
      s += t + t + '}' + n
      s += t + t + '*result = res_' + f + '.ret;' + n
      s += t + t + '#else' + n
      s += t + t + '*result = 0;' + n
      return s
      
    def cc_recv_save_sync() :
      s = ''
      s += t + t + '*req_counter = respId;' + n
      s += t + t + '#else' + n
      s += t + t + '*req_counter = 0;' + n    # XXX Currently hardcoded (else assume responder agrees to sent value
      return s

    # Done with request, so return success or failure
    def cc_recv_done(req_id_string) :
      s = ''
      s += t + t + 'return 1;' + n    # Success
      s += t + '}' + n
      s += t + 'fprintf(stderr, "REQ: GIVING UP on res_' + f + ' ReqId=%d (after ' + str(num_tries) + ' tries)\\n", ' + req_id_string + ');' + n
      s += t + 'return 0;' + n        # Fail
      s += '}' + n + n
      return s
      
    def cc_check_if_error(tc=1) :
      s  = t*tc + 'if(status == 0) {' + n
      s += t*tc + t + '*error = 1;' + n
      s += t*tc + t + 'return 0;' + n
      s += t*tc + '}' + n
      return s

    def cc_get_request(pfx='', sfx='') :
      s  = t + pfx + 'xdc_blocking_recv(ssocket, &req_' + f + ', &t_tag' + sfx + ');' + n
      #s += t + ('res_' + f + '.ret = ' if fd['return']['type'] != 'void' else '') + f + '(' + ','.join(['req_' + f + '.' + q['name'] for q in fd['params']]) + ');' + n    # ARQ mod:
      # XXX: marshaller needs to copy output arguments (including arrays) to res here !!
      s += t + 'int reqId = req_' + f + '.trailer.seq;' + n
      # error not used???
      s += t + 'int error = 0;' + n
      s += t + 'if(reqId > rep_counter){' + n
      s += t + t + 'error = 0;' + n
      s += t + t + 'rep_counter = reqId;' + n
      s += t + t + 'last_processed_result = ' + f + '(' + ','.join(['req_' + f + '.' + q['name'] for q in fd['params']]) + ');' + n
      s += t + t + 'last_processed_error = error;' + n
      s += t + '}' + n
      s += t + 'res_' + f + '.trailer.seq = rep_counter << 2 | last_processed_error << 1;' + n
      s += t + 'res_' + f + '.ret = last_processed_result;' + n
      s += t + '#ifndef __ONEWAY_RPC__' + n
      s += t + pfx + 'xdc_asyn_send(psocket, &res_' + f + ', &o_tag' + sfx + ');' + n
      s += t + '#endif /* __ONEWAY_RPC__ */' + n
      s += t + 'fprintf(stderr, "RES: ReqId=%d (Min=%d Max=%d) Return=%f ResId=%d err=%d,%d (seq=0x%x)\\n", reqId, INT_MIN, rep_counter, last_processed_result, rep_counter, error, last_processed_error, rep_counter << 2 | last_processed_error << 1)' + ';' + n
      return s



    # RPC SYNC Request (non-legacy) XXX maybe merge with RPC Request Call for functions?
    def masterpclossdelay(x,y,f,fd) :
      s = '#ifndef __LEGACY_XDCOMMS__' + n
      s += 'int my_rpc_' + f + '_sync_request_counter(int* req_counter, void* psocket, void* ssocket, gaps_tag* t_tag, gaps_tag* o_tag, void * ctx, codec_map *mycmap, '
      s +=  'request_' + f + '_datatype req_' + f + ', response_' + f + '_datatype res_' + f
      s += cc_params_in_func()

      s += t + 'int tries_remaining = ' + str(num_tries) + ';' + n
      s += t + 'while(tries_remaining != 0){' + n
      s += cc_datatype_req_res()
      s += cc_create_packet_sync('my_', ' , mycmap')
      s += t + t + '#ifndef __ONEWAY_RPC__' + n
      s += cc_recv_response('*req_counter', 'my_', ' , mycmap')
      s += cc_recv_save_sync()
      s += t + t + '#endif /* __ONEWAY_RPC__ */' + n
      s += cc_recv_done('*req_counter')
      
      
      # RPC Function Request (non-legacy)
      s += 'int my_rpc_' + f + '_remote_call(int reqId, double* result, void* psocket, void* ssocket, gaps_tag* t_tag, gaps_tag* o_tag, void * ctx, codec_map *mycmap, '
      s +=  'request_' + f + '_datatype req_' + f + ', response_' + f + '_datatype res_' + f
      s += cc_params_in_func()

      s += t + 'int tries_remaining = ' + str(num_tries) + ';' + n
      s += t + 'while(tries_remaining != 0){' + n
      s += cc_create_packet_func('my_', ' , mycmap')
      s += t + t + '#ifndef __ONEWAY_RPC__' + n
      s += cc_recv_response('reqId', 'my_', ' , mycmap')
      s += cc_recv_save_func()
      s += t + t + '#endif /* __ONEWAY_RPC__ */' + n
      s += cc_recv_done('reqId')
      s += '#else' + n
      
      # RPC SYNC Request (legacy)
      s += 'int _rpc_' + f + '_sync_request_counter(int* req_counter, void* psocket, void* ssocket, gaps_tag* t_tag, gaps_tag* o_tag'
      s += cc_params_in_func()
      s += t + 'int tries_remaining = ' + str(num_tries) + ';' + n
      s += t + 'while(tries_remaining != 0){' + n
      s += cc_datatype_req_res()
      s += cc_create_packet_sync()
      s += t + t + '#ifndef __ONEWAY_RPC__' + n
      s += cc_recv_response('*req_counter')
      s += cc_recv_save_sync()
      s += t + t + '#endif /* __ONEWAY_RPC__ */' + n
      s += cc_recv_done('*req_counter')
      
      # RPC Function Request (legacy)
      s += 'int _rpc_' + f + '_remote_call(int reqId, double* result, void* psocket, void* ssocket, gaps_tag* t_tag, gaps_tag* o_tag'
      s += cc_params_in_func()
      s += t + 'int tries_remaining = ' + str(num_tries) + ';' + n
      s += t + 'while(tries_remaining != 0){' + n
      s += cc_datatype_req_res()
      s += cc_create_packet_func()
      s += t + t + '#ifndef __ONEWAY_RPC__' + n
      s += cc_recv_response('reqId')
      s += cc_recv_save_func()
      s += t + t + '#endif /* __ONEWAY_RPC__ */' + n
      s += cc_recv_done('reqId')
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s

    # Common SYNC Request for a XD function (f) and process status - XXXX should sync have one-way
    def cc_sync(f, tag) :
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'int status = my_rpc_' + f + '_sync_request_counter(&req_counter, psocket, ssocket, &t_tag, &o_tag, ctx, mycmap,'
      s += 'req_' + f + ', res_' + f
      s += cc_params_in_call()
      s += cc_check_if_error()
      s += '#else' + n
      s += t + 'if (inited < 2) {' + n
      s += t + t + 'inited = 2;' + n
      s += t + t + 'int status = _rpc_' + f + '_sync_request_counter(&req_counter, psocket, ssocket, &t_tag, &o_tag'
      s += cc_params_in_call()
      s += cc_check_if_error(2)
      s += t + '}' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + 'req_counter++;' + n
      return s;
      
    # RPC nxtag Request (legacy and non-legacy) - XXX maybe merge with RPC Request Call for functions?)
    def notify_nxtag(): # XXX: hardcoded tags, should use self.const (which requires passing x and y)
      s  = 'void _notify_next_tag(gaps_tag* n_tag) {' + n
      s += cc_vars('req_counter', 'INT_MIN')
      s += cc_my_reg()
# Needs x and y     s += cc_datatype_next_okay(x, y, True, False)
      s += t + '#pragma cle begin TAG_NEXTRPC' + n
      s += t + 'nextrpc_datatype nxt;' + n
      s += t + '#pragma cle end TAG_NEXTRPC' + n
      s += t + '#pragma cle begin TAG_OKAY' + n
      s += t + 'okay_datatype okay;' + n
      s += t + '#pragma cle end TAG_OKAY' + n
      
# Needs x and y      s += cc_tags_write('nextrpc')
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'my_tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += '#else' + n
      s += t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'my_tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += '#else' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      
      s += cc_sockets_open('o_tag', True)
# xxxx      s += t + 'tag_cp(n_tag, nxt);'
      s += t + 'nxt.mux = n_tag->mux;' + n
      s += t + 'nxt.sec = n_tag->sec;' + n
      s += t + 'nxt.typ = n_tag->typ;' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'my_xdc_asyn_send(psocket, &nxt, &t_tag, mycmap);' + n
      s += t + 'my_xdc_blocking_recv(ssocket, &okay, &o_tag, mycmap);' + n
      s += cc_sockets_close()
      s += '#else' + n
      s += t + 'xdc_asyn_send(psocket, &nxt, &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &okay, &o_tag);' + n
      s += t + 'fprintf(stderr, "REQ: nxt tag=<%d, %d, %d>\\n", nxt.mux, nxt.sec, nxt.typ)' + ';' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + '// XXX: check that we got valid OK?' + n
      s += '}' + n + n
      return s

    # Common RPC exteral Request function: e.g., _rpc_get_a()
    def rpcwrapdef(x,y,f,fd,ipc):
      def mparam(q): return q['type'] + ' ' + q['name'] + ('[]' if 'sz' in q else '') # XXX: check array/pointer issues
      s = fd['return']['type'] + ' _rpc_' + f + '(' + ','.join([mparam(q) for q in fd['params']])
      if ','.join([mparam(q) for q in fd['params']]) != "" :
        s += ', '
      s += 'int *error) {' + n
      
      s += cc_vars('req_counter', 'INT_MIN')
      s += cc_my_reg()
      s += cc_datatype_req_res(1)
      s += cc_tags_write(f)
      # ARQ mod: Ignore IDL convention on void
      if len(fd['params']) != 0:
        #s += t + 'req_' + f + '.dummy = 0;'  + n  # matches IDL convention on void
      #else:
        for q in fd['params']:
          if 'sz' in q and 'dir' in q and q['dir'] in ['in','inout']: 
            s += t + 'for(int i=0; i<' + str(q['sz']) + '; i++) req_' + f + '.' + q['name'] + '[i] = ' + q['name'] + '[i];' + n
          else:
            s += t + 'req_' + f + '.' + q['name'] + ' = ' + q['name'] + ';' + n
      s += cc_sockets_open('o_tag', True)
      s += cc_sync(f, 'o_tag')
      if ipc == "Singlethreaded":
        s += t + '_notify_next_tag(&t_tag);' + n
        s += t + 'fprintf(stderr, "REQ: for Singlethreaded RES using nxt tag=<%d, %d, %d>\\n", t_tag.mux, t_tag.sec, t_tag.typ)' + ';' + n
      s += t + 'double result;' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      # ARQ mod:  Replace my_xdc_asyn_send and my_xdc_blocking_recv with my_rpc_+f+_remote_call in next 12 lines
      s += t + 'int status = my_rpc_' + f + '_remote_call(req_counter,  &result, psocket, ssocket, &t_tag, &o_tag, ctx, mycmap, '
      s += 'req_' + f + ', res_' + f
      s += cc_params_in_call()
      s += cc_sockets_close()
      s += '#else' + n
      s += t + 'int status = _rpc_' + f + '_remote_call(req_counter,  &result, psocket, ssocket, &t_tag, &o_tag'
      s += cc_params_in_call()
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += cc_check_if_error()
      # XXX: marshaller needs to copy output arguments (including arrays) from res here !!
      s += '#ifndef __ONEWAY_RPC__' + n
      s += t + 'return (result);' + n   # ARQ mod: Use result from above
      s += '#else' + n
      s += t + 'return 0;' + n
      s += '#endif /* __ONEWAY_RPC__ */' + n
      s += '}' + n + n
      return s

    ##############################################################################################################
    # Slave waits for RPC Request and sends an RPC Responnse (in handler functions)
    ##############################################################################################################
    def handlernextrpc(): #XXX: hardcoded tags
      s = 'void _handle_nextrpc(gaps_tag* n_tag) {' + n
      s += cc_vars('rep_counter', '0')
      s += cc_my_reg()
      
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
      s += cc_sockets_open('t_tag', False)
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      
      s += t + 'my_xdc_blocking_recv(ssocket, &nxt, &t_tag, mycmap);' + n
      s += t + 'my_tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += t + 'okay.x = 0;' + n
      s += t + 'my_xdc_asyn_send(psocket, &okay, &o_tag, mycmap);' + n
      s += cc_sockets_close()
      s += '#else' + n
      s += t + 'xdc_blocking_recv(ssocket, &nxt, &t_tag);' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += t + 'okay.x = 0;' + n
      s += t + 'fprintf(stderr, "RES: nxt tag=<%d, %d, %d>\\n", nxt.mux, nxt.sec, nxt.typ)' + ';' + n
      s += t + 'xdc_asyn_send(psocket, &okay, &o_tag);' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + 'n_tag->mux = nxt.mux;' + n
      s += t + 'n_tag->sec = nxt.sec;' + n
      s += t + 'n_tag->typ = nxt.typ;' + n
      s += '}' + n + n
      return s
    # XXXXX Where is tag parameter used?????
    def handlerdef(x,y,f,fd,ipc):
      s  = 'void _handle_request_' + f + '(gaps_tag* tag) {' + n
      s += cc_vars('rep_counter', '0')
      s += cc_my_reg()
      s += cc_datatype_req_res(1)
      s += cc_tags_write(f)
      s += cc_sockets_open('t_tag', False)
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += cc_get_request('my_', ', mycmap')
      s += cc_sockets_close()
      s += '#else' + n
      s += cc_get_request()
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += '}' + n + n
      return s
      
    ##############################################################################################################
    # RPC source code for master or slave enclaves (returned as string s)
    ##############################################################################################################
    # Create either: a) Multithreaded (thread per inCall) or b) Singlethreaded (listeer waiting for nextrpc)
    def slavedispatch(e,ipc):
      s = ''
      if ipc == "Multithreaded":
        calls = self.inCalls(e)
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
        s += t + 'fprintf(stderr, "RES: Threads = %d\\n", NXDRPC);' + n
        s += t + 'for (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL);' + n
        s += t + 'return 0;' + n
        s += '}' + n + n
      else:
        s += 'int _slave_rpc_loop() {' + n
        s += t + 'gaps_tag t_tag;' + n
        s += t + 'gaps_tag o_tag;' + n
        s += t + '_hal_init((char *)INURI, (char *)OUTURI);' + n + n
        s += t + 'fprintf(stderr, "RES: Threads = 0\\n");' + n

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
      
    def masterdispatch(e,ipc):
      return 'void _master_rpc_init() {' + n + t + '_hal_init((char*)INURI, (char *)OUTURI);' +n + '}' + n + n

    s = boiler() + xdclib() + halinit(e)
    # pass parameters, x, y, f=
    s += notify_nxtag() if e in self.masters else handlernextrpc()
    # ARQ mod: add masterpclossdelay in outcalls
    for (x,y,f,fd) in self.inCalls(e):
        s += handlerdef(x,y,f,fd,ipc)
    for (x,y,f,fd) in self.outCalls(e):
        s += masterpclossdelay(x,y,f,fd)
        s += rpcwrapdef(x,y,f,fd,ipc)
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
  # Add lines into APP programs (e.g. example1.c) + add prfix to XD (affected) functions (e.g., get_a to _rpc_get_a)
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
                  # ARQ mod: Pass variable into function to return error number (NB: not used yet)
                  err_var = 'error_num_' + func
                  newline1 = ' ' * (len(line) - len(line.lstrip())) + 'int ' + err_var + ';\n'
                  print('Add error variable', newline1)
                  newf.write(newline1)
                  line_end = '&' + err_var + ')'
                  if line.find('()') == -1 :
                    line = line.replace(')', ',' + line_end)
                  else :
                    line = line.replace(')', line_end)
                  print('Replacing ' + func +' with _rpc_' + func + ' on line ' + str(index) + ' in file ' + canonnew)
            newf.write(line)
          if e not in self.masters:
            print('Adding slave main to: ' + canonnew)
            newf.write('int main(int argc, char *argv[]) {\n  return _slave_rpc_loop();\n}')
    else:
      copyfile(idir + '/' + rel + '/' + fname, odir + '/' + rel + '/' + fname)

#####################################################################################################################################################
def main():
  args = argparser()
  gp   = GEDLProcessor(args.gedl,args.enclave_list,args.mux_base,args.sec_base,args.typ_base,args.schema)
  if len(args.enclave_list) != 2: raise Exception('Only supporting two enclaves for now')
  gp.findMaster(args.enclave_list,args.edir,args.mainprog)
  if len(gp.masters) != 1: raise Exception('Need one master, got:' + ' '.join(gp.masters))
  print('2022 Merged Version: Processing source tree from ' + args.edir + ' to ' + args.odir)
  gp.processSourceTree(args.mainprog,args.enclave_list,args.edir,args.odir)

  for e in args.enclave_list:
    print('Generating RPC Header for:', e)
    with open(args.odir + '/' + e + '/' + e + '_rpc.h', 'w') as rh: rh.write(gp.genrpcH(e, args.inuri, args.outuri, args.ipc))
    print('Generating RPC Code for:', e)
    with open(args.odir + '/' + e + '/' + e + '_rpc.c', 'w') as rc: rc.write(gp.genrpcC(e, args.ipc))
  print('Generating cross domain configuration')
  with open(args.odir + "/" + args.xdconf, "w") as xf: json.dump(gp.genXDConf(args.inuri, args.outuri), xf, indent=2)
#  gp.const_print(args.enclave_list[0])
  gp.const_print_spec()
  
if __name__ == '__main__':
  main()
