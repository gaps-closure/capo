#!/usr/bin/python3
import json
import math
import time
import random       as r
import numpy.random as nr
from   dataclasses  import dataclass

@dataclass
class JGenSpec:
  pkgprefix:     str       # Package prefix to use
  rseed:         int       # Seed for random generator
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

  def set_rseed(self, use_time=False): 
    s = int(time.time()) if use_time else self.rseed
    nr.seed(s)
    r.seed(s)

  def update(self, w):
    for k,v in w.items():
      if hasattr(self, k): setattr(self, k, v)

def pick(wl,capitalize=True): 
  return r.choice(wl).capitalize() if capitalize else r.choice(wl)

def pick_type(primflds, allclasses, primfreq, classprob, arrayprob):
  assert(classprob >= 0.0 and classprob <= 1.0)
  assert(arrayprob >= 0.0 and arrayprob <= 1.0)
  assert(len(primflds) == len(primfreq))
  assert(sum(primfreq) == 1.0)
  assert(len(primflds) > 0)
  ft = r.choice(allclasses) if r.random() < classprob else nr.choice(primflds, 1, p = primfreq)[0]
  ar = "[]" if r.random() < arrayprob else ""
  return ft + ar

def pick_access(mods, modfreq):
  assert(len(mods) == len(modfreq))
  assert(sum(modfreq) == 1.0)
  assert(len(mods) > 0)
  return nr.choice(mods, 1, modfreq)[0]

def pick_field_name(j):    return "f" + pick(j.nouns)
def pick_subcl_name(j,cn): return pick(j.adjectives) + cn
def pick_method_name(j):   return pick(j.verbs,False) + pick(j.adverbs)
def pick_class_name(j):    return pick(j.adjectives) + pick(j.nouns)
def pick_field_type(j):    return pick_type(j.primtypes, ["ClassTBD"], j.fprim_freq, j.fclassprob, j.farrayprob)
def pick_return_type(j):   return pick_type(j.primtypes, ["ClassTBD"], j.rprim_freq, j.rclassprob, j.rarrayprob)
def pick_param_type(j):    return pick_type(j.primtypes, ["ClassTBD"], j.pprim_freq, j.pclassprob, j.parrayprob)
def pick_class_access(j):  return pick_access(j.class_a_mods, j.class_a_freq)
def pick_field_access(j):  return pick_access(j.field_a_mods, j.field_a_freq)
def pick_method_access(j): return pick_access(j.method_a_mods, j.method_a_freq)

"""
foverrideprob  = 0.0
moverrideprob  = 0.2
moverloadprob  = 0.2
class_na_mods  = ["final", "abstract", ""]
method_na_mods = ["final", "static", "abstract", "transient", "synchronized", ""]
field_na_mods  = ["final", "static", "transient", "volatile", ""]
"""

if __name__ == '__main__':
  with open("gspec.json", 'r') as f: j = JGenSpec(**(json.load(f)))
  with open("vocab.json", 'r') as f: j.update(json.load(f))
  j.set_rseed(use_time=True)

  # XXX: must construct class hierarchy first
 
  ca = pick_class_access(j)
  cn = pick_class_name(j)
  # check for duplicates, decide inheritance
  print((ca if ca=="" else ca + " ") + "class " + cn + " implements Serializable {")

  nelts = int(math.floor(min(r.expovariate(1.0) * j.meanelts, j.maxelts)))

  for i in range(nelts):
    if r.random() < j.mprob: 
      ma = pick_method_access(j)
      rt = pick_return_type(j)
      mn = pick_method_name(j)  # check dups, overriding
      nparms = int(math.floor(min(r.expovariate(1.0) * j.meanparms, j.maxparms)))
      pstr = ""
      for p in range(nparms):
        pn = j.fubars[p]
        pt = pick_param_type(j)
        pstr += pt
        pstr += " "
        pstr += pn
        pstr += ", " if p < nparms - 1 else ""
        
      print("  " + (ma if ma=="" else ma + " ") + rt + " " + mn + "(" + pstr + ");")

    else:
      fa = pick_field_access(j)
      ft = pick_field_type(j)
      fn = pick_field_name(j)
      # check for duplicates and parent field overrides
      print("  " + (fa if fa=="" else fa + " ") + ft + " " + fn + ";")

  print("};")
