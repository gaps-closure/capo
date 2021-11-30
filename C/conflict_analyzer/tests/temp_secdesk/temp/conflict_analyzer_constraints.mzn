%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicate isVarNode(var PDGNodeIdx: n)         = trace("IsVarNode \n",(n>=VarNode_start /\ n<=VarNode_end));
predicate isFunctionEntry(var PDGNodeIdx: n)   = trace("isFunctionEntry \n", (n>=FunctionEntry_start /\ n<=FunctionEntry_end));
predicate isInst(var PDGNodeIdx: n)            = trace("isInst \n", (n>=Inst_start /\ n<=Inst_end));
predicate isParam(var PDGNodeIdx: n)           = trace("isParam \n", (n>=Param_start /\ n<=Param_end));
predicate isAnnotation(var PDGNodeIdx: n)      = trace("isAnnotation \n", (n>=Annotation_start /\ n<=Annotation_end));
predicate isParam_ActualIn(var PDGNodeIdx: n)  = trace("isParam_ActualIn \n", (n>=Param_ActualIn_start /\ n<=Param_ActualIn_end));
predicate isParam_ActualOut(var PDGNodeIdx: n) = trace("isParam_ActualOut \n", (n>=Param_ActualOut_start /\ n<=Param_ActualOut_end));

function var Enclave: myEnclave(var PDGNodeIdx: n) = trace("myEnclave \n",
 (if     isVarNode(n)                          then varnodeEnclave[n]
  elseif isFunctionEntry(n)                    then functionEnclave[n]
  elseif isInst(n)                             then functionEnclave[hasFunction[n]]
  elseif isParam(n)                            then functionEnclave[hasFunction[n]]
  else   nullEnclave                           % cannot assign valid enclave to Annotations, expects nullEnclave defined
  endif));

function var Level: tLevel(var PDGNodeIdx: n)  = trace("tLevel \n", (hasLabelLevel[taint[n]]));
function var Level: eLevel(var PDGNodeIdx: n)  = trace("eLevel \n", (hasEnclaveLevel[myEnclave(n)]));

predicate lCut(var PDGEdgeIdx: e)              = trace("lCut \n",(hasLabelLevel[taint[hasSource[e]]]!=hasLabelLevel[taint[hasDest[e]]]));
predicate tCut(var PDGEdgeIdx: e)              = trace("tCut \n",(taint[hasSource[e]]!=taint[hasDest[e]]));
predicate tSafe(var PDGEdgeIdx: e)             = trace("tSafe \n",(taint[hasSource[e]]==taint[hasDest[e]]));
predicate eCut(var PDGEdgeIdx: e)              = trace("eCut \n",(myEnclave(hasSource[e])!=myEnclave(hasDest[e])));
predicate eSafe(var PDGEdgeIdx: e)             = trace("eSafe \n",(myEnclave(hasSource[e])==myEnclave(hasDest[e])));
predicate allowOrRedact(var cdf: c)            = trace("allowOrRedact \n",(hasGuardOperation[c]==allow \/ hasGuardOperation[c]==redact));

predicate xdcBlest(var ControlDep_CallInv: e)  =
 trace("xdcBlest \n",(if isFunctionAnnotation[taint[hasDest[e]]] then allowOrRedact(cdfForRemoteLevel[taint[hasDest[e]], eLevel(hasSource[e])]) else false endif));

predicate rettaintSafe(var DataDepEdge_Ret: e) =
 trace("rettaintSafe \n",(if isFunctionAnnotation[taint[hasFunction[hasSource[e]]]]
  then hasRettaints[cdfForRemoteLevel[taint[hasFunction[hasSource[e]]], tLevel(hasDest[e])], taint[hasDest[e]]]
  else false
  endif));

predicate argtaintSafe(var Parameter: e)       =
 trace("argtaintSafe \n",(if isFunctionAnnotation[taint[hasFunction[hasDest[e]]]] /\ isParam_ActualIn(hasDest[e])
  then hasArgtaints[cdfForRemoteLevel[taint[hasFunction[hasDest[e]]], tLevel(hasSource[e])], hasParamIdx[hasDest[e]], taint[hasSource[e]]]
  elseif isFunctionAnnotation[taint[hasFunction[hasSource[e]]]] /\  isParam_ActualOut(hasSource[e])
  then hasArgtaints[cdfForRemoteLevel[taint[hasFunction[hasSource[e]]], tLevel(hasDest[e])], hasParamIdx[hasSource[e]], taint[hasDest[e]]]
  else coercible(e)
  %else false
  endif));

