#!/usr/bin/python3
import os
import os.path
import sys
import csv
import json
import gzip
import logging
from   argparse import ArgumentParser
from   cle2zinc import compute_zinc

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
  for x in data['fieldRefs']:
    if data['methods'][x['F']-1]['e'] == True: raise ('External method cannot be caller')
    x['e'] = data['fields'][x['T']-1]['e']
    x['s'] = data['fields'][x['T']-1]['s']
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
    self.iicll      = [x for x in self.data['calls']     if x['e'] == False and x['s'] == False]
    self.iscll      = [x for x in self.data['calls']     if x['e'] == False and x['s'] == True ]
    self.eicll      = [x for x in self.data['calls']     if x['e'] == True  and x['s'] == False]
    self.escll      = [x for x in self.data['calls']     if x['e'] == True  and x['s'] == True ]
    self.iiacc      = [x for x in self.data['fieldRefs'] if x['e'] == False and x['s'] == False]
    self.isacc      = [x for x in self.data['fieldRefs'] if x['e'] == False and x['s'] == True ]
    self.eiacc      = [x for x in self.data['fieldRefs'] if x['e'] == True  and x['s'] == False]
    self.esacc      = [x for x in self.data['fieldRefs'] if x['e'] == True  and x['s'] == True ]
    self.npmth      = [nparms(x) for x in data['methods']]
    self.maxnpmth   = max(self.npmth)

    # Sanity checks
    if len(self.intan)  < 1: print('Warning: No class with CLE annotated elements found')
    if len(self.extan)  > 0: raise('External class cannot be CLE annotated')
    if len(self.eiafld) > 0: raise('External instance field cannot be CLE annotated')
    if len(self.esafld) > 0: raise('External class field cannot be CLE annotated')
    if len(self.eiamth) > 0: raise('External instance method cannot be CLE annotated')
    if len(self.esamth) > 0: raise('External class method cannot be CLE annotated')

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
      (self.iicll,  'Call',   '',            'Internal', 'Instance'),
      (self.iscll,  'Call',   '',            'Internal', 'Static'),
      (self.eicll,  'Call',   '',            'External', 'Instance'),
      (self.escll,  'Call',   '',            'External', 'Static'),
      (self.iiacc,  'Access', '',            'Internal', 'Instance'),
      (self.isacc,  'Access', '',            'Internal', 'Static'),
      (self.eiacc,  'Access', '',            'External', 'Instance'),
      (self.esacc,  'Access', '',            'External', 'Static'),
    ]

    # Assign sequential ID to all data items
    for u,v in enumerate([x for y,_,_,_,_ in self.allInOrder for x in y]): v['q'] = u + 1

    self.allClasses    = [x for x,y,_,_,_ in self.allInOrder if y == 'Class']
    self.allCalls      = [x for x,y,_,_,_ in self.allInOrder if y == 'Call']
    self.allFieldRefs  = [x for x,y,_,_,_ in self.allInOrder if y == 'Access']
    self.allElements   = [x for x,y,_,_,_ in self.allInOrder if y == 'Field' or y == 'Method']
    self.allNodes      = [x for x,y,_,_,_ in self.allInOrder if y == 'Class' or y == 'Field' or y == 'Method']
    self.allEdges      = [x for x,y,_,_,_ in self.allInOrder if y == 'Call'  or y == 'Access']
    self.allEdgesT     = [z for z         in self.allInOrder if z[1] == 'Call'  or z[1] == 'Access']
    self.annotElements = [x for x,y,z,_,_ in self.allInOrder if z == 'Annotated' and (y == 'Field' or y == 'Method')]

    self.hasAnnotation = [x['G'] for y in self.annotElements for x in y]
    self.hasClass      = [self.data['classes'][x['c']-1]['q'] for y in self.allNodes      for x in y]
    self.hasFrom       = [self.data['methods'][x['F']-1]['q'] for y in self.allEdges      for x in y]
    self.hasTo         = [self.data['methods'][x['T']-1]['q'] if z[1] == 'Call' else self.data['fields'][x['T']-1]['q'] 
                          for z in self.allEdgesT for x in z[0]]
    

    # self.colapscals    = {self.collaps(x,False):1             for y in self.allCalls      for x in y}
    # self.colapsrefs    = {self.collaps(x,True):1              for y in self.allFieldRefs  for x in y}

  def collaps(self, x, isref):
    f  = self.data['methods'][x['F']-1]
    fc = self.data['classes'][f['c']-1]
    t  = self.data['fields'][x['T']-1] if isref else self.data['methods'][x['T']-1] 
    tc = self.data['classes'][t['c']-1]
    return (f['q'] if f['g'] else fc['q'], t['q'] if t['g'] else tc['q'], x['s'], x['e'])

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

    oup.write('ClusterNodes_start=1;\n')
    oup.write('ClusterNodes_end=%s;\n' % self.clusterNodeCount)
    oup.write('ClusterEdges_start=%s;\n' %(self.clusterNodeCount + 1))
    oup.write('ClusterEdges_end= %s;\n' %  (self.clusterNodeCount + len(self.clusterEdges)))

  def coarsen_graph(self):
    import networkx as nx
    from networkx.drawing.nx_pydot import write_dot
    G = nx.DiGraph()
    ClusterG = nx.DiGraph()
    edges = {}
    clust = {}
    nrefs = {}
    clusterEdges = []
    clusterNodes = []
    self.dbg_componentClass = {}
    count = 0
    # y contains all edges of type cat
    # cat is either call or access
    # ann is the annotation
    # ext is a boolean for external
    # sta is a boolean for static
    for y,cat,ann,ext,sta in self.allEdgesT:
      for x in y:
        # endpoints
        #from edge
        fe = self.data['methods'][x['F']-1]
        #to edge
        te = self.data['methods'][x['T']-1] if cat == 'Call' else self.data['fields'][x['T']-1] 
        # classes of endpoints
        #from edge
        fc = self.data['classes'][fe['c']-1]
        #to edge
        tc = self.data['classes'][te['c']-1]
        # use endpoints if class is annotated, else use class 
        fq,f = (fe['q'],fe) if fc['g'] else (fc['q'],fc)
        tq,t = (te['q'],te) if tc['g'] else (tc['q'],tc)
        # put node in dict for access by ID
        # if fq not in nrefs and not fc['e']: 
        if fq not in nrefs:
          nrefs[fq] = f
          G.add_node(fq)
          clusterNodes.append(fq)
        #if tq not in nrefs and not tc['e']: 
        if tq not in nrefs:
          nrefs[tq] = t
          G.add_node(tq)
          clusterNodes.append(tq)
        # connect clusters if both endpoints are from unannotated classes 
        # XXX: exclude externals, make this an option 
        # tc['e'] means to class external
        #if not fc['g'] and not tc['g'] and not tc['e']: 
        if not fc['g'] and not tc['g']:
          G.add_edge(fq,tq)
        # since we are only making edges to unannotated classes, nodes of size 1 can be individual annotated elements


        # XXX: keep edges if at least one end point is annotated
        # XXX: collapse edges by category

        #count = count + 1
        #if count % 10000 == 0: print('ecount:', count,'ncount:',len(clust))

    print ('Nodes:', G.number_of_nodes())
    print ('Edges:', G.number_of_edges())
    components = nx.weakly_connected_components(G)

    componentID = 1

    #Assign each node a cluster
    for c in sorted(components, key=len, reverse=True):
      for node in c:
        classOfNode = self.hasClass[node]
        # print(f"Node Class: {classOfNode}")
        if componentID in self.dbg_componentClass:
          self.dbg_componentClass[componentID].append(classOfNode)
        else:
          self.dbg_componentClass[componentID] = [classOfNode]

        nrefs[node]["Component"] = componentID
        clust[node] = componentID
      # ClusterG.add_node(componentID)
      classIDStr = "[[" + str(componentID) + "]]\n"
      for i in self.dbg_componentClass[componentID][:10]:
        classIDStr += (str(i) + "\n")  
      if len(self.dbg_componentClass[componentID]) > 10:
        classIDStr += "... \n"

      ClusterG.add_node(componentID,   {"xlabel" : classIDStr})
      componentID += 1
      
    self.clusterNodeCount = componentID-1
    self.clusterEdges = set()
    cluseterSeenType = {}
    count = 0
    for y,cat,ann,ext,sta in self.allEdgesT:
      for x in y:
        # endpoints
        #from edge
        fe = self.data['methods'][x['F']-1]
        #to edge
        te = self.data['methods'][x['T']-1] if cat == 'Call' else self.data['fields'][x['T']-1] 
        fc = self.data['classes'][fe['c']-1]
        #to edge
        tc = self.data['classes'][te['c']-1]
        # use endpoints if class is annotated, else use class 
        fq,f = (fe['q'],fe) if fc['g'] else (fc['q'],fc)
        tq,t = (te['q'],te) if tc['g'] else (tc['q'],tc)
        # edge = (fe['q'],te['q'])
        clusterEdge = (nrefs[fq]['Component'],nrefs[tq]['Component'])
        if clusterEdge[0] != clusterEdge[1]:
          if  clusterEdge in cluseterSeenType:
            if not cat in cluseterSeenType[clusterEdge]:
              self.clusterEdges.add(clusterEdge)
              cluseterSeenType[clusterEdge].append(cat)
          else:
            self.clusterEdges.add(clusterEdge)
            cluseterSeenType[clusterEdge] = [cat]


    
    self.hasClusterFrom = []
    self.hasClusterTo = []
    for edge in self.clusterEdges:
      self.hasClusterFrom.append(edge[0])
      self.hasClusterTo.append(edge[1])
      ClusterG.add_edge(edge[0],edge[1])

 

    # for n in clust:
    #   print(f"Node: {n} in cluster: {clust[n]}")
    
    print ('Num ClusterNodes: ', self.clusterNodeCount)
    print ('Num ClusterEdges: ', len(self.clusterEdges))
    print ('ClusterEdges: ', self.clusterEdges)
    for cmpId in self.dbg_componentClass:
      print (f"Component: {cmpId} has the following classes: {self.dbg_componentClass[cmpId]} ")

    write_dot(ClusterG,"cluster.dot")
    # for each component Y, assign a cluster ID C, and for each member X of Y clust[X] = C
    # keep a dict of edges by from,to,cat,ext,sta, and deduplicate edges
    # add collapsed graph node and edges to minizinc model
    print ('Total nodes in components:', sum([len(c) for c in sorted(nx.weakly_connected_components(G), key=len, reverse=True)]))

