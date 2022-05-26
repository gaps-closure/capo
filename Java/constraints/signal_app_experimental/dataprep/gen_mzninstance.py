#!/usr/bin/python3
import os
import os.path
import sys
import csv
import json
import gzip
import logging
import networkx                  as nx
from   networkx.drawing.nx_pydot import write_dot
from   argparse                  import ArgumentParser
from   cle2zinc                  import compute_zinc

def get_args():
  p = ArgumentParser(description='Constraint Instance Data Encoder')
  p.add_argument('-i', '--input_model', required=True, type=str, help='Gzipped Input Program Model JSON file')
  p.add_argument('-c', '--cle_json', required=True, type=str, help='Input Program Model JSON file')
  p.add_argument('-o', '--output_dir', required=False, default='./instance', type=str, help='Output Model MZN file')
  p.add_argument('-D', '--debug', required=False, action='store_true', help='Include Debug Output')
  return p.parse_args()

def fix(x): return x.rsplit('.',1)[-1]

def annotsplit(j):
  for x in j:
    x['cle-label'] = fix(x['cle-label'])
    if 'cdf' in x['cle-json']:
      for y in x['cle-json']['cdf']:
        if 'rettaints' in y:
          y['rettaints'] = list(map(fix, y['rettaints']))
          y['codtaints'] = list(map(fix, y['codtaints']))
          y['argtaints'] = list(map(lambda w: list(map(fix, w)), y['argtaints']))
  return j

def brklns(arr,n):
  chunks = [map(str,arr[i:i+n]) for i in range(0, len(arr), n)]
  return '\n'.join([','.join(c)+',' for c in chunks])

def nparms(x): return 0 if 'p' not in x else len(x['p']) 

def esatrack(data):
  if 'classes'   not in data: data['classes'] = []
  if 'fields'    not in data: data['fields'] = []
  if 'methods'   not in data: data['methods'] = []
  if 'calls'     not in data: data['calls'] = []
  if 'fieldRefs' not in data: data['fieldRefs'] = []
  for x in data['classes']:
    x['e'] = True if 'e' in x and x['e'] == True else False
    x['g'] = False
    x['c'] = x['i']
  for x in (data['fields'] + data['methods']):
    x['e'] = True if 'e' in x and x['e'] == True else False
    x['s'] = True if 's' in x and x['s'] == True else False
    x['g'] = False
    x['G'] = None
    if 'a' in x:
      for a in x['a']:
        ann = data['annotations'][a-1]
        if 'isCLE' in ann and ann['isCLE'] == True: 
          x['g'] = True
          if x['G'] is not None: raise('Multiple CLE annotations found')
          x['G'] = ann['n']
          data['classes'][x['c']-1]['g'] = True
  for x in data['calls']:
    if data['methods'][x['F']-1]['e'] == True: raise ('External method cannot be caller')
    x['e'] = data['methods'][x['T']-1]['e']
    x['s'] = data['methods'][x['T']-1]['s']
    x['g'] = data['methods'][x['T']-1]['g']
  for x in data['fieldRefs']:
    if data['methods'][x['F']-1]['e'] == True: raise ('External method cannot be caller')
    x['e'] = data['fields'][x['T']-1]['e']
    x['s'] = data['fields'][x['T']-1]['s']
    x['g'] = data['methods'][x['T']-1]['g']
  return data