predicate isInArctaint(var cleLabel: fan, var cleLabel: tnt, var Level: lvl) =
 trace("isInArctaint \n",(if isFunctionAnnotation[fan] then hasARCtaints[cdfForRemoteLevel[fan, lvl], tnt] else false endif));

predicate coercible(var DataEdgeNoRetParam: e) =
 trace("coercible \n",(if (hasFunction[hasSource[e]]!=0 /\ hasFunction[hasDest[e]]!=0 /\ hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
  then isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasDest[e]],   tLevel(hasDest[e])) /\
       isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasSource[e]], tLevel(hasSource[e]))  % source and dest taints okay
  elseif (isVarNode(hasDest[e]) /\ hasFunction[hasSource[e]]!=0)
  then isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasDest[e]],   tLevel(hasDest[e])) /\
       isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasSource[e]], tLevel(hasSource[e]))
  elseif (isVarNode(hasSource[e]) /\ hasFunction[hasDest[e]]!=0)
  then isInArctaint(taint[hasFunction[hasDest[e]]],   taint[hasSource[e]], tLevel(hasSource[e])) /\
       isInArctaint(taint[hasFunction[hasDest[e]]],   taint[hasDest[e]],   tLevel(hasDest[e]))
  else false
  endif));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "VarNodeHasEnclave"              trace("VarNodeHasEnclave \n", forall (n in VarNode)            (trace("VarNodeHasEnclave_Inner\n",varnodeEnclave[n]!=nullEnclave)));
constraint :: "FunctionHasEnclave"             trace("FunctionHasEnclave \n",forall (n in FunctionEntry)      (trace("FunctionHasEnclave_Inner\n",functionEnclave[n]!=nullEnclave)));
constraint :: "CallInvInCut"                   trace("CallInvInCut \n", forall (e in ControlDep_CallInv) (trace("CallInvInCut_Inner\n",xdcall[e] <-> eCut(e))));
constraint :: "NodeEnclaveAtTaintLevel"        trace("NodeEnclaveAtTaintLevel \n", forall (n in NonAnnotation)      (trace("NodeEnclaveAtTaintLevel_Inner\n",eLevel(n)==tLevel(n))));
constraint :: "FnAnnotationForFnOnly"          trace("FnAnnotationForFnOnly \n", forall (n in NonAnnotation)      (trace("FnAnnotationForFnOnly_Inner\n",isFunctionAnnotation[taint[n]] -> isFunctionEntry(n))));
constraint :: "FnAnnotationByUserOnly"         trace("FnAnnotationByUserOnly \n", forall (n in FunctionEntry)      (trace("FnAnnotationByUserOnly_Inner\n",isFunctionAnnotation[taint[n]] -> userAnnotatedFunction[n])));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control never leaves enclave except via valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XXX: broken input, annotations in controldep entry edge
constraint :: "NonCallControlEnclaveSafe"     trace("NonCallControlEnclaveSafe \n", forall (e in ControlDep_NonCall where isAnnotation(hasDest[e])==false) (trace("NonCallControlEnclaveSafe_Inner\n", eSafe(e))));
constraint :: "XDCallBlest"                   trace("XDCallBlest \n", forall (e in ControlDep_CallInv) ( trace("XDCallBlest_Inner\n",eCut(e) -> xdcBlest(e)))); % XXX: relax for optimization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data never leaves enclave except via parameters or return for valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetNonParmDataEnclaveSafe"  trace("NonRetNonParmDataEnclaveSafe \n", forall (e in DataEdgeNoRet where isAnnotation(hasDest[e])==false) (trace("NonRetNonParmDataEnclaveSafe_Inner\n", eSafe(e))));

constraint :: "XDCDataReturnAllowed"
 trace("XDCDataReturnAllowed \n", forall (e in DataDepEdge_Ret) (trace("XDCDataReturnAllowed_Inner\n",  eSafe(e) \/ allowOrRedact(cdfForRemoteLevel[taint[hasSource[e]], tLevel(hasDest[e])]))));

