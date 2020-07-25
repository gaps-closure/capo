#!/usr/bin/python3
import json
import sys
import copy
import os
from argparse import ArgumentParser

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
  parser.add_argument('-m','--mainprog', required=True, type=str, help='File with main program on master side')
  return parser.parse_args()

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
    y = [x for x in self.gedl if x['caller'] not in enclaveList or x['callee'] not in enclaveList]
    if len(y) > 0: raise Exception('Enclaves referenced in GEDL not in provided enclave list: ' + ','.join(y))
    if len(self.xdcalls) != len(set(self.xdcalls)): raise Exception('Cross-domain function calls are not unique')

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
    n = '\n' 
    t = '    '
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
    def muxsec(l): return '#define ' + l['muxdef'] + ' APP_BASE + ' + str(l['mux']) + n + '#define ' + l['secdef'] + ' APP_BASE ' + str(l['sec']) + n
    def tagcle(x,y,f,outgoing=True): 
      l  = self.const(x,y,f,outgoing)
      s  = '#pragma cle def ' + l['clelabl'] + ' {"level": "' + e + '", \\' + n
      s += t + '"cdf": [{"remotelevel": "' + l['to'] + '", "direction": "egress", \\' + n
      s += t + t + t + '"guardhint": {"operation": "allow", "gapstag": [' + ','.join([str(l['mux']+self.appbase),str(l['sec']+self.appbase),str(l['typ'])]) + ']}}]}' + n + n
      return s
    def specials(x,y):
      s  = muxsec(self.const(x,y,'nextrpc',True))
      s += muxsec(self.const(x,y,'okay',False)) + n
      s += tagcle(x,y,'nextrpc',outgoing=True) 
      s += tagcle(x,y,'okay',outgoing=False) 
      return s
    def fundecl(fd, wrap=True): 
      s  = 'extern ' + fd['return']['type'] + ' ' + ('_rpc_' if wrap else '') + fd['func'] + '('
      s += ','.join([p['type'] + '[]' if 'sz' in p else '' + ' ' + p['name'] for p in fd['params']]) + ');' + n  # XXX: check array/pointer
      return s
    def trailer(): return n + '#endif /* _' + e.upper() + '_RPC_ */' + n

    s = boiler()
    if len(self.enclaveList) == 2 and len(self.masters) == 1:   # XXX: multi-enclave scenario not handled, NEXTRPC will have different mux,sec per peer
      if e in self.masters:
        for p in self.callees(e): s +=  specials(e,p)
      else:
        for p in self.masters:    s +=  specials(p,e)
    for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e):  s += tagcle(x,y,f,outgoing=True) + tagcle(x,y,f,outgoing=False) 
    for (x,y,f,fd) in self.outCalls(e) + self.inCalls(e):  s += muxsec(self.const(x,y,f,True)) + muxsec(self.const(x,y,f,False))
    s += n
    for (x,y,f,fd) in self.outCalls(e):                    s += fundecl(fd, wrap=True)
    for (x,y,f,fd) in self.inCalls(e):                     s += fundecl(fd, wrap=False)
    s += n
    return s

  ##############################################################################################################
  def genrpcC(self, e, ipc): 
    n = '\n' 
    t = '    '
    def boiler():
      s  = '#include "' + e + '_rpc.h"' + n
      s += '#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)' + n
      s += '#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }' + n + n
      return s
    def regdtyp(x,y,f,outgoing=True): 
      l  = self.const(x,y,f,outgoing)
      return t + 'xdc_register(request_' + f + "_data_encode, request_" + f + '_data_decode, ' + l['typdef'] + ');' + n
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
      s += t + 'static static void *psocket;' + n
      s += t + 'static void *ssocket;' + n
      s += t + 'gaps_tag t_tag;' + n
      s += t + 'gaps_tag o_tag;' + n
      return s;
    def BLOCK2():
      s  = t + 'if (!inited) {' + n
      s += t + t + 'inited = 1;' + n
      s += t + t + 'psocket = xdc_pub_socket();' + n
      s += t + t + 'ssocket = xdc_sub_socket(t_tag);' + n
      s += t + t + 'sleep(1); /* zmq socket join delay */' + n
      s += t + '}' + n 
      return s;
    def notify_nxtag(): # XXX: hardcoded tags, should use self.const
      s  = 'void _notify_next_tag(gaps_tag* n_tag) {' + n
      s += BLOCK1()
      s += t + '#pragma cle begin TAG_NEXTRPC' + n                                              
      s += t + 'nextrpc_datatype nxt;' + n
      s += t + '#pragma cle end TAG_NEXTRPC' + n
      s += t + '#pragma cle begin TAG_OKAY' + n
      s += t + 'okay_datatype okay;' + n
      s += t + '#pragma cle end TAG_OKAY' + n + n
      s += t + 'nxt.mux = n_tag->mux;' + n
      s += t + 'nxt.sec = n_tag->sec;' + n
      s += t + 'nxt.typ = n_tag->typ;' + n
      s += t + 'tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);' + n
      s += t + 'tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);' + n + n
      s += BLOCK2()
      s += t + 'xdc_asyn_send(psocket, &nxt, &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &okay, &o_tag);' + n
      s += t + '// XXX: check that we got valid OK?' + n
      s += '}' + n + n
      return s
    def handlerdef(x,y,f,fd,ipc):
      s  = 'void _handle_request_' + f + '(gaps_tag* tag) {' + n
      s += BLOCK1()
      l  = self.const(x,y,f,False)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'request_' + f + '_datatype req_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += t + 'tag_write(&t_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      l  = self.const(x,y,f,True)
      s += t + '#pragma cle begin ' + l['clelabl'] + n
      s += t + 'response_' + f + '_datatype res_' + f + ';' + n
      s += t + '#pragma cle end ' + l['clelabl'] + n
      s += t + 'tag_write(&o_tag, ' + l['muxdef'] + ', ' + l['secdef'] + ', ' + l['typdef'] + ');' + n
      s += BLOCK2()
      s += t + 'xdc_blocking_recv(ssocket, &req_' + f + ', &t_tag);' + n
      s += t + ('res_' + f + '.ret = ' if fd['return']['type'] != 'void' else '') + f + '(' + ','.join(['req_' + f + '.' + q['name'] for q in fd['params']]) + ');' + n
      # XXX: marshaller needs to copy output arguments (including arrays) to res here !!
      s += t + 'xdc_asyn_send(psocket, &res_' + f + ', &o_tag);' + n
      s += '}' + n + n
      return s
    def rpcwrapdef(x,y,f,fd,ipc):
      def mparam(q): return q['type'] + ('[]' if 'sz' in q else '') + ' ' + q['name']  # XXX: check array/pointer issues
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
          s += t + 'req_' + f + '.' + q['name'] + ' = ' + q['name'] + ';' + n
          # XXX: check if this is adequate for arrays
      s += BLOCK2()
      if ipc == "Singlethreaded": s += t + '_notify_next_tag(&t_tag);' + n
      s += t + 'xdc_asyn_send(psocket, &req_' + f + ', &t_tag);' + n
      s += t + 'xdc_blocking_recv(ssocket, &res_' + f + ', &o_tag);' + n
      # XXX: marshaller needs to copy output arguments (including arrays) from res here !!
      s += t + 'return (res_' + f + '.ret);' + n
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
        s += 'int _slave_rpc_loop() {' + n
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
        s += 'gaps_tag n_tag;' + n
        s += 'gaps_tag t_tag;' + n + n
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
    if e in self.masters: s += notify_nxtag() + n    # XXX: redundant for multithreaded
    for (x,y,f,fd) in self.inCalls(e):  s += handlerdef(x,y,f,fd,ipc)
    for (x,y,f,fd) in self.outCalls(e): s += rpcwrapdef(x,y,f,fd,ipc)
    s += masterdispatch(e, ipc) if e in self.masters else slavedispatch(e, ipc)
    return s

  ##############################################################################################################
  def walkSourceTree(self): pass
  # look for main program in each enclave
  # confirm only one has main
  # update self.masters with enclave
  # process the main 
  # for every program and line requiring mod
  def inferMaster(self): pass
  def processFiles(self): pass


"""
# XXX: to be rewritten for source trees
def CModFunction(enclave,args,enclaveMap,replaceList,callerList,calleeList):
    if not os.path.isfile(enclaveMap[enclave][0]):
        print("File" + enclaveMap[enclave][0] + "does not exist. Please update GEDL Schema with valid C file.\n")
        exit(0)
    with open(enclaveMap[enclave][0]) as old_file:
        newFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:]
        enclaveIndex = enclaveMap[enclave][2]
        with open((args.odir + "/" + enclave + "/" + newFile),"w") as modc_file:
            modc_file.write("#include \"" + newFile[:newFile.rfind(".")] + "_rpc.h\"\n")
            oldFileLines = list(old_file)
            for index, line in enumerate(oldFileLines):
                if "int main(" in line:
                    modc_file.write(line)
                    modc_file.write("\t_master_rpc_init();\n")
                    enclaveMap[enclave][1] = "master"
                    continue
                while len(replaceList[enclaveIndex]) > 0 and (index+1) == replaceList[enclaveIndex][0][0]:
                    callIndex = line.find(replaceList[enclaveIndex][0][1])
                    if callIndex == -1:
                        print("Error: GEDL Cross-Enclave callsite in file %s for function %d at line %s could not be found" % (enclaveMap[enclave][0],index,replaceList[enclaveIndex][0][1]))
                    else:
                        line = line.replace(replaceList[enclaveIndex][0][1],"_rpc_" + replaceList[enclaveIndex][0][1])
                    del replaceList[enclaveIndex][0]
                modc_file.write(line)
            if enclaveMap[enclave][1] != "master":
                modc_file.write("int main(int argc, char **argv) {\n\treturn _slave_rpc_loop();\n}")

"""

#####################################################################################################################################################
if __name__ == '__main__':
  args = argparser()
  gp   = GEDLProcessor(args.gedl,args.enclave_list,args.app_base)

  # gp.findMaster()
  # XXX: hack until we infer this from code
  gp.masters.append('orange')

  # gp.processSourceTree()

  for e in args.enclave_list:
    with open(args.odir + '/' + e + '/' + e + '_rpc.h', 'w') as rh: rh.write(gp.genrpcH(e, args.inuri, args.outuri, args.ipc))
    with open(args.odir + '/' + e + '/' + e + '_rpc.c', 'w') as rc: rc.write(gp.genrpcC(e, args.ipc))

  with open(args.odir + "/" + args.xdconf, "w") as xf: json.dump(gp.genXDConf(args.inuri, args.outuri), xf, indent=2)