if __name__ == '__main__':
  logger = logging.getLogger()
  logger.addHandler(logging.StreamHandler(sys.stderr))
  logger.setLevel(logging.WARN)
  args   = get_args()
  print('Loading model ...')
  with gzip.open(args.input_model, 'rt') as minp:
    mdl  = Model(esatrack(json.load(minp)))
  print('Loaded model')
  with open(args.cle_json, 'r') as cinp:
    cmz = compute_zinc(annotsplit(json.load(cinp)), mdl.maxnpmth, logger)
  print('Loaded cle')
  print('Writing data instances ...')
  if not os.path.exists(args.output_dir):
    os.makedirs(args.output_dir)
  with open(args.output_dir + '/cle_instance.mzn', 'w') as coup:
    coup.write(cmz.cle_instance)
  with open(args.output_dir + '/enclave_instance.mzn', 'w') as eoup:
    eoup.write(cmz.enclave_instance)
  print('Wrote data instances')

  if args.debug:
    print('Writing debug file ...')
    with gzip.open(args.output_dir + '/pdg.csv.gz', 'wt') as csvp:
      mdl.write_debug_csv(csvp)
    print('Wrote debug file')

  print('Placeholder for coarsening graph')
  mdl.coarsen_graph()

  with open(args.output_dir + '/pdg_instance.mzn', 'w') as moup:
    mdl.write_model_mzn(moup)