constraint :: "XDCParmAllowed"
 trace("XDCParmAllowed \n", forall (e in Parameter)       (trace("XDCParmAllowed_Inner\n",  eSafe(e) \/ allowOrRedact(cdfForRemoteLevel[taint[hasSource[e]], tLevel(hasDest[e])]))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels can only be cooerced inside enclave via parameters or return by noblest functions that are so blest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetDataTaintSafeOrCoerced"  trace("NonRetDataTaintSafeOrCoerced \n", forall (e in DataEdgeNoRet)   (trace("NonRetDataTaintSafeOrCoerced_Inner\n", eSafe(e) -> tSafe(e) \/ coercible(e))));
constraint :: "ReturnTaintSafeOrCoerced"      trace("ReturnTaintSafeOrCoerced \n", forall (e in DataDepEdge_Ret) (trace("ReturnTaintSafeOrCoerced_Inner\n", eSafe(e) -> tSafe(e) \/ rettaintSafe(e))));
constraint :: "ArgumentTaintSafeOrCoerced"    trace("ArgumentTaintSafeOrCoerced \n", forall (e in Parameter)       (trace("ArgumentTaintSafeOrCoerced_Inner\n", eSafe(e) -> tSafe(e) \/ argtaintSafe(e))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sanity checks, may add more here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         

debug = true;

constraint :: "CallSiteWithinFunctionAndCallsFunctionEntry"
 trace("CallSiteWithinFunctionAndCallsFunctionEntry \n", forall (e in ControlDep_CallInv) (trace("CallSiteWithinFunctionAndCallsFunctionEntry_Inner\n", debug==true -> hasFunction[hasSource[e]]!=0 /\ isFunctionEntry(hasDest[e]))));

constraint :: "ControlEdgeNonCallMustBeIntraFunction"
 trace("ControlEdgeNonCallMustBeIntraFunction \n", forall (e in ControlDep_NonCall) (trace("ControlEdgeNonCallMustBeIntraFunction_Inner\n", debug==true -> hasFunction[hasSource[e]]==hasFunction[hasDest[e]])));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_CallInv where xdcall[e])(1);
solve minimize objective;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output ["Domain assignments for globals:" ++ "\n"];
output [" GLOBAL   : " ++ show(x) ++ " -> " ++ show(varnodeEnclave[x])   ++ "::" ++ show(taint[x]) ++ "\n" | x in Global] ;
output ["Domain assignments for functions:" ++ "\n"];
output [" FUNCTION : " ++ show(x) ++ " -> " ++ show(functionEnclave[x]) ++ "::" ++ show(taint[x]) ++ "\n" | x in FunctionEntry ] ;
output ["Cross-domain cut:" ++ "\n"];
output [" XDCALL   : " ++ "(" ++ show(hasSource[e]) ++ ":" ++ show(taint[hasSource[e]]) ++ ")"
                       ++ "--[" ++ show(functionEnclave[hasFunction[hasSource[e]]]) ++ "]"
                       ++ "--||-->"
                       ++ "[" ++ show(functionEnclave[hasDest[e]]) ++ "]--"
                       ++ "(" ++ show(hasDest[e]) ++ ":" ++ show(taint[hasDest[e]]) ++ ")"
                       ++ "\n"
        | e in ControlDep_CallInv where fix(xdcall[e]==true)] ;

output [if debug then "Label and Enclave assignments to non-annotation nodes:\n" else "" endif];
output [" ASSIGN   : " ++
 show(n) ++ " " ++
 (if     (n>=VarNode_start /\ n<=VarNode_end)              then "VarNode       "
  elseif (n>=FunctionEntry_start /\ n<=FunctionEntry_end)  then "FunctionEntry "
  elseif (n>=Inst_start /\ n<=Inst_end)                    then "Inst          "
  elseif (n>=Param_start /\ n<=Param_end)                  then "Param         "
  else                                                          "Annotation    "
  endif)
 ++ "[" ++
 show(
  if     (n>=VarNode_start /\ n<=VarNode_end)              then varnodeEnclave[n]
  elseif (n>=FunctionEntry_start /\ n<=FunctionEntry_end)  then functionEnclave[n]
  elseif (n>=Inst_start /\ n<=Inst_end)                    then functionEnclave[hasFunction[n]]
  elseif (n>=Param_start /\ n<=Param_end)                  then functionEnclave[hasFunction[n]]
  else   nullEnclave
  endif)
 ++ "]::" ++ show(taint[n]) ++ "\n"
 | n in PDGNodeIdx where debug];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