class Model():
  def __init__(self,data):
    self.data       = data
    self.intun      = [x for x in self.data['classes']   if x['e'] == False and x['g'] == False]
    self.intan      = [x for x in self.data['classes']   if x['e'] == False and x['g'] == True]
    self.extun      = [x for x in self.data['classes']   if x['e'] == True  and x['g'] == False]
    self.extan      = [x for x in self.data['classes']   if x['e'] == True  and x['g'] == True]
    self.iiufld     = [x for x in self.data['fields']    if x['e'] == False and x['s'] == False and x['g'] == False]
    self.iiafld     = [x for x in self.data['fields']    if x['e'] == False and x['s'] == False and x['g'] == True]
    self.isufld     = [x for x in self.data['fields']    if x['e'] == False and x['s'] == True  and x['g'] == False]
    self.isafld     = [x for x in self.data['fields']    if x['e'] == False and x['s'] == True  and x['g'] == True]
    self.eiufld     = [x for x in self.data['fields']    if x['e'] == True  and x['s'] == False and x['g'] == False]
    self.eiafld     = [x for x in self.data['fields']    if x['e'] == True  and x['s'] == False and x['g'] == True]
    self.esufld     = [x for x in self.data['fields']    if x['e'] == True  and x['s'] == True  and x['g'] == False]
    self.esafld     = [x for x in self.data['fields']    if x['e'] == True  and x['s'] == True  and x['g'] == True]
    self.iiumth     = [x for x in self.data['methods']   if x['e'] == False and x['s'] == False and x['g'] == False]
    self.iiamth     = [x for x in self.data['methods']   if x['e'] == False and x['s'] == False and x['g'] == True]
    self.isumth     = [x for x in self.data['methods']   if x['e'] == False and x['s'] == True  and x['g'] == False]
    self.isamth     = [x for x in self.data['methods']   if x['e'] == False and x['s'] == True  and x['g'] == True]
    self.eiumth     = [x for x in self.data['methods']   if x['e'] == True  and x['s'] == False and x['g'] == False]
    self.eiamth     = [x for x in self.data['methods']   if x['e'] == True  and x['s'] == False and x['g'] == True]
    self.esumth     = [x for x in self.data['methods']   if x['e'] == True  and x['s'] == True  and x['g'] == False]
    self.esamth     = [x for x in self.data['methods']   if x['e'] == True  and x['s'] == True  and x['g'] == True]
    self.iiucll      = [x for x in self.data['calls']     if x['e'] == False and x['s'] == False and x['g'] == False]
    self.iiacll      = [x for x in self.data['calls']     if x['e'] == False and x['s'] == False and x['g'] == True]
    self.isucll      = [x for x in self.data['calls']     if x['e'] == False and x['s'] == True  and x['g'] == False]
    self.isacll      = [x for x in self.data['calls']     if x['e'] == False and x['s'] == True  and x['g'] == True]
    self.eiucll      = [x for x in self.data['calls']     if x['e'] == True  and x['s'] == False and x['g'] == False]
    self.eiacll      = [x for x in self.data['calls']     if x['e'] == True  and x['s'] == False and x['g'] == True]
    self.esucll      = [x for x in self.data['calls']     if x['e'] == True  and x['s'] == True  and x['g'] == False]
    self.esacll      = [x for x in self.data['calls']     if x['e'] == True  and x['s'] == True  and x['g'] == True]
    self.iiuacc      = [x for x in self.data['fieldRefs'] if x['e'] == False and x['s'] == False and x['g'] == False]
    self.iiaacc      = [x for x in self.data['fieldRefs'] if x['e'] == False and x['s'] == False and x['g'] == True]
    self.isuacc      = [x for x in self.data['fieldRefs'] if x['e'] == False and x['s'] == True  and x['g'] == False]
    self.isaacc      = [x for x in self.data['fieldRefs'] if x['e'] == False and x['s'] == True  and x['g'] == True]
    self.eiuacc      = [x for x in self.data['fieldRefs'] if x['e'] == True  and x['s'] == False and x['g'] == False]
    self.eiaacc      = [x for x in self.data['fieldRefs'] if x['e'] == True  and x['s'] == False and x['g'] == True]
    self.esuacc      = [x for x in self.data['fieldRefs'] if x['e'] == True  and x['s'] == True  and x['g'] == True]
    self.esaacc      = [x for x in self.data['fieldRefs'] if x['e'] == True  and x['s'] == True  and x['g'] == True]
    self.npmth      = [nparms(x) for x in self.data['methods']]
    self.maxnpmth   = max(self.npmth)

    # Sanity checks
    if len(self.intan)  < 1: print('Warning: No class with CLE annotated elements found')
    if len(self.extan)  > 0: raise('External class cannot be CLE annotated')
    if len(self.eiafld) > 0: raise('External instance field cannot be CLE annotated')
    if len(self.esafld) > 0: raise('External class field cannot be CLE annotated')
    if len(self.eiamth) > 0: raise('External instance method cannot be CLE annotated')
    if len(self.esamth) > 0: raise('External class method cannot be CLE annotated')
    if len(self.eiacll) > 0: raise('External instance method callee cannot be CLE annotated')
    if len(self.esacll) > 0: raise('External class method callee cannot be CLE annotated')
    if len(self.eiaacc) > 0: raise('External instance field referenced cannot be CLE annotated')
    if len(self.esaacc) > 0: raise('External class field referenced cannot be CLE annotated')

    self.allInOrder    = [
      (self.intan,  'Class',  'Annotated',   'Internal', ''),
      (self.intun,  'Class',  'Unannotated', 'Internal', '' ),
      (self.extun,  'Class',  'Unannotated', 'External', ''),
      (self.iiafld, 'Field',  'Annotated',   'Internal', 'Instance'),
      (self.isafld, 'Field',  'Annotated',   'Internal', 'Static'),
      (self.iiamth, 'Method', 'Annotated',   'Internal', 'Instance'),
      (self.isamth, 'Method', 'Annotated',   'Internal', 'Static'),
      (self.iiufld, 'Field',  'Unannotated', 'Internal', 'Instance'),
      (self.isufld, 'Field',  'Unannotated', 'Internal', 'Static'),
      (self.iiumth, 'Method', 'Unannotated', 'Internal', 'Instance'),
      (self.isumth, 'Method', 'Unannotated', 'Internal', 'Static'),
      (self.eiufld, 'Field',  'Unannotated', 'External', 'Instance'),
      (self.esufld, 'Field',  'Unannotated', 'External', 'Static'),
      (self.eiumth, 'Method', 'Unannotated', 'External', 'Instance'),
      (self.esumth, 'Method', 'Unannotated', 'External', 'Static'),
      (self.iiacll, 'Call',   'Annotated',   'Internal', 'Instance'),
      (self.isacll, 'Call',   'Annotated',   'Internal', 'Static'),
      (self.iiucll, 'Call',   'Unannotated', 'Internal', 'Instance'),
      (self.isucll, 'Call',   'Unannotated', 'Internal', 'Static'),
      (self.eiucll, 'Call',   'Unannotated', 'External', 'Instance'),
      (self.esucll, 'Call',   'Unannotated', 'External', 'Static'),
      (self.iiaacc, 'Access', 'Annotated',   'Internal', 'Instance'),
      (self.isaacc, 'Access', 'Annotated',   'Internal', 'Static'),
      (self.iiuacc, 'Access', 'Unannotated', 'Internal', 'Instance'),
      (self.isuacc, 'Access', 'Unannotated', 'Internal', 'Static'),
      (self.eiuacc, 'Access', 'Unannotated', 'External', 'Instance'),
      (self.esuacc, 'Access', 'Unannotated', 'External', 'Static')
    ]

    # Assign sequential ID to all data items
    for u,v in enumerate([x for y,_,_,_,_ in self.allInOrder for x in y]): v['q'] = u + 1

    self.allClasses     = [x for x,y,_,_,_ in self.allInOrder if y == 'Class']
    self.allCalls       = [x for x,y,_,_,_ in self.allInOrder if y == 'Call']
    self.allFieldRefs   = [x for x,y,_,_,_ in self.allInOrder if y == 'Access']
    self.allElements    = [x for x,y,_,_,_ in self.allInOrder if y == 'Field' or y == 'Method']
    self.allNodes       = [x for x,y,_,_,_ in self.allInOrder if y == 'Class' or y == 'Field' or y == 'Method']
    self.allEdges       = [x for x,y,_,_,_ in self.allInOrder if y == 'Call'  or y == 'Access']
    self.allEdgesT      = [z for z         in self.allInOrder if z[1] == 'Call'  or z[1] == 'Access']
    self.annotElements  = [x for x,y,z,_,_ in self.allInOrder if z == 'Annotated' and (y == 'Field' or y == 'Method')]

    self.hasAnnotation  = [x['G'] for y in self.annotElements for x in y]
    self.hasClass       = [self.data['classes'][x['c']-1]['q'] for y in self.allNodes      for x in y]
    self.hasFrom        = [self.data['methods'][x['F']-1]['q'] for y in self.allEdges      for x in y]
    self.hasTo          = [self.data['methods'][x['T']-1]['q'] if z[1] == 'Call' else self.data['fields'][x['T']-1]['q'] 
                           for z in self.allEdgesT for x in z[0]]
    
    self.clusters        = {}
    self.clustref        = {}
    self.clusterEdges    = set()
    self.coarsen_graph() # Coarsen graph and fill self.clusters, self.clustref, self.clusterEdges 
    self.clusterCount    = len(self.clusters)
    self.hasClusterFrom  = [e[0] for e in self.clusterEdges]
    self.hasClusterTo    = [e[1] for e in self.clusterEdges]

  def write_debug_csv(self,oup):
    csvw = csv.writer(oup)
    csvw.writerow(['mznid','cat','catid','name','class','felement','fclass','telement','tclass','static','external','label'])
    for y,cat,ann,ext,sta in self.allInOrder:
      carr = self.data['classes']
      farr = self.data['methods']
      tarr = self.data['fields'] if cat == 'Access' else self.data['methods']
      csvw.writerows([
        [x['q'],
         cat,
         x['i'],
         x['n'] if 'n' in x else '',
         carr[x['c']-1]['n']              if 'c' in x else '',
         farr[x['F']-1]['n']              if 'F' in x else '',
         carr[farr[x['F']-1]['c']-1]['n'] if 'F' in x else '',
         tarr[x['T']-1]['n']              if 'T' in x else '',
         carr[tarr[x['T']-1]['c']-1]['n'] if 'T' in x else '',
         sta,
         ext,
         ann,
         x['G'] if 'G' in x and x['G'] is not None else ''] for x in y])

  def write_model_mzn(self,oup):
    oup.write('%s=%s;\n' % ('MaxFuncParms',self.maxnpmth))

    accum = 0
    for y0,y1,y2,y3,y4 in self.allInOrder:
      x = y2 + y3 + y4 + y1 
      accum =  accum + 1
      oup.write('%s_start=%s;\n' % (x, accum))
      accum =  accum + len(y0) - 1
      oup.write('%s_end=%s;\n'   % (x, accum))

    for (x,y,z) in [
      ('hasAnnotation', list(map(fix,self.hasAnnotation)), 'AnnotatedElement'),
      ('hasClass',      self.hasClass,                     'Node'),
      ('hasFrom',       self.hasFrom,                      'Edge' ),
      ('hasTo',         self.hasTo,                        'Edge'),
      ('hasClusterFrom',self.hasClusterFrom,               'ClusterEdge'),
      ('hasClusterTo',  self.hasClusterTo,                 'ClusterEdge'),
    ]:
      oup.write('%s=array1d(%s,[\n%s\n]);\n' % (x,z,brklns(y, 10)))

    # XXX: need to differentiate nodes and edges
    oup.write('ClusterNodes_start=1;\n')
    oup.write('ClusterNodes_end=%s;\n'   % self.clusterCount)
    oup.write('ClusterEdges_start=%s;\n' % (self.clusterCount + 1))
    oup.write('ClusterEdges_end= %s;\n'  % (self.clusterCount + len(self.clusterEdges)))

  def edgen(self,exclude_external):
    # y: all edges of type cat; cat: call or access; ann: annotated?; ext: external to APK?; sta: static?
    for y,cat,ann,ext,sta in self.allEdgesT:
      if exclude_external == True and ext == 'External': continue
      for x in y:
        # endpoints: fe->te, corresponding classes of endpoints: fc->tc
        fe = self.data['methods'][x['F']-1]
        te = self.data['methods'][x['T']-1] if cat == 'Call' else self.data['fields'][x['T']-1] 
        fc = self.data['classes'][fe['c']-1]
        tc = self.data['classes'][te['c']-1]
        # use endpoints if annotated, else use class 
        fq,f = (fe['q'],fe) if fe['g'] else (fc['q'],fc)
        tq,t = (te['q'],te) if te['g'] else (tc['q'],tc)
        yield fq,f,fc,tq,t,tc,cat,ann,ext,sta

  def coarsen_graph(self):
    excext = False     # whether external nodes/edges are to be included, make command-line option? 
    G = nx.DiGraph()
    for fq,f,fc,tq,t,tc,cat,ann,ext,sta in self.edgen(excext):
      # add endpoints as nodes of G, and add edge if both endpoints are in unannotated classes 
      G.add_node(fq)
      G.add_node(tq)
      if not fc['g'] and not tc['g']: G.add_edge(fq,tq)
    components = sorted(nx.weakly_connected_components(G), key=len, reverse=True)

    # for each component Y, assign a cluster ID C, and for each member X of Y, associate cluster ID C
    # keep a dict of edges by from,to,cat,ext,sta, and deduplicate edges
    self.clusters     = {i+1 : [(n,self.hasClass[n-1]) for n in c] for i,c in enumerate(components)}
    self.clustref     = {n:i+1 for i,c in enumerate(components) for n in c}
    self.clusterEdges = set([(self.clustref[fq],self.clustref[tq],cat) 
                              for fq,f,fc,tq,t,tc,cat,ann,ext,sta in self.edgen(excext) if self.clustref[fq] != self.clustref[tq]])
    '''
    print ('Nodes:',           G.number_of_nodes())
    print ('Edges:',           G.number_of_edges())
    print ('Nodes clustered:', sum([len(c) for c in components]))
    print ('ClusterNodes:',    len(components))
    print ('ClusterEdges:',    len(self.clusterEdges))
    print ('ClusterEdges list:')
    print (brklns(list(self.clusterEdges),10))
    for i in self.clusters:
      print ('Component %d [%d nodes] contains (node, class):' % (i,len(self.clusters[i])))
      print (brklns(self.clusters[i],10))
    '''

  def write_cluster_dot(self,fname):
    ClusterG = nx.DiGraph()
    for i,c in self.clusters.items():
      lnc = len(c)
      lbl = '[%d[%d]]\n'%(i,lnc) + ''.join(['%d(%d),\n'%(x,xc) for x,xc in c[:10]]) + ('...\n' if lnc > 10 else '')
      ClusterG.add_node(i, {"xlabel" : lbl})
    for e in self.clusterEdges:
      ClusterG.add_edge(e[0],e[1])
    write_dot(ClusterG,fname)

