#!/usr/bin/python3
from owlready2 import *

def make_ontology():
  onto_path.append('.')
  pdg_node = get_ontology('pdg_node')
  with pdg_node:
    class PDGNode(Thing):
      pass
    class Inst(PDGNode):
      pass
    class Inst_FunCall(Inst):
      pass
    class Inst_Ret(Inst):
      pass
    class Inst_Br(Inst):
      pass
    class Inst_Other(Inst):
      pass
    class VarNode(PDGNode):
      pass
    class VarNode_StaticGlobal(VarNode):
      pass
    class VarNode_StaticModule(VarNode):
      pass
    class VarNode_StaticFunction(VarNode):
      pass
    class VarNode_StaticOther(VarNode):
      pass
    class FunctionEntry(PDGNode):
      pass
    class Param(PDGNode):
      pass
    class Param_FormalIn(Param):
      pass
    class Param_FormalOut(Param):
      pass
    class Param_ActualIn(Param):
      pass
    class Param_ActualOut(Param):
      pass
    class Annotation(PDGNode):
      pass
    class Annotation_Var(Annotation):
      pass
    class Annotation_Global(Annotation):
      pass
    class Annotation_Other(Annotation):
      pass
  return pdg_node

if __name__ == '__main__':
  pdg_node = make_ontology()
  sync_reasoner(infer_property_values=True)
  pdg_node.save(format = 'rdfxml')
