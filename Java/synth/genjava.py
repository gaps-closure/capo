#!/usr/bin/python3
import os
import json
import math
import time
import shutil
import random                    as     r
import numpy.random              as     nr
import networkx                  as     nx
from   dataclasses               import dataclass
from   networkx.generators       import random_tree
from   networkx.drawing.nx_pydot import write_dot

@dataclass
class JGenSpec:
  pkgprefix:     str       # Package prefix to use
  rseed:         int       # Seed for random generator
  nclasses:      int       # Number of classes to generate
  primtypes:     [str]     # primitive data types plus string
  fprim_freq:    [float]   # Probability vector of field types for elements in primtypes 
  pprim_freq:    [float]   # Probability vector of method parameter types for elements in primtypes
  rprim_freq:    [float]   # Probability vector of method return types for elements in primtypes
  class_a_mods:  [str]     # Access modifiers for class
  class_a_freq:  [float]   # Probability vector for access modifiers for class 
  field_a_mods:  [str]     # Access modifiers for fields
  field_a_freq:  [float]   # Probability vector for access modifiers for field
  method_a_mods: [str]     # Access modifiers for methods
  method_a_freq: [float]   # Probability vector for access modifiers for method 
  mprob:         float     # Probability that class element is a method vs. field
  mstaticprob:   float     # Probability that a method is a static class method
  fstaticprob:   float     # Probability that a field is a static class field
  farrayprob:    float     # Probability that a field is an array (vs. scalar)
  fclassprob:    float     # Probability that a field is a class (vs. primitive type or string)
  parrayprob:    float     # Probability that a parameter is an array (vs. scalar)
  pclassprob:    float     # Probability that a parameter is a class (vs. primitive or string)
  rarrayprob:    float     # Probability that a return type is an array (vs. scalar)
  rclassprob:    float     # Probability that a return type is a class (vs. primitive or string)
  meanparms:     float     # Mean number of parameters in a method
  maxparms:      float     # Maximum number of parameters in a method
  meanelts:      float     # Mean number of elements in a base class 
  maxelts:       float     # Maximum number of elements in a base class 
  fubars:        [str]     # Names of formal parameters
  nouns:         [str]     # Nouns to choose from for class and field names
  adjectives:    [str]     # Adjectives to choose from for class names
  verbs:         [str]     # Verbs to choose from for method names
  adverbs:       [str]     # Adverbs to choose from for method names
  genclasses:    [str]     # Generated classes

  def set_rseed(self, use_time=False): 
    s = int(time.time()) if use_time else self.rseed
    self.rseed = s
    nr.seed(s)
    r.seed(s)

  def update(self, w):
    for k,v in w.items():
      if hasattr(self, k): setattr(self, k, v)

##############################################################################################
def pick(wl,capitalize=True): 
  return r.choice(wl).capitalize() if capitalize else r.choice(wl)

def pick_type(primflds, allclasses, primfreq, classprob, arrayprob):
  assert(classprob >= 0.0 and classprob <= 1.0)
  assert(arrayprob >= 0.0 and arrayprob <= 1.0)
  assert(len(primflds) == len(primfreq))
  assert(sum(primfreq) == 1.0)
  assert(len(primflds) > 0)
  ft = r.choice(allclasses) if r.random() < classprob else nr.choice(primflds, 1, p = primfreq)[0]
  ar = '[]' if r.random() < arrayprob else ''
  return ft + ar

def pick_access(mods, modfreq):
  assert(len(mods) == len(modfreq))
  assert(sum(modfreq) == 1.0)
  assert(len(mods) > 0)
  return nr.choice(mods, 1, modfreq)[0]

def pick_field_name(j):    return 'f' + pick(j.nouns)
def pick_subcl_name(j,cn): return pick(j.adjectives) + cn
def pick_method_name(j):   return pick(j.verbs,False) + pick(j.adverbs)
def pick_class_name(j):    return pick(j.nouns)
def pick_field_type(j):    return pick_type(j.primtypes, j.genclasses, j.fprim_freq, j.fclassprob, j.farrayprob)
def pick_return_type(j):   return pick_type(j.primtypes, j.genclasses, j.rprim_freq, j.rclassprob, j.rarrayprob)
def pick_param_type(j):    return pick_type(j.primtypes, j.genclasses, j.pprim_freq, j.pclassprob, j.parrayprob)
def pick_class_access(j):  return pick_access(j.class_a_mods, j.class_a_freq)
def pick_field_access(j):  return pick_access(j.field_a_mods, j.field_a_freq)
def pick_method_access(j): return pick_access(j.method_a_mods, j.method_a_freq)
def pick_field_static(j):  return 'static' if r.random() < j.fstaticprob else ''
def pick_method_static(j): return 'static' if r.random() < j.mstaticprob else ''
def sne(x):                return '' if x=='' else x + ' '

