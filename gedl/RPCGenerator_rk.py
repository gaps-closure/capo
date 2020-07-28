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
  parser.add_argument('-B','--app_base', required=False, type=int, default=0, help='Application base index for tags')
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
  def __init__(self, gedlfile, enclaveList, appbase):
    with open(gedlfile) as edl_file: self.gedl = json.load(edl_file)['gedl']
    self.xdcalls     = [c['func'] for x in self.gedl for c in x['calls']]
    self.specials    = ['nextrpc', 'okay']
    self.appbase     = appbase
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
      return {'from':y['from'],'to':y['to'],'mux':y['mux']+self.appbase,'sec':y['sec']+self.appbase,'typ':y['typ'],'name':y['dnm']}
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
      s += '#include "xdcomms.h"' + n
      s += '#include "codec.h"' + n
      s += '#include <pthread.h>' + n if ipc != 'Singlethreaded' and e not in self.masters else n
      s += '#define INURI "' + inu + e + '"' + n
      s += '#define OUTURI "' + outu + e + '"' + n + n
      s += '#define APP_BASE ' + str(self.appbase) + n + n
      if e in self.masters: s += 'extern void _master_rpc_init();' + n + n
      else:                 s += 'extern int _slave_rpc_loop();' + n + n
      return s
    def muxsec(l): return '#define ' + l['muxdef'] + ' APP_BASE + ' + str(l['mux']) + n + '#define ' + l['secdef'] + ' APP_BASE + ' + str(l['sec']) + n
    def tagcle(x,y,f,outgoing=True): 
      l  = self.const(x,y,f,outgoing)
      s  = '#pragma cle def ' + l['clelabl'] + ' {"level": "' + e + '", \\' + n
      s += t + '"cdf": [{"remotelevel": "' + l['to'] + '", "direction": "egress", \\' + n
      s += t + t + t + '"guardhint": {"operation": "allow", "gapstag": [' + ','.join([str(l['mux']+self.appbase),str(l['sec']+self.appbase),str(l['typ'])]) + ']}}]}' + n + n
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
    def regdtyp(x,y,f,outgoing=True): 
      l  = self.const(x,y,f,outgoing)
      if outgoing:
        return 'xdc_register(request_' + f + "_data_encode, request_" + f + '_data_decode, ' + l['typdef'] + ');' + n
      else:
        return 'xdc_register(response_' + f + "_data_encode, response_" + f + '_data_decode, ' + l['typdef'] + ');' + n
    def halinit(e):    # XXX: hardcoded tags, should use self.const
      s  = 'void _hal_init(char *inuri, char *outuri) {' + n 
      s += t + 'xdc_set_in(inuri);' + n 
      s += t + 'xdc_set_out(outuri);' + n
      s += t + 'xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);' + n  
      s += t + 'xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);' + n           
      for (x,y,f,fd) in self.inCalls(e) + self.outCalls(e):
        s += t + regdtyp(x,y,f,True)
        s += t + regdtyp(x,y,f,False)
      s += '}' + n + n
      return s
    def BLOCK1():
      s  = t + 'static int inited = 0;' + n
      s += t + 'static void *psocket;' + n
      s += t + 'static void *ssocket;' + n
      s += t + 'gaps_tag t_tag;' + n
      s += t + 'gaps_tag o_tag;' + n
      return s;
    def BLOCK2(tag):
      s  = t + 'if (!inited) {' + n
      s += t + t + 'inited = 1;' + n
      s += t + t + 'psocket = xdc_pub_socket();' + n
      s += t + t + 'ssocket = xdc_sub_socket(' + tag + ');' + n
      s += t + t + 'sleep(1); /* zmq socket join delay */' + n
      s += t + '}' + n 
      return s;
    def notify_nxtag(): # XXX: hardcoded tags, should use self.const
      s  = 'void _notify_next_tag(gaps_tag* n_tag) {' + n
      s += BLOCK1()
      s += t + '#pragma cle begin TAG_NEXTRPC' + n                                              
      s += t + 'nextrpc_datatype nxt;' + n
      s += t + '#pragma cle end TAG_NEXTRPC' + n
      s += t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += t + '#pragma cle begin TAG_OKAY' + n
      s += t + 'okay_datatype okay;' + n
      s += t + '#pragma cle end TAG_OKAY' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += BLOCK2('o_tag')
      s += t + 'nxt.mux = n_tag->mux;' + n
      s += t + 'nxt.sec = n_tag->sec;' + n
      s += t + 'nxt.typ = n_tag->typ;' + n
      s += t + 'xdc_asyn_send(psocket, &nxt, &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &okay, &o_tag);' + n
      s += t + '// XXX: check that we got valid OK?' + n
      s += '}' + n + n
      return s
    def rpcwrapdef(x,y,f,fd,ipc):
      def mparam(q): return q['type'] + ' ' + q['name'] + ('[]' if 'sz' in q else '') # XXX: check array/pointer issues
      s = fd['return']['type'] + ' _rpc_' + f + '(' + ','.join([mparam(q) for q in fd['params']]) +') {' + n
      s += BLOCK1()
      l  = self.const(x,y,f,True)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'request_' + f + '_datatype req_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      l  = self.const(x,y,f,False)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'response_' + f + '_datatype res_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += t + 'tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
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
      s += t + 'xdc_asyn_send(psocket, &req_' + f + ', &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &res_' + f + ', &o_tag);' + n
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
      s += t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += BLOCK2('t_tag')
      s += t + 'xdc_blocking_recv(ssocket, &nxt, &t_tag);' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n
      s += t + 'okay.x = 0;' + n
      s += t + 'xdc_asyn_send(psocket, &okay, &o_tag);' + n
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
      s += t + 'request_' + f + '_datatype req_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      l  = self.const(x,y,f,False)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'response_' + f + '_datatype res_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += t + 'tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += BLOCK2('t_tag')
      s += t + 'xdc_blocking_recv(ssocket, &req_' + f + ', &t_tag);' + n
      s += t + ('res_' + f + '.ret = ' if fd['return']['type'] != 'void' else '') + f + '(' + ','.join(['req_' + f + '.' + q['name'] for q in fd['params']]) + ');' + n
      # XXX: marshaller needs to copy output arguments (including arrays) to res here !!
      s += t + 'xdc_asyn_send(psocket, &res_' + f + ', &o_tag);' + n
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
        s += t + 'gaps_tag n_tag;' + n
        s += t + 'gaps_tag t_tag;' + n + n
        s += t + '_hal_init((char *)INURI, (char *)OUTURI);' + n + n
        s += t + 'while (1) {' + n
        s += t + t + '_handle_nextrpc(&n_tag);' + n
        s += t + t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n    # XXX: hardcoded labels
        s += t + t + 'if(TAG_MATCH(n_tag, t_tag)) { continue; }' + n
        for (x,y,f,fd) in self.inCalls(e):  
          l  = self.const(x,y,f,False)
          s += t + t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
          s += t + t + 'if (TAG_MATCH(n_tag, t_tag)) {' + n
          s += t + t + t + '_handle_request_'+ f + '(NULL);' + n
          s += t + t + t + '}' + n
          s += t + t + 'continue;' + n
          s += t + '}' + n
          s += '}' + n + n
      return s

    s = boiler() + halinit(e)
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
  gp   = GEDLProcessor(args.gedl,args.enclave_list,args.app_base)
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

