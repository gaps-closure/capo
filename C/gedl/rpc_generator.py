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
  parser.add_argument('-a','--hal',      required=True,  type=str, help='HAL Api Directory Path')
  parser.add_argument('-e','--edir',     required=True,  type=str, help='Input Directory')
  parser.add_argument('-c','--cle',      required=False, type=str, help='Input Filepath for CLE user annotations', default='/workspaces/build/example1.all.clemap.json')   # XXX Change to path of combined CLE map: jsons/?
  parser.add_argument('-g','--gedl',     required=True,  type=str, help='Input GEDL Filepath')
  parser.add_argument('-i','--ipc',      required=True,  type=str, help='IPC Type (Singlethreaded/Multithreaded)')
  parser.add_argument('-m','--mainprog', required=True,  type=str, help='Application program name, <mainprog>.c must exsit')
  parser.add_argument('-n','--inuri',    required=True,  type=str, help='Input URI')
  parser.add_argument('-o','--odir',     required=True,  type=str, help='Output Directory')
  parser.add_argument('-s','--schema',   required=False, type=str, help='override location of cle schema if required', default='/opt/closure/schemas/cle-schema.json')
  parser.add_argument('-t','--outuri',   required=True,  type=str, help='Output URI')
  parser.add_argument('-v','--verbose',  required=False, action='store_true')
  parser.add_argument('-x','--xdconf',   required=True,  type=str, help='Hal Config Map Filename')
  parser.add_argument('-E','--enclave_list', required=True,  type=str, nargs='+', help='List of enclaves')
  parser.add_argument('-M','--mux_base', required=False, type=int, default=0, help='Application mux base index for tags')
  parser.add_argument('-S','--sec_base', required=False, type=int, default=0, help='Application sec base index for tags')
  parser.add_argument('-T','--typ_base', required=False, type=int, default=0, help='Application typ base index for tags')
  return parser.parse_args()

def remove_prefix(t,pfx): return t[len(pfx):] if t.startswith(pfx) else t
def sFunc(caller, callee): return caller + '_' + callee
def sFuncg(gedl): return sFunc(gedl['caller'],gedl['callee'])
def gotMain(fn): # XXX: will fail on #ifdef'd out main, consider using clang.cindex to determine if there is indeed a main function
  with open(fn,'r') as fp:
    for row in fp:
      if re.match(r'\s*int\s+main\s*\(',row): return True
  return False

#####################################################################################################################################################
class GEDLProcessor:
  def __init__(self, gedlfile, enclaveList, muxbase, secbase, typbase, schemafile, clefile):
    with open(gedlfile) as edl_file: self.gedl = json.load(edl_file)['gedl']
    self.xdcalls     = [c['func'] for x in self.gedl for c in x['calls']]   # RPC call instances
    self.spcalls     = [sFuncg(x) for x in self.gedl]                       # special call instances
