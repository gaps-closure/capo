
% ------------------ Initialize Assingments -------------------------

constraint forall (n in PDGNodeIdx) (if hasCle[n]!= None then hasEnclaveLevel[nodeEnclave[n]] == haslevel[hasCle[n]] endif );
% ------------------ Control Dep Constraints ------------------------

% Every function entry node must be assigned a valid enclave
constraint forall (n in FunctionEntry) ( nodeEnclave[n] != nullEnclave);

% Every global variable must be assigned to a valid enclave 
constraint forall (n in Global) ( nodeEnclave[n] != nullEnclave );

/* Conflict is resolvable via RPC if endpoints of CONTROL edge from functioncall to entry are in different enclaves */
% constraint forall (e in ControlDep_CallInv) 
%  ( nodeEnclave[hasSource[e]]!=nodeEnclave[hasDest[e]] -> resolvableConflict[e]==true );

/* The two ends of every CONTROL edge must be assigned to the same enclave unless it is a resolvable control conflict */ 
constraint forall (e in ControlDep) ( resolvableConflict[e]==false -> nodeEnclave[hasSource[e]]==nodeEnclave[hasDest[e]]  \/ ( resolvableConflict[e]==true /\ (e in ControlDep_CallInv /\ nodeEnclave[hasSource[e]]!=nodeEnclave[hasDest[e]]) ));


% Check wrapper
% constraint forall (e in ControlDep) ( (e in C_ControlDep_CallInv(ControlDep_CallInv) /\ resolvableConflict[C_ControlDep(e)]==true)  ->  (haslevel[nodeEnclave[to_enum(PDGNode,hasSource[C_ControlDep(e)])]] == hasremotelevel[hasCle[to_enum(PDGNode,hasDest[C_ControlDep(e)])]]));


% This constraint seems to be problematic      
% constraint forall (e in PDGEdge) ( if e in ControlDep_NonCall then resolvableConflict[e] == false endif);

% conflict resolvability of return must match that of corresponding invocation
% constraint forall (e in ControlDep_CallRet) (resolvableControlConflict[C_ControlDep(C_ControlDep_CallRet(e))] == resolvableControlConflict[C_ControlDep(C_ControlDep_CallInv(invForRet[e]))]);

% ------------------ Data Dep Constraints ------------------------

% to be a resolvable conflict, must be a conflict i.e., endpoint share in different enclaves, and must be a Parameter
% May want to include returns
constraint forall (e in Parameter) (( nodeEnclave[hasSource[e]] == nodeEnclave[nodeEnclave[hasDest[e]]]) -> resolvableConflict[e]==false);

% data flow partitioning: only resolvable control conflicts can be in cut
constraint forall (e in DataEdge) (  resolvableConflict[e]==true \/ nodeEnclave[hasSource[e]] == nodeEnclave[hasDest[e]]); 

% ------------------ Taint Propagation Constraints ------------------------

% Check if edge can be coerced
% predicate CanCoerce(DataDep:e) = (hasBodyTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasDest[e]]]]]]] ==  cleEntry[hasCle[hasDest[e]]] /\ hasBodyTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasSource[e]]]]]]] ==  cleEntry[hasCle[hasSource[e]]] );

% predicate CanCoerce(DataDep:e) = (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == None \/ hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == None);


% This needs to be updated once function taints are added
% Make sure all data dependencies have the same level or can be coerced
% constraint forall (e in DataDep) (if e in C_DataDepEdge_Ret(DataDepEdge_Ret) then true else false endif \/ haslevel[hasCle[hasSource[C_DataEdge(C_DataDep(e))]]] == haslevel[hasCle[hasDest[C_DataEdge(C_DataDep(e))]]]);
% constraint forall (e in Anno_Global) (haslevel[hasCle[hasSource[C_Anno(C_Anno_Global(e))]]] == haslevel[hasCle[hasDest[C_Anno(C_Anno_Global(e))]]]);
constraint forall (e in DataEdgeNoRet) (nodeEnclave[hasSource[e]] == nodeEnclave[hasDest[e]]);
constraint forall (e in ControlDep_Entry) (nodeEnclave[hasSource[e]] == nodeEnclave[hasDest[e]]);

% Check function propagation taints
% constraint forall (e in Parameter) (cleEntry[hasCle[hasDest[e]]] in hasArgTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[hasDest[e]]]]]]][hasParamIdx[e]]);
% constraint forall (e in ControlDep_CallRet) (cleEntry[hasCle[hasDest[e]]] in hasRetTaint[hasFuncTaints[hasCDF[cleEntry[hasCle[hasFunction[e]]]]]]);

% Check Unannotated functions have exactly one taint
% Check that all the children of the function have the same taint, if they are all equal, there is only one taint
% constraint forall(f in FunctionEntry) (forall (c in hasChildren[f]) (cleEntry[hasCle[c] == hasChildren[f][0] \/ cleEntry[hasCle[c] == None))

% var int: objective = sum( e in PDGEdge where resolvableControlConflict[e] == 1 \/ resolvableDataConflict[e] == 1)(1);

var int: objective = sum( e in PDGEdgeIdx where resolvableConflict[e] == true)(1);

solve minimize objective;

% solve satisfy;

  output ["Enclave Assingment: \(nodeEnclave) \n"];
  output ["CLE Assingment: \(hasCle) \n"];
  output ["Edge: " ++ show(x) ++ " " ++ show(nodeEnclave[hasSource[x]]) ++ " " ++ show(nodeEnclave[hasDest[x]]) ++ " " ++ show(nodeEnclave[hasSource[x]]==nodeEnclave[hasDest[x]]) ++ "\n" | x in ControlDep ] ;
  output ["resolvableConflict Assingment: \(resolvableConflict) \n"];
  output["ENTRY: "     ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in FunctionEntry ] ;
  output["GLOBAL: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in PDGNodeIdx where x in Global] ;
 