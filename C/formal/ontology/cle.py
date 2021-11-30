#!/usr/bin/python3
from owlready2 import *

def make_ontology():
  onto_path.append('.')
  cle = get_ontology('cle')
  with cle:
    class Symbol(Thing):
      pass
    class Level(Symbol):
      pass
    class Enclave(Symbol):
      pass
    class Label(Symbol):
      pass
    class CLE_entry(Thing):
      pass
    class CrossDomainFlow(Thing):
      pass
    class GuardDirective(Thing):
      pass
    class FuncTaints(Thing):
      pass
    class RetTaint(Label):
      pass
    class BodyTaint(Label):
      pass
    class ArgTaint(Label):
      pass
    class GapsTag(Thing):
      pass
    class GuardOperation(Symbol):
      pass
    class Allow(GuardOperation):
      pass
    class Deny(GuardOperation):
      pass
    class Redact(GuardOperation):
      pass
    class hasLevel(CLE_entry         >> Level):
      pass
    class hasCDF(CLE_entry         >> CrossDomainFlow):
      pass
    class hasRemoteLevel(CrossDomainFlow   >> Level):
      pass
    class hasDirective(CrossDomainFlow   >> GuardDirective):
      pass
    class hasFunctTaints(CrossDomainFlow   >> FuncTaints):
      pass
    class hasTaints(RetTaint          >> CLE_entry):
      pass
    class hasTaints(BodyTaint         >> CLE_entry):
      pass
    class hasTaints(ArgTaint          >> CLE_entry):
      pass
    class hasArgTaintIdx(ArgTaint          >> int):
      pass
    class hasRetTaint(FuncTaints        >> RetTaint):
      pass
    class hasBodyTaint(FuncTaints        >> BodyTaint):
      pass
    class hasArgTaint(FuncTaints        >> ArgTaint):
      pass
    class hasOperation(GuardDirective    >> GuardOperation):
      pass
    class hasOneway(GuardDirective    >> bool):
      pass
    class hasGapsTag(GuardDirective    >> GapsTag):
      pass
    class hasOpArgs(Redact            >> Symbol):
      pass
  return cle

if __name__ == '__main__':
  cle = make_ontology()
  sync_reasoner(infer_property_values=True)
  cle.save(format = 'rdfxml')