#    print ('xdcalls=', self.xdcalls, 'spcalls=', self.spcalls)
    self.sptypes     = ['nextrpc', 'okay']                                  # Special call types (outbound, inbound)
    self.muxbase     = muxbase                                              # CLOSURE Tag index offsets
    self.secbase     = secbase
    self.typbase     = typbase
    self.enclaveList = enclaveList
    self.clefile     = clefile                                             # DEPRICATED Flag if requestor has two subfunctions
    # Auto-generate mux and sec assigmets per enclave pairs (e.g., orange, purple and purple, orange)
    cartesian        = [(i,j) for i in enclaveList for j in enclaveList if i != j]
    self.muxAssign   = {x: i for i,x in enumerate(cartesian)}
    self.secAssign   = {x: i for i,x in enumerate(cartesian)}
    self.masters     = []
    self.affected    = {}
    # ARQ parameters (default and user defied) from JSON files
    self.schemafile  = schemafile
    with open(clefile)    as j_file: self.j_dict     = json.load(j_file)
    with open(schemafile) as s_file: dict_lossndelay = json.load(s_file)['definitions']['cdfType']['properties']
    self.default_param = {}
    self.param_list  = ['num_tries', 'timeout']
    for p in self.param_list: self.default_param[p] = dict_lossndelay[p]['default']
    # Check for errors
    y = [x for x in self.gedl if x['caller'] not in enclaveList or x['callee'] not in enclaveList]
    if len(y) > 0: raise Exception('Enclaves referenced in GEDL not in provided enclave list: ' + ','.join(y))
    if len(self.xdcalls) != len(set(self.xdcalls)): raise Exception('Cross-domain function calls are not unique')
    # Use gedl to get list of affected XD functions (e.g get_a) with app file (e.g example1.c) line numbers
    for x in self.gedl:
      for c in x['calls']:
        for f in c['occurs']:
          canon = os.path.abspath(f['file'])
          if not canon in self.affected: self.affected[canon] = {}
          for line in f['lines']:
            if not line in self.affected[canon]: self.affected[canon][line] = []
            self.affected[canon][line].append(c['func'])

  ##############################################################################################################
  # A) Call (caller, callee, func, direction) information
  ##############################################################################################################
  # List of calls (in and out) of an enclave [caller, callee, func type, other call info]
  def callees(self, e):   return [x['callee']                                       for x in self.gedl if x['caller'] == e]
  def callers(self, e):   return [x['caller']                                       for x in self.gedl if x['callee'] == e]
  def inCalls(self, e):   return [(x['caller'],x['callee'],c['func'],c)             for x in self.gedl for c in x['calls'] if x['callee'] == e]
  def outCalls(self, e):  return [(x['caller'],x['callee'],c['func'],c)             for x in self.gedl for c in x['calls'] if x['caller'] == e]
  def sInCalls (self, e): return [(x['caller'],x['callee'],sFuncg(x),x['calls'][0]) for x in self.gedl if x['callee'] == e]
  def sOutCalls(self, e): return [(x['caller'],x['callee'],sFuncg(x),x['calls'][0]) for x in self.gedl if x['caller'] == e]
  def allCalls(self, e):  return self.sOutCalls(e) + self.sInCalls(e) + self.outCalls(e) + self.inCalls(e)
  
  # Get Call ARQ parameters (e.g., num_tries) from JSON dictionaries: CLE user annotations or CLE schema
  def get_param(self, caller, callee, func, param):
    for a in self.j_dict:
      if 'XDLINKAGE_' + func.upper() in a['cle-label']:  # func matches user label?
        if callee == a['cle-json']['level']:  # Callee matches RPC responder (server)?
          for d in a['cle-json']['cdf']:      # Loop all cdf dictionaries in cdf list
            if caller == d['remotelevel']:    # Caller matches RPC requestor (client)?
              if param in d: return d[param]  # Get user specified param (if specified)
    return self.default_param[param]          # Else use default (if user does not specify)
    
  # Costruct dictioary with a call's parameters
  def const(self, caller, callee, func, outgoing=True):
    if func in self.spcalls:
      dni =  self.sptypes[0] + '_' + func if outgoing else  self.sptypes[1] + '_' + func
      dnm = (self.sptypes[0]).upper()     if outgoing else (self.sptypes[1]).upper()
    else:
      dni = 'request_' + func if outgoing else 'response_' + func
      dnm = dni.upper()
    y            = {}
    y['from']    = caller if outgoing else callee
    y['to']      = callee if outgoing else caller
    y['dni']     = dni
    y['dnm']     = dnm
    y['muxdef']  = 'MUX_'       + dnm
    y['secdef']  = 'SEC_'       + dnm
    y['typdef']  = 'DATA_TYP_'  + dnm
    y['clelabl'] = 'TAG_'       + dnm
    y['mux']     = (self.muxAssign[(caller,callee)] + 1) if outgoing else (self.muxAssign[(callee,caller)] + 1)
    y['sec']     = (self.secAssign[(caller,callee)] + 1) if outgoing else (self.secAssign[(callee,caller)] + 1)
    y['typ']     = self.spcalls.index(func) * 2 + (1 if outgoing else 2) if func in self.spcalls else len(self.spcalls) * 2 + self.xdcalls.index(func) * 2 + (1 if outgoing else 2)
    return y
    
  # Debug Print of Call parameters for enclave 'e'
  def constPrint(self, e):
    for (x,y,f,fd) in self.allCalls(e):
      print ('Call to and from enclave', e, 'for', f, end=': ')
      for p in self.param_list:  print (p + '=' + str(self.get_param(x,y,f,p)), end=' ')
      print('')
      for o in [True,False]: print (json.dumps(self.const(x,y,f,o), indent=2, default=str))

  ##############################################################################################################
  # B) Generate HAL cofiguration dictionary (later put into xdconf.ini json file)
  ##############################################################################################################
  def genXDConf(self, inu, outu):
    def amap(caller,callee,func,o):
      y = self.const(caller,callee,func,o)
      return {'from':y['from'],'to':y['to'],'mux':y['mux']+self.muxbase,'sec':y['sec']+self.secbase,'typ':y['typ']+self.typbase,'name':y['dni']}
    def getmaps(e): 
      m = []
      for (x,y,f,fd) in self.allCalls(e):
        for o in [True,False]:
          m.extend([amap(x,y,f,o)])
      return m
    return dict(enclaves=[dict(enclave=e,inuri=inu+e,outuri=outu+e,halmaps=getmaps(e)) for e in self.enclaveList])

  ##############################################################################################################
  # C) Generate header file for each enclave (e.g., purple_rpc.h)
  ##############################################################################################################
  def genrpcH(self, e, inu, outu, ipc):
    # TODO: generate function annotations for master/slave rpc calls 
    n,t = '\n','    '
    def boiler():    # ARQ mod: for each RPC functions (in and out)
      s  = '#ifndef _' + e.upper() + '_RPC_' + n
      s += '#define _' + e.upper() + '_RPC_' + n + n
      s += '#include "codec.h"' + n
      s += '#include <limits.h>' + n    # ARQ mod:
      s += '#include <pthread.h>' + n if ipc != 'Singlethreaded' and e not in self.masters else n
      s += '#include "xdcomms.h"' + n

      s += '#define INURI "' + inu + e + '"' + n
      s += '#define OUTURI "' + outu + e + '"' + n + n
      s += '#define MUX_BASE ' + str(self.muxbase) + n
      s += '#define SEC_BASE ' + str(self.secbase) + n
      s += '#define TYP_BASE ' + str(self.typbase) + n + n
      if e in self.masters: s += 'extern void _master_rpc_init();' + n + n
      else:                 s += 'extern int _slave_rpc_loop();' + n + n
      return s
      
    def muxsec(l): return '#define ' + l['muxdef'] + ' MUX_BASE + ' + str(l['mux']) + n + '#define ' + l['secdef'] + ' SEC_BASE + ' + str(l['sec']) + n
    # XXX should all be egress? Can use outgoing True,False or chage to ingress/egress
    def tagcle(l):
      s  = '#pragma cle def ' + l['clelabl'] + ' {"level": "' + e + '", \\' + n
      # remove "direction": "egress",
      s += t + '"cdf": [{"remotelevel": "' + l['to'] + '", "direction": "egress", \\' + n
      s += t + t + t + '"guarddirective": {"operation": "allow", "gapstag": [' + ','.join([str(l['mux']+self.muxbase),str(l['sec']+self.secbase),str(l['typ']+self.typbase)]) + ']}}]}' + n + n
      return s
    def funcle(f, ls):
      pre = "RPC" if e in self.masters else "HANDLE_REQUEST"
      lbls = [ l['clelabl'] for (l, o) in ls ]
      ret = json.dumps([ l['clelabl'] for (l, o) in ls if not o]) if e in self.masters else "[]"
      s = f"#pragma cle def {pre}_{f.upper()} " 
      s += ("\\" + n).join([
        '{"level": "' + e + '", ',
        t + '"cdf": [{"remotelevel":"' + e + '", "direction": "bidirectional", ',
        t + t + t + '"guarddirective": {"operation": "allow"}, ',
        t + t + t + f'"argtaints": [{ json.dumps(lbls) if e in self.masters else ""}],',
        t + t + t + f'"codtaints": { json.dumps(lbls) },',
        t + t + t + f'"rettaints": { ret }',
        t + t + t + "}]}"
      ])
      s += n
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
    
    s = boiler()   # QQQ ARQ mod: for all RPC functions????
    s2 = ''
    
    for (x,y,f,fd) in self.allCalls(e):
      if f not in self.spcalls:
        ls = [
          (self.const(x,y,f,o), o)
          for (x,y,g,fd) in self.allCalls(e) 
          for o in [True, False] 
          if g not in self.spcalls 
          if f == g 
        ]
        s += funcle(f, ls)

    for (x,y,f,fd) in self.allCalls(e):
      for o in [True,False]:
        l = self.const(x,y,f,o)
        s  += tagcle(l)
        s2 += muxsec(l)
    s += s2 + n
    for (x,y,f,fd) in self.outCalls(e): s += fundecl(fd, wrap=True)
    for (x,y,f,fd) in self.inCalls(e):  s += fundecl(fd, wrap=False)
    s += trailer()
    return s

  ##############################################################################################################
  # D) Create Cross Domain RPC source program (string) for each enclave (e.g., purple_rpc.c)
  ##############################################################################################################
  def genrpcC(self, e, ipc, DB):
    n,t = '\n','    '
    def boiler():
      s  = '#include "' + e + '_rpc.h"' + n
      s += '#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)' + n
      s += '#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(); } }' + n + n
      return s

    ##############################################################################################################
    # D1) REQ/RES CLOSURE API Initialization (register encode and decode functios)
    ##############################################################################################################
    # Register XDC encode and decode functions (e.g. for get_a) with HAL API (legacy and non-legacy)
    def regdtyp(x,y,f,outgoing=True,pfx='',sfx=''):
      l  = self.const(x,y,f,outgoing)
      ff = l['dnm'].lower()
      return pfx + 'xdc_register(' + ff + '_data_encode, ' + ff + '_data_decode, ' + l['typdef'] + sfx + ');' + n
    def cc_reg_xdc(pfx='', sfx=''):
      s = ''
      calls = self.allCalls(e) if ipc == 'Singlethreaded' else self.inCalls(e) + self.outCalls(e)
      for (x,y,f,fd) in calls:
        for o in (True, False) : s += t + regdtyp(x,y,f,o,pfx,sfx)
      return s
    # Iitialize CLOSURE API URI and Register the encode and decode function
    def halinit(e, ipc, DB):
      s  = 'void _hal_init(char *inuri, char *outuri) {' + n
      if DB[0]:
        s += t + 'xdc_log_level(0);' + n
        s += t + 'fprintf(stderr, "API URIs: in=%s out=%s\\n", inuri, outuri);' + n
      else:
        s += t + 'xdc_log_level(2);' + n
      s += '#ifdef __LEGACY_XDCOMMS__' + n
      s += t + 'xdc_set_in(inuri);' + n
      s += t + 'xdc_set_out(outuri);' + n
      s += cc_reg_xdc()
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n + n
      if DB[2]:
        s += '#ifdef __ONEWAY_RPC__' + n
        s += t + 'fprintf(stderr, "' + e + ' RPC=1-way, ");' + n
        s += '#else' + n
        s += t + 'fprintf(stderr, "' + e + ' RPC=2-way, ");' + n
        s += '#endif /* __ONEWAY_RPC__ */' + n
        s += '#ifndef __LEGACY_XDCOMMS__' + n
        s += t + 'fprintf(stderr, "API=new, ");' + n
        s += '#else' + n
        s += t + 'fprintf(stderr, "API=legacy, ");' + n
        s += '#endif /* __LEGACY_XDCOMMS__ */' + n
        if ipc == "Singlethreaded": s += t + 'fprintf(stderr, "THR=single, ");' + n
        else:                       s += t + 'fprintf(stderr, "THR=multi, ");' + n
        s += t + 'fprintf(stderr, "ARQ default={n:' + str(self.default_param['num_tries']) + ' t:' + str(self.default_param['timeout']) + ')\\n");' + n
      s += '}' + n + n
      return s

    def cc_join_delay(tag, use_timeout, tc=1):
      s  = ''
      if DB[1]: s += t*tc + 'fprintf(stderr, "Open ' + f + ' pub/sub sockets (sub filter=<%u, %u, %u>, timeout=' + str(use_timeout) + '\\n", ' + tag + '.mux, ' + tag + '.sec,' + tag + '.typ);' + n
      s += t*tc + 'sleep(1); /* zmq socket join delay */' + n
      return s
    # Open Publish and Subscribe sockets (per XD function ifndef __LEGACY_XDCOMMS__)
    # Requestor sets use_timeout=True to retrasmit packets. Responder sets use_timeout=False
    def cc_xdc_open(tag, use_timeout):
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'void * ctx = zmq_ctx_new();' + n
      s += t + 'psocket = my_xdc_pub_socket(ctx, (char *)OUTURI);' + n
      if (use_timeout) :
        param = str(self.get_param(x,y,f,'timeout'))
        s += t + 'ssocket = my_xdc_sub_socket_non_blocking(' + tag + ', ctx, ' + param + ', (char*)INURI);' + n
      else:
        s += t + 'ssocket = my_xdc_sub_socket(' + tag + ', ctx, (char*)INURI);' + n
      s += cc_join_delay(tag, use_timeout)
      s += '#else' + n
      s += t + 'if (!inited) {' + n
      s += t + t + 'inited = 1;' + n
      s += t + t + 'psocket = xdc_pub_socket();' + n
      if (use_timeout) :
        s += t + t + 'ssocket = xdc_sub_socket_non_blocking(' + tag + ', ' + param + ');' + n
      else:
        s += t + t + 'ssocket = xdc_sub_socket(' + tag + ');' + n
      s += cc_join_delay(tag, use_timeout, 2)
      s += t + '}' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s
    # Close CLOSURE API - (TTT: Have XDC API call for this rather tha direct ZMQ calls?))
    def cc_sockets_close():
      s  = t + 'zmq_close(psocket);' + n
      s += t + 'zmq_close(ssocket);' + n
      s += t + 'zmq_ctx_shutdown(ctx);' + n
      return s
      
    ##############################################################################################################
    # D2) REQ/RES: Define C code variables
    ##############################################################################################################
    def tagsPrint(tc, ptr=False):
      z = '->' if ptr else '.'
      s  = t*tc + t + 'fprintf(stderr, "t_tag=<%02u, %02u, %02u>, ", t_tag' + z + 'mux, t_tag' + z + 'sec, t_tag' + z + 'typ);' + n
      s += t*tc + t + 'fprintf(stderr, "o_tag=<%02u, %02u, %02u>\\n", o_tag' + z + 'mux, o_tag' + z + 'sec, o_tag' + z + 'typ);' + n
      return s
    # Write request (t_tag) and response (o_tag) tags using const dictionary
    def cc_tags_write_uni(x,y,f, outbound=True, tc=1):
      l  = self.const(x,y,f,outbound)
      tag = 't_tag' if outbound else 'o_tag'
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += t*tc + 'my_tag_write(&' + tag + ', ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#else' + n
      s += t*tc +    'tag_write(&' + tag + ', ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s
    def cc_tags_write_bi(x,y,f,tc=1) :
      s  = ''
      for o in [True, False]:
        s += cc_tags_write_uni(x,y,f,o,tc)
      return s;
    def cc_define_vars(counter_name, initial_count_as_a_string) :
      s  = t + 'gaps_tag t_tag;' + n
      s += t + 'gaps_tag o_tag;' + n
      s += cc_tags_write_bi(x,y,f)
      s += t + 'static int ' + counter_name + ' = ' + initial_count_as_a_string + ';' + n
      s += t + 'static ' + fd['return']['type'] + ' last_processed_result = 0;' + n
      s += t + 'static int last_processed_error = 0;' + n
      s += t + 'static int inited = 0;' + n
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'void *psocket;' + n
      s += t + 'void *ssocket;' + n