def make_cl_hierarchy(j, expdot=False):
  dedup = {}
  t = random_tree(j.nclasses + 1, seed=j.rseed, create_using=nx.DiGraph)
  if expdot: write_dot(t, 'foo.dot')
  cls = {}
  for y,x in nx.dfs_edges(t, source=0):
    par = y
    cld = [k[1] for k in t.out_edges(x)] 
    while True:
      cn = pick_class_name(j) if par == 0 else pick_subcl_name(j,cls[par]['cn'])
      if cn not in dedup: 
        dedup[cn] = 1
        break
      else: continue
    cls[x] = dict(par=par, cld=cld, cn=cn)
  j.genclasses = list(dedup.keys())
  return cls
  
def make_class(j,x,cls):
  ostr = ''
  cn = cls[x]['cn']
  y  = cls[x]['par']
  pn = '' if y == 0 else cls[y]['cn']
  ca = pick_class_access(j)

  if ca != '': ostr += ca + ' '
  ostr += 'class ' + cn + ' '
  if pn != '': ostr += 'extends ' + pn + ' '
  ostr += 'implements Serializable {\n'

  nelts = int(math.floor(min(r.expovariate(1.0) * j.meanelts, j.maxelts)))
  nvals = {"byte":'(byte)0', "short":'(short)0', "int":'(int)0', "long":'(long)0', "float":'0.0f', "double":'0.0', "boolean":'false', "char":"'a'", "String":'"hello"'}

  dedup = {}
  for i in range(nelts):
    if r.random() < j.mprob: 
      ma = pick_method_access(j)
      ms = pick_method_static(j)
      rt = pick_return_type(j)
      nv = nvals[rt] if rt in nvals else 'null'
      while True:
        mn = pick_method_name(j) 
        if mn not in dedup: 
          dedup[mn] = 1
          break
        else: continue
      
      nparms = int(math.floor(min(r.expovariate(1.0) * j.meanparms, j.maxparms)))
      pstr = ''
      for p in range(nparms):
        pn = j.fubars[p]
        pt = pick_param_type(j)
        pstr += pt
        pstr += ' '
        pstr += pn
        pstr += ', ' if p < nparms - 1 else ''
      ostr += '  ' + sne(ma) + sne(ms) + rt + ' ' + mn + '(' + pstr + ') { return ' + nv + '; };\n'
    else:
      fa = pick_field_access(j)
      fs = pick_field_static(j)
      ft = pick_field_type(j)
      while True:
        fn = pick_field_name(j)
        if fn not in dedup: 
          dedup[fn] = 1
          break
        else: continue
      ostr += '  ' + sne(fa) + sne(fs) + ft + ' ' + fn + ';\n'

  ostr += '}';
  return ostr;

##############################################################################################
if __name__ == '__main__':
  dir_path = './out'
  with open('gspec.json', 'r') as f: j = JGenSpec(**(json.load(f)))
  with open('vocab.json', 'r') as f: j.update(json.load(f))
  j.set_rseed(use_time=True)

  try:                 shutil.rmtree(dir_path)
  except OSError as e: print("%s : %s" % (dir_path, e.strerror))
  try:                 os.mkdir(dir_path)
  except OSError as e: print("%s : %s" % (dir_path, e.strerror))

  cls = make_cl_hierarchy(j)

  for x in cls: 
    with open(dir_path + '/' + cls[x]['cn'] + '.java', 'w') as of:
      of.write('package ' + j.pkgprefix + ';\n')
      of.write('import java.lang.*; \n')
      of.write('import java.io.*; \n')
      of.write('import ' + j.pkgprefix + '.*;\n')
      of.write('\n')
      of.write(make_class(j,x,cls))
 
##############################################################################################

# decouple AST from writing
# check for duplicate field names in parents
# provide constructor to generate random instance
#  for each field
#    if class create radom instance and assign
#    if primitive generate random value and assign

