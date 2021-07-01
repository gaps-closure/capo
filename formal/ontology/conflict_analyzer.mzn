
% ------------------ Initialize Assingments -------------------------

% constraint forall (n in PDGNode) (if haslevel[hasCle[n]] != None then nodeEnclave[n] == haslevel[hasCle[n]] endif );
constraint forall (n in PDGNode) (if hasCle[n]!= None then nodeEnclave[n] == hasCle[n] endif );
% ------------------ Control Dep Constraints ------------------------

% Every function entry node must be assigned a valid enclave
% constraint forall (n in PDGNode) (n in C_FunctionEntry(FunctionEntry) -> nodeEnclave[n] != nullEnclave);
constraint forall (n in PDGNode) (n in C_FunctionEntry(FunctionEntry) -> nodeEnclave[n] != None);

% Every global variable must be assigned to a valid enclave 
% constraint forall (n in PDGNode) (n in Global -> nodeEnclave[n] != nullEnclave);
constraint forall (n in PDGNode) (n in Global -> nodeEnclave[n] != None);

% control flow partitioning: only resolvable control conflicts can be in cut
constraint forall (e in ControlDep) (resolvableControlConflict[C_ControlDep(e)]==true \/ nodeEnclave[to_enum(PDGNode,hasSource[C_ControlDep(e)])] == nodeEnclave[to_enum(PDGNode,hasDest[C_ControlDep(e)])]); 

% to be a resolvable conflict, must be a conflict i.e., endpoint share in different enclaves, and must be a CALLINV or CALLRET edge
constraint forall (e in ControlDep)
  (( e in C_ControlDep_CallInv(ControlDep_CallInv) /\ nodeEnclave[to_enum(PDGNode,hasSource[C_ControlDep(e)])] == nodeEnclave[to_enum(PDGNode,hasDest[C_ControlDep(e)])]) -> resolvableControlConflict[C_ControlDep(e)]==false);
     
constraint forall (e in PDGEdge) (e in ControlDep_NonCall -> resolvableControlConflict[e] == false);

% conflict resolvability of return must match that of corresponding invocation
% constraint forall (e in ControlDep_CallRet) (resolvableControlConflict[C_ControlDep(C_ControlDep_CallRet(e))] == resolvableControlConflict[C_ControlDep(C_ControlDep_CallInv(invForRet[e]))]);

% ------------------ Data Dep Constraints ------------------------

% to be a resolvable conflict, must be a conflict i.e., endpoint share in different enclaves, and must be a Parameter
% May want to include returns
constraint forall (e in Parameter) (( nodeEnclave[to_enum(PDGNode,hasSource[C_DataEdge(C_Parameter(e))])] == nodeEnclave[to_enum(PDGNode,hasDest[C_DataEdge(C_Parameter(e))])]) -> resolvableDataConflict[C_DataEdge(C_Parameter(e))]==false);


% control flow partitioning: only resolvable control conflicts can be in cut
constraint forall (e in DataEdge) (  resolvableDataConflict[C_DataEdge(e)]==true \/ nodeEnclave[to_enum(PDGNode,hasSource[C_DataEdge(e)])] == nodeEnclave[to_enum(PDGNode,hasDest[C_DataEdge(e)])]); 

% ------------------ Taint Propagation Constraints ------------------------

% Check if edge can be coerced
% predicate CanCoerce(DataDep:e) = (hasBodyTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasDest[e]]]]]]] ==  hasTaint[hasDest[e]] /\ hasBodyTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasSource[e]]]]]]] ==  hasTaint[hasSource[e]] );

% predicate CanCoerce(DataDep:e) = (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == None \/ hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == None);
predicate CanCoerce(DataDep:e) = if e in C_DataDepEdge_Ret(DataDepEdge_Ret) then true else false endif ;


% Make sure all data dependencies have the same level or can be coerced
constraint forall (e in DataDep) (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == hasCle[hasDest[C_DataEdge(C_DataDep(e))]] \/ CanCoerce(e));
% constraint forall (e in DataDep) (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == hasCle[hasDest[C_DataEdge(C_DataDep(e))]]);

% Check function propagation taints
% constraint forall (e in Parameter) (cleEntry[hasCle[hasDest[e]]] in hasArgTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasDest[e]]]]]]][hasParamIdx[e]]);
% constraint forall (e in ControlDep_CallRet) (cleEntry[hasCle[hasDest[e]]] in hasRetTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[e]]]]]]);

% Check Unannotated functions have exactly one taint
% Check that all the children of the function have the same taint, if they are all equal, there is only one taint
% constraint forall(f in FunctionEntry) (forall (c in hasChildren[f]) (cleEntry[hasCle[c] == hasChildren[f][0] \/ cleEntry[hasCle[c] == None))

% var int: objective = sum( e in PDGEdge where resolvableControlConflict[e] == 1 \/ resolvableDataConflict[e] == 1)(1);
var int: objective = sum( e in PDGEdge where resolvableControlConflict[e] == 1)(1) + sum(e in PDGEdge where resolvableDataConflict[e] == 1)(1);

solve minimize objective;

  output ["Enclave Assingment: \(nodeEnclave) \n"];
  output ["CLE Assingment: \(hasCle) \n"];
  output["ENTRY: "     ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in C_FunctionEntry(FunctionEntry) ] ;
  output["GLOBAL: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in PDGNode where x in Global] ;



  % output ["Edge: "++ show(x) ++ " src: "  ++ show_int(0, to_enum(PDGNode,hasSource[to_enum(PDGEdge,x)])) ++ " | " ++ show(hasCle[to_enum(PDGNode,hasSource[to_enum(PDGEdge,x)])]) ++ "\n" | x in 1..max(PDGEdge) ] ;
  % output ["dest: " ++ show_int(0, hasDest[to_enum(PDGEdge,x)]) ++ " | " ++ show(hasCle[hasDest[to_enum(PDGEdge,to_enum(PDGEdge,x))]]) ++ "\n" | x in 1..max(PDGEdge) ] ;

  % output ["Node: " ++ show_int(0, x) ++ " | " ++ show(hasCle[to_enum(PDGNode,x) ]) ++ "\n" | x in 1..max(PDGNode) ] ;
  % output["\(show_int(0,to_enum(PDGNode,C_VarNode(C_VarNode_StaticFunction(ID2))))) \n"];
  % output["\(show_int(0,to_enum(PDGEdge,C_DataEdge(C_DataDep(C_DataDepEdge_DefUse(ID4294967228)))))) \n"];