#      s += t + 'int ' + counter_name + ' = ' + initial_count_as_a_string + ';' + n
      s += '#else' + n
      s += t + 'static void *psocket;' + n
      s += t + 'static void *ssocket;' + n
#      s += t + 'static int ' + counter_name + ' = ' + initial_count_as_a_string + ';' + n

      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s;
    # Register non-legacy XDC encode and decode functions
    def cc_define_my_cmap():
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += t + 'codec_map  mycmap[DATA_TYP_MAX];' + n
      s += t + 'for (int i=0; i < DATA_TYP_MAX; i++)  mycmap[i].valid=0;' + n
      s += cc_reg_xdc('my_', ', mycmap')
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s
    # Register legacy XDC encode and decode functions (and set URIs)

    # Get packet type and name for each XD function (e.g. f='get_a') and special (e.g. f='purple_orange')
    def pkt_name(o=True):
      l = self.const(x,y,f,o)
      return l['dnm'].lower()
    def pkt_type(o=True):
      return pkt_name(o) + '_datatype'
    # Define the packet request and response structures (and pointers)
    def cc_define_req_res() :
      s  = ''
      for o in [True,False]:
        l  = self.const(x,y,f,o)
        s += t + '#pragma cle begin ' + l['clelabl'] + n
        s += t + pkt_type(o) + ' ' + pkt_name(o) + ';' + n
        s += t + '#pragma cle end ' + l['clelabl'] + n
      return s;

    def cc_get_seq_req():  return  pkt_name(True)  + '.trailer.seq'
    def cc_get_seq_res():  return  pkt_name(False) + '.trailer.seq >> 2'
    def cc_set_seq_res():  return  pkt_name(False) + '.trailer.seq'
    def cc_get_err_res():  return  '(' + pkt_name(False) + '.trailer.seq >> 1) & 0x01'
    def cc_get_ret_res():  return  pkt_name(False) + '.ret'
  
    # Define result variable from an RPC call
    def cc_define_result():
      return t + fd['return']['type'] + ' result;' + n
    
    ##############################################################################################################
    # D3) REQ: Send RPC Request and wait for Responnse (with ARQ): a) SYNC (get SN), b) DATA (RPC params and result)
    ##############################################################################################################
    def cc_call_type_and_name(outbound):
      l  = self.const(x,y,f,outbound)
      return l['dnm'][0:4] + ' ' + f + ': '
    def cc_req_print(tc):
      s  = t*tc + t + 'fprintf(stderr, "' + cc_call_type_and_name(True) + 'ReqId=%d error=%d tries=%d ", ' + cc_get_seq_req() + ', *error, tries_remaining);' + n
      s += t*tc + t + 'if (*error > 0) fprintf(stderr, "ResId=%d Reserr=%d ", ' + cc_get_seq_res() + ', ' + cc_get_err_res() + ');' + n
      s += tagsPrint(tc)
      return s
    # Done with request, so return success or failure
    def cc_req_loop_end(tc):
      s  = t*tc + t + 'break;  /* Reach here if received a response or __ONEWAY_RPC__ */' + n
      s += t*tc + '}' + n
      if DB[1]:
        s += t*tc + 'if (*error < 0) fprintf(stderr, "' + cc_call_type_and_name(True) + 'GIVING UP or ONEWAY_RPC");' + n
        s += t*tc + 'else fprintf(stderr, "RPC Succeeded");' + n
        s += t*tc + 'fprintf(stderr, " on ReqId=%d (error = %d)\\n", ' + cc_get_seq_req() + ', *error);' + n
      return s
    # Get response and resend request (continue) if xdc_recv timeout (*error == -1)
    def cc_req_recv_response(tc=1, pfx='', sfx='') :
      s  = ''
      if DB[1]: s += t*tc + t + 'fprintf(stderr, "' + cc_call_type_and_name(True) + 'Sent request on t_tag (waiting for response on o_tag)\\n");' + n
      s += t*tc + t + '*error = ' + pfx + 'xdc_recv(ssocket, &' + pkt_name(False) + ', &o_tag' + sfx +');' + n
      if DB[2]: s += cc_req_print(tc)
      s += t*tc + t + 'if (*error == -1){' + n
      s += t*tc + t + t + 'tries_remaining--;' + n
      s += t*tc + t + t + 'continue;' + n
      s += t*tc + t + '}' + n
      return s
    # Start ARQ retransmission loop end send request and wait for response (if not oneway)
    def cc_req_send_reliably (tc=1, pfx='', sfx='') :
      l  = self.const(x,y,f,True)
      s  = t*tc + 'int tries_remaining = ' + str(self.get_param(x, y, f, 'num_tries')) + ';' + n
      s += t*tc + 'while(tries_remaining != 0){' + n
      if DB[0]: s += t*tc + t + 'fprintf(stderr, "' + cc_call_type_and_name(True) + 'Calling ' + pfx +'xdc_asyn_send\\n");' + n
      s += t*tc + t + pfx +'xdc_asyn_send(psocket, &' + pkt_name(True) + ', &t_tag' + sfx + ');' + n
      s += '#ifndef __ONEWAY_RPC__' + n
      s += cc_req_recv_response(tc, pfx, sfx)
      s += '#else' + n
      s += t*tc + t + '*error = 0;' + n
      if DB[2]: s += cc_req_print(tc)
      s += '#endif /* __ONEWAY_RPC__ */' + n
      s += cc_req_loop_end(tc)
      return s
        
    ##############################################################################################################
    # D4 REQ: Creates and reads SYNC and DATA packets (in req/res_packet struct)
    ##############################################################################################################
    def cc_create_req_packet(fill=True):
      s = ''
      if len(fd['params']) == 0:
        s += t + pkt_name(True) + '.dummy = 0;'  + n  # matches IDL convention on void (ARQ avoid?)
      else:
        for q in fd['params']:
          if 'sz' in q and 'dir' in q and q['dir'] in ['in','inout']:
            s += t + 'for(int i=0; i<' + str(q['sz']) + '; i++) ' + pkt_name(True) + '.' + q['name'] + '[i] = '
            if fill:  s +=  q['name'] + '[i];' + n
            else:     s += '0;' + n    # do not pass parameters in RPC if sync packet
          else:
            s += t + pkt_name(True) + '.' + q['name'] + ' = ' + q['name'] + ';' + n
      s += t + cc_get_seq_req() + ' = req_counter;' + n
      return s

    def cc_create_nxt_packet():
      s  = t + pkt_name(True) + '.mux = n_tag->mux;' + n
      s += t + pkt_name(True) + '.sec = n_tag->sec;' + n
      s += t + pkt_name(True) + '.typ = n_tag->typ;' + n
      s += t + cc_get_seq_req() + ' = req_counter;' + n
      return s
      
    # Modify Sequence Number (after SYNC)
    def cc_modify_req_counter(tc=1):
      s = ''
      s += '#ifndef __ONEWAY_RPC__' + n
      s += t*tc + 'if (*error >= 0) req_counter = 1 + (' + cc_get_seq_res() + ');' + n
      s += '#else' + n
      s += t*tc + 'req_counter++;' + n
      s += '#endif /* __ONEWAY_RPC__ */' + n

      if DB[1]: s += t*tc + 'fprintf(stderr, "SYNC Req SN=%d\\n", req_counter);' + n
      return s
    # Send sync only once
    def cc_sync_once(pfx='', sfx=''):
      s  = t + 'if (req_counter == INT_MIN) {' + n
