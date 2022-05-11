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

def nparms(x): return 0 if 'p' not in x else len(x['p']) 

def brklns(arr,n):
  chunks = [map(str,arr[i:i+n]) for i in range(0, len(arr), n)]
  return '\n'.join([','.join(c)+',' for c in chunks])

def esatrack(data):
  if 'classes'   not in data: data['classes'] = []
  if 'fields'    not in data: data['fields'] = []
  if 'methods'   not in data: data['methods'] = []
  if 'calls'     not in data: data['calls'] = []
  if 'fieldRefs' not in data: data['fieldRefs'] = []
  for x in data['classes']:
    x['e'] = True if 'e' in x and x['e'] == True else False
    x['g'] = False
  for x in data['fields']:
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
  for x in data['methods']:
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
      self.intan,  self.intun,  self.extun, 
      self.iiafld, self.iiufld, self.eiufld, self.isafld, self.isufld, self.esufld, 
      self.iiamth, self.iiumth, self.eiumth, self.isamth, self.isumth, self.esumth,
      self.iicll,  self.iscll,  self.eicll,  self.escll,
      self.iiacc,  self.isacc,  self.eiacc,  self.esacc
    ]

    self.allElements   = [
      self.iiafld, self.iiufld, self.eiufld, self.isafld, self.isufld, self.esufld, 
      self.iiamth, self.iiumth, self.eiumth, self.isamth, self.isumth, self.esumth
    ]

    self.allClasses    = [ self.intan,  self.intun,  self.extun ]
    self.allFields     = [ self.iiafld, self.iiufld, self.eiufld, self.isafld, self.isufld, self.esufld ]
    self.allMethods    = [ self.iiamth, self.iiumth, self.eiumth, self.isamth, self.isumth, self.esumth ]
    self.allCalls      = [ self.iicll, self.iscll, self.eicll, self.escll ]
    self.allFieldRefs  = [ self.iiacc, self.isacc, self.eiacc, self.esacc ]
    self.annotElements = [ self.iiafld, self.isafld, self.iiamth, self.isamth ]

    # Assign sequential ID to all data items
    for u,v in enumerate([x for y in self.allInOrder for x in y]): v['q'] = u + 1

    self.hasClass   = [self.data['classes'][x['c']-1]['q'] for y in self.allElements   for x in y]
    self.hasCaller  = [self.data['methods'][x['F']-1]['q'] for y in self.allCalls      for x in y]
    self.hasCallee  = [self.data['methods'][x['T']-1]['q'] for y in self.allCalls      for x in y]
    self.fromMethod = [self.data['methods'][x['F']-1]['q'] for y in self.allFieldRefs  for x in y]
    self.toField    = [self.data['fields'][x['T']-1]['q']  for y in self.allFieldRefs  for x in y]
    self.userAnnElt = [(x['q'], x['G'])                    for y in self.annotElements for x in y]

  def write_debug_csv(self,oup):
    def mkrec(x,cat,carr,farr,tarr):
      return list([x['q'],
                   cat,
                   x['i'],
                   x['n'] if 'n' in x else '',
                   carr[x['c']-1]['n']              if 'c' in x else '',
                   farr[x['F']-1]['n']              if 'F' in x else '',
                   carr[farr[x['F']-1]['c']-1]['n'] if 'F' in x else '',
                   tarr[x['T']-1]['n']              if 'T' in x else '',
                   carr[tarr[x['T']-1]['c']-1]['n'] if 'T' in x else '',
                   'static' if 's' in x and x['s'] is True else '',
                   'external' if x['e'] is True else '',
                   x['G'] if 'G' in x and x['G'] is not None else ''])

    csvw = csv.writer(oup)
    csvw.writerow(['mznid','cat','catid','name','class','felement','fclass','telement','tclass','static','external','label'])

    for y,cat,carr,farr,tarr in [
      (self.allClasses,   'Class',  self.data['classes'], [], []),
      (self.allFields,    'Field',  self.data['classes'], [], []),
      (self.allMethods,   'Method', self.data['classes'], [], []),
      (self.allCalls,     'Call',   self.data['classes'], self.data['methods'], self.data['methods']),
      (self.allFieldRefs, 'Access', self.data['classes'], self.data['methods'], self.data['fields']),
    ]:
      for z in y:
        for x in z: csvw.writerow(mkrec(x,cat,carr,farr,tarr))

  def write_model_mzn(self,oup):
    # Calculate variables for MiniZinc, maintaining same order
    MaxFuncParms                     = self.maxnpmth
    Annotated_start                  = 1
    Annotated_end                    = Annotated_start                 + len(self.intan) - 1
    Unannotated_start                = Annotated_end                   + 1
    Unannotated_end                  = Unannotated_start               + len(self.intun) - 1
    External_start                   = Unannotated_end                 + 1
    External_end                     = External_start                  + len(self.extun) - 1
    AnnotatedInstanceField_start     = External_end                    + 1
    AnnotatedInstanceField_end       = AnnotatedInstanceField_start    + len(self.iiafld) - 1
    UnannotatedInstanceField_start   = AnnotatedInstanceField_end      + 1
    UnannotatedInstanceField_end     = UnannotatedInstanceField_start  + len(self.iiufld) - 1
    ExternalInstanceField_start      = UnannotatedInstanceField_end    + 1
    ExternalInstanceField_end        = ExternalInstanceField_start     + len(self.eiufld) - 1
    AnnotatedClassField_start        = ExternalInstanceField_end       + 1
    AnnotatedClassField_end          = AnnotatedClassField_start       + len(self.isafld) - 1
    UnannotatedClassField_start      = AnnotatedClassField_end         + 1
    UnannotatedClassField_end        = UnannotatedClassField_start     + len(self.isufld) - 1
    ExternalClassField_start         = UnannotatedClassField_end       + 1
    ExternalClassField_end           = ExternalClassField_start        + len(self.esufld) - 1
    AnnotatedInstanceMethod_start    = ExternalClassField_end          + 1
    AnnotatedInstanceMethod_end      = AnnotatedInstanceMethod_start   + len(self.iiamth) - 1
    UnannotatedInstanceMethod_start  = AnnotatedInstanceMethod_end     + 1
    UnannotatedInstanceMethod_end    = UnannotatedInstanceMethod_start + len(self.iiumth) - 1
    ExternalInstanceMethod_start     = UnannotatedInstanceMethod_end   + 1
    ExternalInstanceMethod_end       = ExternalInstanceMethod_start    + len(self.eiumth) - 1
    AnnotatedClassMethod_start       = ExternalInstanceMethod_end      + 1
    AnnotatedClassMethod_end         = AnnotatedClassMethod_start      + len(self.isamth) - 1
    UnannotatedClassMethod_start     = AnnotatedClassMethod_end        + 1
    UnannotatedClassMethod_end       = UnannotatedClassMethod_start    + len(self.isumth) - 1
    ExternalClassMethod_start        = UnannotatedClassMethod_end      + 1
    ExternalClassMethod_end          = ExternalClassMethod_start       + len(self.esumth) - 1
    InternalInstanceCall_start       = ExternalClassMethod_end         + 1
    InternalInstanceCall_end         = InternalInstanceCall_start      + len(self.iicll) - 1
    InternalStaticCall_start         = InternalInstanceCall_end        + 1
    InternalStaticCall_end           = InternalStaticCall_start        + len(self.iscll) - 1
    ExternalInstanceCall_start       = InternalStaticCall_end          + 1
    ExternalInstanceCall_end         = ExternalInstanceCall_start      + len(self.eicll) - 1
    ExternalStaticCall_start         = ExternalInstanceCall_end        + 1
    ExternalStaticCall_end           = ExternalStaticCall_start        + len(self.escll) - 1
    InternalInstanceAccess_start     = ExternalStaticCall_end          + 1
    InternalInstanceAccess_end       = InternalInstanceAccess_start    + len(self.iiacc) - 1
    InternalStaticAccess_start       = InternalInstanceAccess_end      + 1
    InternalStaticAccess_end         = InternalStaticAccess_start      + len(self.isacc) - 1
    ExternalInstanceAccess_start     = InternalStaticAccess_end        + 1
    ExternalInstanceAccess_end       = ExternalInstanceAccess_start    + len(self.eiacc) - 1
    ExternalStaticAccess_start       = ExternalInstanceAccess_end      + 1
    ExternalStaticAccess_end         = ExternalStaticAccess_start      + len(self.esacc) - 1
    Class_start                      = Annotated_start
    Class_end                        = External_end
    InstanceField_start              = AnnotatedInstanceField_start
    InstanceField_end                = ExternalInstanceField_end
    ClassField_start                 = AnnotatedClassField_start
    ClassField_end                   = ExternalClassField_end
    Field_start                      = InstanceField_start
    Field_end                        = ClassField_end
    InstanceMethod_start             = AnnotatedInstanceMethod_start
    InstanceMethod_end               = ExternalInstanceMethod_end
    ClassMethod_start                = AnnotatedClassMethod_start
    ClassMethod_end                  = ExternalClassMethod_end
    Method_start                     = InstanceMethod_start
    Method_end                       = ClassMethod_end
    Element_start                    = Field_start
    Element_end                      = Method_end
    Node_start                       = Class_start
    Node_end                         = Element_end
    Call_start                       = InternalInstanceCall_start
    Call_end                         = ExternalStaticCall_end
    Access_start                     = InternalInstanceAccess_start
    Access_end                       = ExternalStaticAccess_end
    Edge_start                       = Call_start
    Edge_end                         = Access_end

    # Write MiniZinc file
    for x in [
      'MaxFuncParms',
      'Annotated_start',                 'Annotated_end', 
      'Unannotated_start',               'Unannotated_end',
      'External_start',                  'External_end',
      'AnnotatedInstanceField_start',    'AnnotatedInstanceField_end',
      'UnannotatedInstanceField_start',  'UnannotatedInstanceField_end',
      'ExternalInstanceField_start',     'ExternalInstanceField_end',
      'AnnotatedClassField_start',       'AnnotatedClassField_end',
      'UnannotatedClassField_start',     'UnannotatedClassField_end',
      'ExternalClassField_start',        'ExternalClassField_end',
      'AnnotatedInstanceMethod_start',   'AnnotatedInstanceMethod_end',
      'UnannotatedInstanceMethod_start', 'UnannotatedInstanceMethod_end',
      'ExternalInstanceMethod_start',    'ExternalInstanceMethod_end',
      'AnnotatedClassMethod_start',      'AnnotatedClassMethod_end',
      'UnannotatedClassMethod_start',    'UnannotatedClassMethod_end',
      'ExternalClassMethod_start',       'ExternalClassMethod_end',
      'InternalInstanceCall_start',      'InternalInstanceCall_end',
      'InternalStaticCall_start',        'InternalStaticCall_end',
      'ExternalInstanceCall_start',      'ExternalInstanceCall_end',
      'ExternalStaticCall_start',        'ExternalStaticCall_end',
      'InternalInstanceAccess_start',    'InternalInstanceAccess_end',
      'InternalStaticAccess_start',      'InternalStaticAccess_end',
      'ExternalInstanceAccess_start',    'ExternalInstanceAccess_end',
      'ExternalStaticAccess_start',      'ExternalStaticAccess_end',
      'Class_start',                     'Class_end',
      'InstanceField_start',             'InstanceField_end',
      'ClassField_start',                'ClassField_end',
      'Field_start',                     'Field_end',
      'InstanceMethod_start',            'InstanceMethod_end',
      'ClassMethod_start',               'ClassMethod_end',
      'Method_start',                    'Method_end',
      'Element_start',                   'Element_end',
      'Node_start',                      'Node_end',
      'Call_start',                      'Call_end',
      'Access_start',                    'Access_end',
      'Edge_start',                      'Edge_end'
    ]:
      oup.write('%s=%s;\n' % (x,locals()[x]))

    for (x,y,z) in [
      ('hasClass',   self.hasClass,   'Element'),
      ('hasCaller',  self.hasCaller,  'Call' ),
      ('hasCallee',  self.hasCallee,  'Call'),
      ('fromMethod', self.fromMethod, 'Access'),
      ('toField',    self.toField,    'Access')
    ]:
      oup.write('%s=array1d(%s,[\n%s\n]);\n' % (x,z,brklns(y, 10)))

    for (x,y) in mdl.userAnnElt:
      z = fix(y)
      oup.write('constraint :: "AnnotateOn%s" labelAtLevel[%s,hasLabelLevel[%s]] = %s;\n' % (x,x,z,z))
      oup.write('constraint :: "ProhibitOn%s" forall (l in Level where l != hasLabelLevel[%s]) (labelAtLevel[%s,l] = nullCleLabel);\n' % (x,z,x))

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