if __name__ == '__main__':
  logger = logging.getLogger()
  logger.addHandler(logging.StreamHandler(sys.stderr))
  logger.setLevel(logging.WARN)
  args = get_args()
  if not os.path.exists(args.output_dir):                            os.makedirs(args.output_dir)
  print('Loading model ...')
  with gzip.open(args.input_model, 'rt') as minp:                    mdl = Model(esatrack(json.load(minp)))
  print('Loaded model and coarsened graph')
  with open(args.cle_json, 'r') as cinp:                             cmz = compute_zinc(annotsplit(json.load(cinp)), mdl.maxnpmth, logger)
  print('Loaded cle, now writing data instances ...')
  with open(args.output_dir + '/pdg_instance.mzn', 'w') as moup:     mdl.write_model_mzn(moup)
  with open(args.output_dir + '/cle_instance.mzn', 'w') as coup:     coup.write(cmz.cle_instance)
  with open(args.output_dir + '/enclave_instance.mzn', 'w') as eoup: eoup.write(cmz.enclave_instance)
  mdl.write_cluster_dot(args.output_dir + '/cluster.dot')
  print('Wrote data instances')
  if args.debug:
    print('Writing debug file ...')
    with gzip.open(args.output_dir + '/pdg.csv.gz', 'wt') as csvp:    mdl.write_debug_csv(csvp)
    print('Wrote debug file')