#      s  = t + 'if (inited < 2) {' + n
#      s += t + t + 'inited = 2;' + n
      s += cc_req_send_reliably(2, pfx, sfx)
#      s += cc_status_check(2)
      s += cc_modify_req_counter(2)
      s += t + '}' + n
      return s
      
    # RPC SYNC method for a XD function (f)
    def cc_sync() :
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += cc_sync_once('my_', ' , mycmap')
      s += '#else /* __LEGACY_XDCOMMS__ */' + n
      s += cc_sync_once()
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      return s
      
    def cc_data():
      s  = '#ifndef __LEGACY_XDCOMMS__' + n
      s += cc_req_send_reliably(1, 'my_', ' , mycmap')
#      s += cc_status_check(1)
      s += cc_sockets_close()
      s += '#else /* __LEGACY_XDCOMMS__ */' + n
      s += cc_req_send_reliably()
#      s += cc_status_check(1)
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += t + 'req_counter++;' + n
      return s
      
    # Print if know result type or use C11 _Generic:  s  = t + t + 'fprintf(stderr, "Return=%f," last_processed_result);' + n
    def cc_result_print(tc=2):
      s=''
#      s += t*tc + 'fprintf(stderr, "Result=%f\\n", result);' + n    # XXX Assumes output is a double
      return s
    def cc_read_res_packet():
      # XXX: marshaller needs to copy output arguments (including arrays) from res here !!
      s  = '#ifndef __ONEWAY_RPC__' + n
      s += t + 'result = ' + cc_get_ret_res() + ';' + n
      if DB[1]: s += cc_result_print(1)
      s += t + 'return (result);' + n   # ARQ mod: Use result from above
      s += '#else' + n
      s += t + 'return 0;' + n
      s += '#endif /* __ONEWAY_RPC__ */' + n
      return s

    def cc_read_nxt_packet():
      s  = t + 'n_tag->mux = ' + pkt_name(True) + '.mux;' + n
      s += t + 'n_tag->sec = ' + pkt_name(True) + '.sec;' + n
      s += t + 'n_tag->typ = ' + pkt_name(True) + '.typ;' + n
      if DB[0]: s += t + 'fprintf(stderr, "' + cc_call_type_and_name(False) + 'read nextrpc n_tag = <%u, %u, %u>,\\n", n_tag->mux, n_tag->sec, n_tag->typ);' + n
      s += t + '// XXX: check that we got valid SN?' + n
      return s

    # RPC nxtag Request
    def notify_nxtag(x,y,f,fd):
      s  = 'void _notify_next_tag(gaps_tag* n_tag, int *error) {' + n
      s += cc_define_vars('req_counter', 'INT_MIN')
      s += cc_define_req_res()
      s += cc_define_my_cmap()
      s += cc_xdc_open('o_tag', True)
      s += cc_create_nxt_packet()
      s += cc_sync()
      s += cc_create_nxt_packet()
      if DB[1]: s += t + 'fprintf(stderr, "' + cc_call_type_and_name(True) + 'nxt tag=<%d, %d, %d>\\n", ' + pkt_name(True) + '.mux, ' + pkt_name(True) + '.sec, ' + pkt_name(True) + '.typ)' + ';' + n
      s += cc_data()
      s += '}' + n + n
      return s
      
    # Common RPC exteral Request function: e.g., _rpc_get_a()
    def rpcwrapdef(x,y,f,fd,ipc):
      s = "#pragma cle begin RPC_" + f.upper() + n
      s += fd['return']['type'] + ' _rpc_' + f + '('
      def mparam(q): return q['type'] + ' ' + q['name'] + ('[]' if 'sz' in q else '') # XXX: check array/pointer issues
      s += ','.join([mparam(q) for q in fd['params']])
      # ARQ adds an error parameter (not used yet)
      if s[-1] != '(': s += ', '
      s += 'int *error) {' + n
      s += "#pragma cle end RPC_" + f.upper() + n

      s += cc_define_vars('req_counter', 'INT_MIN')
      s += cc_define_req_res()
      s += cc_define_result()
      s += cc_define_my_cmap()
      s += cc_xdc_open('o_tag', True)
      
      if ipc == "Singlethreaded":
        if DB[1]: s += t + 'fprintf(stderr, "' + cc_call_type_and_name(True) + 'Singlethreaded nxt tag=<%d, %d, %d>\\n", t_tag.mux, t_tag.sec, t_tag.typ)' + ';' + n
        s += t + '_notify_next_tag(&t_tag, error);' + n
      s += cc_create_req_packet(False)
      s += cc_sync()
      s += cc_create_req_packet(True)
      s += cc_data()
      s += cc_read_res_packet()
      s += '}' + n + n
      return s
      
    ##############################################################################################################
    # D5) RES: handlers waits for RPC request and sends RPC Responnse
    ##############################################################################################################
    def cc_res_print():
      s  = t + t + 'fprintf(stderr, "' + cc_call_type_and_name(False) + 'ReqId=%d ResId=%d err=%d (seq=0x%x) ", req_counter, res_counter, proc_error, last_processed_error);' + n
      s += cc_result_print()
      s += tagsPrint(1)
      return s

    # Call local function - XXX: marshaller needs to copy output arguments (including arrays) to res here !!
    def cc_res_get_result_from_local_app():
      s  = t + t + t + 'last_processed_result = ' + f + '(' + ','.join([pkt_name(True) + '.' + q['name'] for q in fd['params']]) + ');' + n
      s += t + t + t + cc_get_ret_res() + ' = last_processed_result;' + n
      return s
    # Call Application if new request, storing result in last_processed_result (and reset proc_error)
    def cc_res_check_seq_nums(notSpecial):
      s  = t + t + 'if(req_counter > res_counter){' + n
      s += t + t + t + 'proc_error = 0;' + n
      s += t + t + t + 'res_counter = req_counter;' + n
      if notSpecial: s += cc_res_get_result_from_local_app()
      s += t + t + t + 'last_processed_error = proc_error;' + n
      s += t + t + '}' + n
      return s
        
    # Reply to any app function request. Return last_processed_result
    def cc_res_wait_for_request(pfx='', sfx='', notSpecial=True) :
      s = ''
      s += t + 'int proc_error = 1;' + n
      s += t + 'while (proc_error == 1) {' + n    # only return when a new request is good
      if DB[0]: s += t + t + 'fprintf(stderr, "' + cc_call_type_and_name(False) + 'Waiting for request on t_tag (send response on o_tag)\\n");' + n
      s += t + t + pfx + 'xdc_blocking_recv(ssocket, &' + pkt_name(True) + ', &t_tag' + sfx + ');' + n
      s += t + t + 'int req_counter = ' + cc_get_seq_req() + ';' + n
      s += cc_res_check_seq_nums(notSpecial)
      s += '#ifndef __ONEWAY_RPC__' + n
      s += t + t + cc_set_seq_res() + ' = res_counter << 2 | last_processed_error << 1;' + n
      s += t + t + pfx + 'xdc_asyn_send(psocket, &' + pkt_name(False) + ', &o_tag' + sfx + ');' + n
      s += '#else /* __ONEWAY_RPC__ */' + n
      s += t + t + 'res_counter = req_counter;' + n
      s += '#endif /* __ONEWAY_RPC__ */' + n
      if DB[2]: s += cc_res_print()
      s += t + '}' + n
      return s
      
    # Listens for any Special (NEXTRPC/OKAY) packets
    def handlernextrpc(x,y,f,fd):
      s  = 'void _handle_nextrpc(gaps_tag* n_tag) {' + n
      s += cc_define_vars('res_counter', '0')
      s += cc_define_req_res()
      s += cc_define_my_cmap()
