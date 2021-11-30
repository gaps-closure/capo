#!/usr/bin/python3
from owlready2 import *

def make_ontology():
  onto_path.append('.')
  pdg_edge = get_ontology('pdg_edge')
  with pdg_edge:
    class PDGEdge(Thing):
      pass
    class ControlDep(PDGEdge):
      pass
    class ControlDep_CallInv(ControlDep):
      pass
    class ControlDep_CallRet(ControlDep):
      pass
    class ControlDep_Entry(ControlDep):
      pass
    class ControlDep_Br(ControlDep):
      pass
    class ControlDep_Other(ControlDep):
      pass
    class DataDepEdge(PDGEdge):
      pass
    class DataDepEdge_DefUse(DataDepEdge):
      pass
    class DataDepEdge_RAW(DataDepEdge):
      pass
    class DataDepEdge_Ret(DataDepEdge):
      pass
    class DataDepEdge_Alias(DataDepEdge):
      pass
    class Parameter(PDGEdge):
      pass
    class Parameter_In(Parameter):
      pass
    class Parameter_Out(Parameter):
      pass
    class Parameter_Field(Parameter):
      pass
    class Anno(PDGEdge):
      pass
    class Anno_Global(Anno):
      pass
    class Anno_Var(Anno):
      pass
    class Anno_Other(Anno):
      pass
  return pdg_edge

if __name__ == '__main__':
  pdg_edge = make_ontology()
  sync_reasoner(infer_property_values=True)
  pdg_edge.save(format = 'rdfxml')
