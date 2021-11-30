#!/usr/bin/python3
from owlready2 import *

def make_ontology():
  onto_path.append('.')
  entity = get_ontology('entity')
  with entity:
    class PDG(Thing):
      pass
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
    class CLEAnnotation(Annotation):
      pass
    class VarAnnotation(CLEAnnotation):
      pass
    class FuncAnnotation(CLEAnnotation):
      pass
  return entity

if __name__ == '__main__':
  entity = make_ontology()
  sync_reasoner(infer_property_values=True)
  entity.save(format = 'rdfxml')