#     Subscribe to any packet
#      s += t + 'gaps_tag any_tag;' + n
#      s += t + 'tag_write(&any_tag, 0, 2, 1);' + n
#      s += cc_xdc_open('any_tag', False)

      s += cc_xdc_open('t_tag', False)
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += cc_res_wait_for_request('my_', ', mycmap', False)
      s += cc_sockets_close()
      s += '#else' + n
      s += cc_res_wait_for_request('', '', False)
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += cc_read_nxt_packet()
      s += '}' + n + n
      return s
    # Listen for RPC Requests
    def handlerdef(x,y,f,fd,ipc):
      s  = "#pragma cle begin HANDLE_REQUEST_" + f.upper() + n
      s += 'void _handle_request_' + f + '() {' + n
      s += "#pragma cle end HANDLE_REQUEST_" + f.upper() + n
      s += cc_define_vars('res_counter', '0')
      s += cc_define_req_res()
      s += cc_define_my_cmap()
      s += cc_xdc_open('t_tag', False)
      s += '#ifndef __LEGACY_XDCOMMS__' + n
      s += cc_res_wait_for_request('my_', ', mycmap')
      s += cc_sockets_close()
      s += '#else' + n
      s += cc_res_wait_for_request()
      s += '#endif /* __LEGACY_XDCOMMS__ */' + n
      s += '}' + n + n
      return s
      
    ##############################################################################################################
    # D6) REQ/RES: Slave starts thread per app function handler and Master waits for APP function calls)
    ##############################################################################################################
    def slavedispatch(e,ipc):
      s = ''
      if ipc == "Multithreaded":
        for (x,y,f,fd) in self.inCalls(e): s += 'WRAP(request_' + f + ')' + n
        s += '#define NXDRPC ' + str(len(self.inCalls(e))) + n + n
      else:
        s += '#define NXDRPC 0' + n + n

      s += 'int _slave_rpc_loop() {' + n
      s += t + '_hal_init((char *)INURI, (char *)OUTURI);' + n
      if DB[1]: s += t + 'fprintf(stderr, "' + cc_call_type_and_name(False) + 'Adds %d Threads\\n", NXDRPC);' + n
      if ipc == "Multithreaded":
        # A) Start thread per app function handler (inCall)
        s += t + 'pthread_t tid[NXDRPC];' + n
        tidIndex = 0
        for (x,y,f,fd) in self.inCalls(e):
          s += t + 'pthread_create(&tid[' + str(tidIndex) + '], NULL, _wrapper_request_' + f + ', NULL);' + n
          tidIndex += 1
        s += t + 'for (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL);' + n
        s += t + 'return 0;' + n
        s += '}' + n + n
      else:
        # B) Singlethreaded nextrpc/app function handler while loop
        s += t + 'gaps_tag n_tag;' + n
        s += t + 'gaps_tag o_tag;' + n
        s += t + 'gaps_tag t_tag;' + n
        # Singlethread slave msin loop
        s += t + 'while (1) {' + n
        s += t + t + '_handle_nextrpc(&n_tag);' + n
        if DB[1]: s += t + 'fprintf(stderr, "Singlethread slave main loop gets n_tag <%u, %u, %u>\\n", n_tag.mux, n_tag.sec, n_tag.typ);' + n
        for (x,y,f,fd) in self.sInCalls(e):
          s += cc_tags_write_uni(x,y,f,True,2)     # write t_tag for special call
          s += t + t + 'if(TAG_MATCH(n_tag, t_tag)) { continue; }' + n
        for (x,y,f,fd) in self.inCalls(e):
          s += cc_tags_write_bi(x,y,f,2)             # write t_tag and o_tag for RPC call
          s += t + t + 'if (TAG_MATCH(n_tag, t_tag)) {' + n
          s += t + t + t + '_handle_request_'+ f + '();' + n
          s += t + t + t + 'continue;' + n
          s += t + t + '}' + n
        s += t + '}' + n
        s += '}' + n + n
      return s
      
    def masterdispatch(e,ipc):
      return 'void _master_rpc_init() {' + n + t + '_hal_init((char*)INURI, (char *)OUTURI);' +n + '}' + n + n

    ##############################################################################################################
    # D7) REQ/RES: Create RPC C source code as string to be writen to a file: e.g., file=purple/purple_rpc.c
    ##############################################################################################################
    s = boiler() + halinit(e, ipc, DB)
    if ipc == "Singlethreaded":
      for (x,y,f,fd) in self.sInCalls(e):
        s += handlernextrpc(x,y,f,fd)
      for (x,y,f,fd) in self.sOutCalls(e):
        s += notify_nxtag(x,y,f,fd)
    for (x,y,f,fd) in self.inCalls(e):
      s += handlerdef(x,y,f,fd,ipc)
    for (x,y,f,fd) in self.outCalls(e):
      s += rpcwrapdef(x,y,f,fd,ipc)
    s += masterdispatch(e, ipc) if e in self.masters else slavedispatch(e, ipc)
    return s

  ##############################################################################################################
  # E) Process Source FIle(s)
  ##############################################################################################################
  def findMaster(self,enclaves,idirp,prog):
    idir   = idirp.rstrip('/')
    for e in enclaves:
      fn = idir + '/' + e + '/' + prog + '.c'
      if gotMain(fn): self.masters.append(e)

  def processSourceTree(self,prog,enclaves,idirp,odirp, DB):
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
        for fname in files: self.processFile(prog,e,idir,odir,rel,fname, DB)

  # Modify APP (e.g. example1.c), adding prefix to XD (affected) functions (e.g. get_a to _rpc_get_a)
  def processFile(self, prog, e, idir, odir, rel, fname, DB): # XXX: ought to use a C Parser, not regex
    err_param = ''
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
              if DB[1]: print('Adding rpc init to master main in: ' + canonnew)
              newf.write(line)
              newf.write("  _master_rpc_init();\n")
              continue
            if canonold in self.affected:
              if index+1 in self.affected[canonold]:
                for func in self.affected[canonold][index+1]:
                  if line.find(func) == -1: raise Exception(func + ' not found in ' + canonold + ' at line ' + str(index) + ':' + line)
                  err_param = 'error_num_' + func
                  newline1 = ' ' * (len(line) - len(line.lstrip())) + 'int ' + err_param + ';\n'
                  newf.write(newline1)
                  line = line.replace(func, '_rpc_' + func)
                  if DB[1]:
                    print('Add error variable line', newline1)
                    print('Replacing ' + func +' with _rpc_' + func + ' on line ' + str(index) + ' in file ' + canonnew)
            # ARQ adds an error variable to each XD function call (canonold in self.affected)
            if len(err_param) > 0:
                if DB[0]: print('Checking if close rpc function call')
                if line.find(')') != -1:    # end of (possibly multi-line) XD function call
                  if line.find('()') == -1: line = line.replace(')', ', &' + err_param + ')')
                  else:                     line = line.replace(')',   '&' + err_param + ')')
                  if DB[1]: print('Adding error variable', err_param, 'to XD function')
                  err_param = ''
            newf.write(line)
          if e not in self.masters:
            if DB[1]: print('Adding slave main to: ' + canonnew)
            newf.write('int main(int argc, char *argv[]) {\n  return _slave_rpc_loop();\n}')
    else:
      copyfile(idir + '/' + rel + '/' + fname, odir + '/' + rel + '/' + fname)