def get_args():
  p = ArgumentParser(description='Constraint Instance Data Encoder')
  p.add_argument('-i', '--input_model', required=True, type=str, help='Gzipped Input Program Model JSON file')
  p.add_argument('-c', '--cle_json', required=True, type=str, help='Input Program Model JSON file')
  p.add_argument('-o', '--output_dir', required=False, default='./instance', type=str, help='Output Model MZN file')
  return p.parse_args()

if __name__ == '__main__':
  logger = logging.getLogger()
  logger.addHandler(logging.StreamHandler(sys.stderr))
  logger.setLevel(logging.WARN)
  args   = get_args()
  with gzip.open(args.input_model, 'rt') as minp:
    mdl  = Model(esatrack(json.load(minp)))
  with open(args.cle_json, 'r') as cinp:
    cmz = compute_zinc(annotsplit(json.load(cinp)), mdl.maxnpmth, logger)
  if not os.path.exists(args.output_dir):
    os.makedirs(args.output_dir)
  with open(args.output_dir + '/pdg_instance.mzn', 'w') as moup:
    mdl.write_model_mzn(moup)
  with open(args.output_dir + '/cle_instance.mzn', 'w') as coup:
    coup.write(cmz.cle_instance)
  with open(args.output_dir + '/enclave_instance.mzn', 'w') as eoup:
    eoup.write(cmz.enclave_instance)
  with gzip.open(args.output_dir + '/pdg.csv.gz', 'wt') as csvp:
    mdl.write_debug_csv(csvp)

