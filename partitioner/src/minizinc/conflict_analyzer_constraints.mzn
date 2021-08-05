%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function var Enclave: myEnclave(var PDGNodeIdx: n) =
 (if     (n in VarNode)           then varnodeEnclave[n]
  elseif (n in FunctionEntry)     then functionEnclave[n]
  elseif (n in Inst)              then functionEnclave[hasFunction[n]]
  elseif (n in Param)             then functionEnclave[hasFunction[n]] 
  else   nullEnclave              % expects nullEnclave defined, cannot assign a valid enclave to Annotations
  endif);

function var Level: tLevel(var PDGNodeIdx: n) = (hasLabelLevel[taint[n]]);
function var Level: eLevel(var PDGNodeIdx: n) = (hasEnclaveLevel[myEnclave(n)]);

predicate lCut(var PDGEdgeIdx: e)             = (hasLabelLevel[taint[hasSource[e]]]!=hasLabelLevel[taint[hasDest[e]]]);
predicate tCut(var PDGEdgeIdx: e)             = (taint[hasSource[e]]!=taint[hasDest[e]]);
predicate tSafe(var PDGEdgeIdx: e)            = (taint[hasSource[e]]==taint[hasDest[e]]);
predicate eCut(var PDGEdgeIdx: e)             = (myEnclave(hasSource[e])!=myEnclave(hasDest[e]));
predicate eSafe(var PDGEdgeIdx: e)            = (myEnclave(hasSource[e])==myEnclave(hasDest[e]));

predicate allowOrRedact(var cdf: c)           = (hasGuardOperation[c]==allow \/ hasGuardOperation[c]==redact);

predicate xdcBlest(var ControlDep_CallInv: e) =
 (if isFunctionAnnotation[taint[hasDest[e]]] then allowOrRedact(cdfForRemoteLevel[taint[hasDest[e]], eLevel(hasSource[e])]) else false endif);

predicate coercible(var DataEdgeNoRet: e) =
 (if (hasFunction[hasSource[e]]!=0 /\ hasFunction[hasDest[e]]!=0 /\ hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
  then isFunctionAnnotation[taint[hasFunction[hasSource[e]]]]
  elseif ((hasDest[e] in VarNode) /\ hasFunction[hasSource[e]]!=0)
  then isFunctionAnnotation[taint[hasFunction[hasSource[e]]]]
  elseif ((hasSource[e] in VarNode) /\ hasFunction[hasDest[e]]!=0)
  then isFunctionAnnotation[taint[hasFunction[hasDest[e]]]]
  else false
  endif);

predicate rettaintSafe(var DataDepEdge_Ret: e) =
 (if isFunctionAnnotation[taint[hasFunction[hasSource[e]]]] 
  then hasRettaints[cdfForRemoteLevel[taint[hasFunction[hasSource[e]]], tLevel(hasDest[e])], taint[hasDest[e]]]
  else false
  endif);

% XXX this function needs to be fixed
% we may want to check if the destimation is Actual_In or Actual_Out
% it will be easiest if param idx is available for all actual_in and actual_out
predicate argtaintSafe(var Parameter: e) =
 (if isFunctionAnnotation[taint[hasFunction[hasDest[e]]]] /\ (hasDest[e] in Param_ActualIn \/ hasDest[e] in Param_ActualOut)
  %then hasArgtaints[cdfForRemoteLevel[taint[hasFunction[hasDest[e]]], tLevel(hasSource[e]]), hasParamIdx[hasDest[e]], taint[hasSource[e]]]
  then true
  else false
  endif);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "VarNodeHasEnclave"            forall (n in VarNode)            (varnodeEnclave[n]!=nullEnclave);
constraint :: "FunctionHasEnclave"           forall (n in FunctionEntry)      (functionEnclave[n]!=nullEnclave);
constraint :: "NodeEnclaveAtTaintLevel"      forall (n in NonAnnotation)      (eLevel(n)==tLevel(n));
constraint :: "CallInvInCut"                 forall (e in ControlDep_CallInv) (xdcall[e] <-> eCut(e));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control never leaves enclave except via valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XXX: broken input, annotations in controldep entry edge
constraint :: "NonCallControlEnclaveSafe"   forall (e in ControlDep_NonCall where (hasDest[e] in Annotation)==false) (eSafe(e));
constraint :: "XDCallBlessed"               forall (e in ControlDep_CallInv) (xdcall[e] -> xdcBlest(e)); % XXX: relax for optimization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data never leaves enclave except via parameters or return for valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetNonParmDataEnclaveSafe" forall (e in DataEdgeNoRet where (hasDest[e] in Annotation)==false) (eSafe(e));

constraint :: "XDCDataReturnAllowed"
 forall (e in DataDepEdge_Ret) (eSafe(e) \/ allowOrRedact(cdfForRemoteLevel[taint[hasSource[e]], tLevel(hasDest[e])]));

constraint :: "XDCParmAllowed"
 forall (e in Parameter)       (eSafe(e) \/ allowOrRedact(cdfForRemoteLevel[taint[hasSource[e]], tLevel(hasDest[e])]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels can only be cooerced inside enclave via parameters or return by noblest functions that are so blest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetDataTaintSafeRCoerced"   forall (e in DataEdgeNoRet)   (eSafe(e) -> tSafe(e) \/ coercible(e)); 
constraint :: "ReturnTaintSafeOrCoerced"      forall (e in DataDepEdge_Ret) (eSafe(e) -> tSafe(e) \/ rettaintSafe(e));
constraint :: "ArgumentTaintSafeOrCoerced"    forall (e in Parameter)       (eSafe(e) -> tSafe(e) \/ argtaintSafe(e));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Blest function only touches allowed taints across argtaints, rettaints, and codtaints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XXX: across all edges from all contained nodes, the taints on the endpoints must be covered by argtaints, codtaints, or rettaints

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional sanity checks 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bool: debug = false;

constraint :: "CallSiteWithinFunctionAndCallsFunctionEntry"
 forall (e in ControlDep_CallInv) (debug==true -> hasFunction[hasSource[e]]!=0 /\ hasDest[e] in FunctionEntry);

constraint :: "ControlEdgeNonCallMustBeIntraFunction"
 forall (e in ControlDep_NonCall) (debug==true -> hasFunction[hasSource[e]]==hasFunction[hasDest[e]]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_CallInv where xdcall[e]==true)(1);
solve minimize objective;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output ["Domain assignments for globals and functions:" ++ "\n"];
output [" GLOBAL   : " ++ show(x) ++ " -> " ++ show(varnodeEnclave[x])   ++ "::" ++ show(taint[x]) ++ "\n" | x in Global] ;
output [" FUNCTION : " ++ show(x) ++ " -> " ++ show(functionEnclave[x]) ++ "::" ++ show(taint[x]) ++ "\n" | x in FunctionEntry ] ;
output ["Cross-domain cut:" ++ "\n"];
output [" XDCALL   : " ++ "(" ++ show(hasSource[e]) ++ ":" ++ show(taint[hasSource[e]]) ++ ")"
                       ++ "--[" ++ show(functionEnclave[hasFunction[hasSource[e]]]) ++ "]"
                       ++ "--||-->"
                       ++ "[" ++ show(functionEnclave[hasDest[e]]) ++ "]--"
                       ++ "(" ++ show(hasDest[e]) ++ ":" ++ show(taint[hasDest[e]]) ++ ")"
                       ++ "\n"
        | e in ControlDep_CallInv where fix(xdcall[e]==true)] ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