##############################################################################################################
# F) Main
##############################################################################################################
def main():
  args = argparser()
  DB = [False, True, True] if args.verbose else [False, False, True]  # Print Debugs at levels: 0(Trace), 1(Debug), 2(Info)?
  gp   = GEDLProcessor(args.gedl,args.enclave_list,args.mux_base,args.sec_base,args.typ_base,args.schema,args.cle)
  if len(args.enclave_list) != 2: raise Exception('Only supporting two enclaves for now')
  gp.findMaster(args.enclave_list,args.edir,args.mainprog)
  if len(gp.masters) != 1: raise Exception('Need one master, got:' + ' '.join(gp.masters))
  print('2022 Merged (April 20) Version: Processing source tree from ' + args.edir + ' to ' + args.odir)
  gp.processSourceTree(args.mainprog,args.enclave_list,args.edir,args.odir, DB)

  for e in args.enclave_list:
    print('Generating RPC Header for:', e)
    with open(args.odir + '/' + e + '/' + e + '_rpc.h', 'w') as rh: rh.write(gp.genrpcH(e, args.inuri, args.outuri, args.ipc))
    print('Generating RPC Code for:', e)
    with open(args.odir + '/' + e + '/' + e + '_rpc.c', 'w') as rc: rc.write(gp.genrpcC(e, args.ipc, DB))
  print('Generating cross domain configuration')
  with open(args.odir + "/" + args.xdconf, "w") as xf: json.dump(gp.genXDConf(args.inuri, args.outuri), xf, indent=2)
  if DB[1]:
    for e in args.enclave_list: gp.constPrint(e)
#  for e in args.enclave_list: gp.constPrint(e)
#  xyz

if __name__ == '__main__':
  main()
