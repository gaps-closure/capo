
% ------------------ Initialize Assingments -------------------------

% constraint forall (n in PDGNode) (if haslevel[hasCle[n]] != None then nodeEnclave[n] == haslevel[hasCle[n]] endif );
constraint forall (n in PDGNode) (if hasCle[n]!= None then haslevel[nodeEnclave[n]] == haslevel[hasCle[n]] endif );
% ------------------ Control Dep Constraints ------------------------

% Every function entry node must be assigned a valid enclave
% constraint forall (n in PDGNode) (n in C_FunctionEntry(FunctionEntry) -> nodeEnclave[n] != nullEnclave);
constraint forall (n in PDGNode) (n in C_FunctionEntry(FunctionEntry) -> nodeEnclave[n] != None);

% Every global variable must be assigned to a valid enclave 
% constraint forall (n in PDGNode) (n in Global -> nodeEnclave[n] != nullEnclave);
constraint forall (n in PDGNode) (n in Global -> nodeEnclave[n] != None);

/* Conflict is resolvable via RPC if endpoints of CONTROL edge from functioncall to entry are in different enclaves */
constraint forall (e in ControlDep) (
  not (e in C_ControlDep_CallInv(ControlDep_CallInv) /\ (nodeEnclave[to_enum(PDGNode,hasSource[C_ControlDep(e)])] != nodeEnclave[to_enum(PDGNode,hasDest[C_ControlDep(e)])]))
  -> resolvableConflict[C_ControlDep(e)]==false
);

/* The two ends of every CONTROL edge must be assigned to the same enclave unless it is a resolvable control conflict */ 
constraint forall (e in ControlDep) ( resolvableConflict[C_ControlDep(e)]==false -> nodeEnclave[to_enum(PDGNode,hasSource[C_ControlDep(e)])]==nodeEnclave[to_enum(PDGNode,hasDest[C_ControlDep(e)])] );

% Check wrapper
constraint forall (e in ControlDep) ( (e in C_ControlDep_CallInv(ControlDep_CallInv) /\ resolvableConflict[C_ControlDep(e)]==true)  ->  (haslevel[nodeEnclave[to_enum(PDGNode,hasSource[C_ControlDep(e)])]] == hasremotelevel[hasCle[to_enum(PDGNode,hasDest[C_ControlDep(e)])]]));


% This constraint seems to be problematic      
% constraint forall (e in PDGEdge) ( if e in ControlDep_NonCall then resolvableConflict[e] == false endif);

% conflict resolvability of return must match that of corresponding invocation
% constraint forall (e in ControlDep_CallRet) (resolvableControlConflict[C_ControlDep(C_ControlDep_CallRet(e))] == resolvableControlConflict[C_ControlDep(C_ControlDep_CallInv(invForRet[e]))]);

% ------------------ Data Dep Constraints ------------------------

% to be a resolvable conflict, must be a conflict i.e., endpoint share in different enclaves, and must be a Parameter
% May want to include returns
constraint forall (e in Parameter) (( nodeEnclave[to_enum(PDGNode,hasSource[C_DataEdge(C_Parameter(e))])] == nodeEnclave[to_enum(PDGNode,hasDest[C_DataEdge(C_Parameter(e))])]) -> resolvableConflict[C_DataEdge(C_Parameter(e))]==false);

% data flow partitioning: only resolvable control conflicts can be in cut
constraint forall (e in DataEdge) (  resolvableConflict[C_DataEdge(e)]==true \/ nodeEnclave[to_enum(PDGNode,hasSource[C_DataEdge(e)])] == nodeEnclave[to_enum(PDGNode,hasDest[C_DataEdge(e)])]); 

% ------------------ Taint Propagation Constraints ------------------------

% Check if edge can be coerced
% predicate CanCoerce(DataDep:e) = (hasBodyTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasDest[e]]]]]]] ==  cleEntry[hasCle[hasDest[e]]] /\ hasBodyTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasSource[e]]]]]]] ==  cleEntry[hasCle[hasSource[e]]] );

% predicate CanCoerce(DataDep:e) = (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == None \/ hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == None);


% This needs to be updated once function taints are added
% Make sure all data dependencies have the same level or can be coerced
constraint forall (e in DataDep) (if e in C_DataDepEdge_Ret(DataDepEdge_Ret) then true else false endif \/ haslevel[hasCle[hasSource[C_DataEdge(C_DataDep(e))]]] == haslevel[hasCle[hasDest[C_DataEdge(C_DataDep(e))]]]);
% constraint forall (e in Anno_Global) (haslevel[hasCle[hasSource[C_Anno(C_Anno_Global(e))]]] == haslevel[hasCle[hasDest[C_Anno(C_Anno_Global(e))]]]);
% constraint forall (e in DataDep) (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == hasCle[hasDest[C_DataEdge(C_DataDep(e))]]);

% Check function propagation taints
% constraint forall (e in Parameter) (cleEntry[hasCle[hasDest[e]]] in hasArgTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasDest[e]]]]]]][hasParamIdx[e]]);
% constraint forall (e in ControlDep_CallRet) (cleEntry[hasCle[hasDest[e]]] in hasRetTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[e]]]]]]);

% Check Unannotated functions have exactly one taint
% Check that all the children of the function have the same taint, if they are all equal, there is only one taint
% constraint forall(f in FunctionEntry) (forall (c in hasChildren[f]) (cleEntry[hasCle[c] == hasChildren[f][0] \/ cleEntry[hasCle[c] == None))

% var int: objective = sum( e in PDGEdge where resolvableControlConflict[e] == 1 \/ resolvableDataConflict[e] == 1)(1);

var int: objective = sum( e in PDGEdge where resolvableConflict[e] == 1)(1);

solve minimize objective;

% solve satisfy;

  output ["Enclave Assingment: \(nodeEnclave) \n"];
  output ["CLE Assingment: \(hasCle) \n"];
  output["ENTRY: "     ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in C_FunctionEntry(FunctionEntry) ] ;
  output["GLOBAL: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in PDGNode where x in Global] ;



  % output ["Edge: "++ show(x) ++ " src: "  ++ show_int(0, to_enum(PDGNode,hasSource[to_enum(PDGEdge,x)])) ++ " | " ++ show(hasCle[to_enum(PDGNode,hasSource[to_enum(PDGEdge,x)])]) ++ "\n" | x in 1..max(PDGEdge) ] ;
  output ["EdgeIDs: " ++ show_int(0, x)  ++ show(hasCle[hasDest[x]]) ++ " | " ++ show(hasCle[hasSource[x]]) ++ "\n" | x in DataDep ] ;
output ["EdgeRetIDs: " ++ show_int(0, x) ++  "\n" | x in (C_DataDepEdge_Ret(DataDepEdge_Ret)) ] ;
  % output ["Edge: " ++ show_int(0, x) ++ "\n" | x in 1..max(PDGEdge) ] ;
  % output ["Edge2: " ++ show_int(0, x) ++  "\n" | x in C_DataEdge(C_DataDep(DataDep)) ] ;
  % output ["Edge3: " ++ show_int(0, x) ++  "\n" | x in C_DataEdge(C_DataDep(C_DataDepEdge_Ret(DataDepEdge_Ret))) ] ;
  % output["\(show_int(0,to_enum(PDGNode,C_VarNode(C_VarNode_StaticFunction(ID2))))) \n"];
  % output["\(show_int(0,to_enum(PDGEdge,C_DataEdge(C_DataDep(C_DataDepEdge_DefUse(ID4294967228)))))) \n"];