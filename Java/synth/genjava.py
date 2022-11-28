#!/usr/bin/python3
import json
import random
import math
import numpy.random as nr

pkgprefix      = "com.peratonlabs.jgen"
prim_fields    = ["byte", "short", "int", "long", "float", "double", "boolean", "char", "String"]

mprob          = 0.2
fprim_freq     = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2]
pprim_freq     = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2]
rprim_freq     = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2]

farrayprob     = 0.1
fclassprob     = 0.2

parrayprob     = 0.1
pclassprob     = 0.2

rarrayprob     = 0.1
rclassprob     = 0.2

foverrideprob  = 0.0

moverrideprob  = 0.2
moverloadprob  = 0.2

meanparms      = 4.0
maxparms       = 20.0

meanelts       = 8.0
maxelts        = 20.0

class_a_mods   = ["public", ""]
field_a_mods   = ["public", "private", "protected", ""]
method_a_mods  = ["public", "private", "protected", ""]
class_na_mods  = ["final", "abstract", ""]
method_na_mods = ["final", "static", "abstract", "transient", "synchronized", ""]
field_na_mods  = ["final", "static", "transient", "volatile", ""]

class_a_freq   = [0.1, 0.9]
method_a_freq  = [0.2, 0.4, 0.4, 0.0]
field_a_freq   = [0.05, 0.65, 0.3, 0.0]
class_na_freq  = [0.1, 0.1, 0.8]
method_na_freq = [0.05, 0.05, 0.0, 0.0, 0.0, 0.9]
field_na_freq  = [0.05, 0.05, 0.0, 0.0, 0.9]

words = {}

def pick_name(pl): 
  return ''.join(list(map(lambda x: random.choice(words[x]) if x=="verbs" else random.choice(words[x]).capitalize(), pl)))

def pick_type(primflds, allclasses, primfreq, classprob, arrayprob):
  assert(classprob >= 0.0 and classprob <= 1.0)
  assert(arrayprob >= 0.0 and arrayprob <= 1.0)
  assert(len(primflds) == len(primfreq))
  assert(sum(primfreq) == 1.0)
  ft = random.choice(allclasses) if random.random() < classprob else nr.choice(primflds, 1, p = primfreq)[0]
  ar = "[]" if random.random() < arrayprob else ""
  return ft + ar
  
def pick_modif():  return ""
def pick_class_modif():  return ""
def pick_field_modif():  return ""
def pick_method_modif():  return ""

def pick_class_name():   return pick_name(["adjectives", "nouns"])
def pick_subcl_name(cn): return pick_name(["adjectives"]) + cn
def pick_field_name():   return "f" + pick_name(["nouns"])
def pick_method_name():  return pick_name(["verbs","adverbs"])

def pick_field_type():  return pick_type(prim_fields, ["ClassTBD"], fprim_freq, fclassprob, farrayprob)
def pick_return_type(): return pick_type(prim_fields, ["ClassTBD"], rprim_freq, rclassprob, rarrayprob)
def pick_param_type():  return pick_type(prim_fields, ["ClassTBD"], pprim_freq, pclassprob, parrayprob)

if __name__ == '__main__':
  with open('vocab.json', 'r') as vj:
    words = json.load(vj)

  cn = pick_class_name()
  # check for duplicates, decide inheritance
  print("class " + cn)

  nelts = int(math.floor(min(random.expovariate(1.0) * meanelts, maxelts)))

  for i in range(nelts):
    if random.random() < mprob: 
      rt = pick_return_type()
      mn = pick_method_name()  # check dups, overriding
      nparms = int(math.floor(min(random.expovariate(1.0) * meanparms, maxparms)))
      pstr = ""
      for p in range(nparms):
        pn = words["fubars"][p]
        pt = pick_param_type()
        pstr += pt
        pstr += " "
        pstr += pn
        pstr += ", " if p < nparms - 1 else ""
        
      print(rt + " " + mn + "(" + pstr + ");")

    else:
      ft = pick_field_type()
      fn = pick_field_name()
      # check for duplicates and parent field overrides
      print(ft + " " + fn + ";")

