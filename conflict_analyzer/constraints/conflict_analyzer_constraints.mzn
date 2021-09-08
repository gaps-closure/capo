%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flag to include/exclude debug output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debug = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

predicate isVarNode(var PDGNodeIdx: n)         = (n>=VarNode_start /\ n<=VarNode_end);
predicate isFunctionEntry(var PDGNodeIdx: n)   = (n>=FunctionEntry_start /\ n<=FunctionEntry_end);
predicate isInst(var PDGNodeIdx: n)            = (n>=Inst_start /\ n<=Inst_end);
predicate isParam(var PDGNodeIdx: n)           = (n>=Param_start /\ n<=Param_end);
predicate isAnnotation(var PDGNodeIdx: n)      = (n>=Annotation_start /\ n<=Annotation_end);
predicate isParam_ActualIn(var PDGNodeIdx: n)  = (n>=Param_ActualIn_start /\ n<=Param_ActualIn_end);
predicate isParam_ActualOut(var PDGNodeIdx: n) = (n>=Param_ActualOut_start /\ n<=Param_ActualOut_end);

function var Level: tLevel(var PDGNodeIdx: n)  = (hasLabelLevel[taint[n]]);
function var Level: eLevel(var PDGNodeIdx: n)  = (hasEnclaveLevel[nodeEnclave[n]]);

predicate lCut(var PDGEdgeIdx: e)              = (hasLabelLevel[taint[hasSource[e]]]!=hasLabelLevel[taint[hasDest[e]]]);
predicate tCut(var PDGEdgeIdx: e)              = (taint[hasSource[e]]!=taint[hasDest[e]]);
predicate tSafe(var PDGEdgeIdx: e)             = (taint[hasSource[e]]==taint[hasDest[e]]);
predicate eCut(var PDGEdgeIdx: e)              = (nodeEnclave[hasSource[e]]!=nodeEnclave[hasDest[e]]);
predicate eSafe(var PDGEdgeIdx: e)             = (nodeEnclave[hasSource[e]]==nodeEnclave[hasDest[e]]);
predicate allowOrRedact(var cdf: c)            = (hasGuardOperation[c]==allow \/ hasGuardOperation[c]==redact);

predicate xdcBlest(var ControlDep_CallInv: e)  =
 (if isFunctionAnnotation[taint[hasDest[e]]] then allowOrRedact(cdfForRemoteLevel[taint[hasDest[e]], eLevel(hasSource[e])]) else false endif);

predicate rettaintSafe(var DataDepEdge_Ret: e) =
 (if isFunctionAnnotation[taint[hasFunction[hasSource[e]]]]
  then hasRettaints[cdfForRemoteLevel[taint[hasFunction[hasSource[e]]], tLevel(hasDest[e])], taint[hasDest[e]]]
  else false
  endif);

predicate argtaintSafe(var Parameter: e)       =
 (if isFunctionAnnotation[taint[hasFunction[hasDest[e]]]] /\ isParam_ActualIn(hasDest[e])
  then hasArgtaints[cdfForRemoteLevel[taint[hasFunction[hasDest[e]]], tLevel(hasSource[e])], hasParamIdx[hasDest[e]], taint[hasSource[e]]]
  elseif isFunctionAnnotation[taint[hasFunction[hasSource[e]]]] /\  isParam_ActualOut(hasSource[e])
  then hasArgtaints[cdfForRemoteLevel[taint[hasFunction[hasSource[e]]], tLevel(hasDest[e])], hasParamIdx[hasSource[e]], taint[hasDest[e]]]
  else coercible(e)
  endif);

predicate isInArctaint(var cleLabel: fan, var cleLabel: tnt, var Level: lvl) =
 (if isFunctionAnnotation[fan] then hasARCtaints[cdfForRemoteLevel[fan, lvl], tnt] else false endif);

predicate coercible(var DataEdgeNoRetParam: e) =
 (if (hasFunction[hasSource[e]]!=0 /\ hasFunction[hasDest[e]]!=0 /\ hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
  then isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasDest[e]],   tLevel(hasDest[e])) /\
       isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasSource[e]], tLevel(hasSource[e]))  % source and dest taints okay
  elseif (isVarNode(hasDest[e]) /\ hasFunction[hasSource[e]]!=0)
  then isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasDest[e]],   tLevel(hasDest[e])) /\
       isInArctaint(taint[hasFunction[hasSource[e]]], taint[hasSource[e]], tLevel(hasSource[e]))
  elseif (isVarNode(hasSource[e]) /\ hasFunction[hasDest[e]]!=0)
  then isInArctaint(taint[hasFunction[hasDest[e]]],   taint[hasSource[e]], tLevel(hasSource[e])) /\
       isInArctaint(taint[hasFunction[hasDest[e]]],   taint[hasDest[e]],   tLevel(hasDest[e]))
  else false
  endif);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "VarNodeHasEnclave"             forall (n in VarNode)            (nodeEnclave[n]!=nullEnclave);
constraint :: "FunctionHasEnclave"            forall (n in FunctionEntry)      (nodeEnclave[n]!=nullEnclave);
constraint :: "InstHasEnclave"                forall (n in Inst)               (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "ParamHasEnclave"               forall (n in Param)              (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "AnnotationHasNoEnclave"        forall (n in Annotation)         (nodeEnclave[n]==nullEnclave);

constraint :: "CallInvInCut"                  forall (e in ControlDep_CallInv) (xdcall[e] <-> eCut(e));

constraint :: "NodeLevelAtTaintLevel"         forall (n in NonAnnotation)      (nodeLevel[n]==tLevel(n));
constraint :: "NodeLevelAtEnclaveLevel"       forall (n in NonAnnotation)      (nodeLevel[n]==eLevel(n));
constraint :: "FnAnnotationForFnOnly"         forall (n in NonAnnotation)      (isFunctionAnnotation[taint[n]] -> isFunctionEntry(n));
constraint :: "FnAnnotationByUserOnly"        forall (n in FunctionEntry)      (isFunctionAnnotation[taint[n]] -> userAnnotatedFunction[n]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control never leaves enclave except via valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XXX: broken input, annotations in controldep entry edge
constraint :: "NonCallControlEnclaveSafe"     forall (e in ControlDep_NonCall where isAnnotation(hasDest[e])==false) (eSafe(e));
constraint :: "XDCallBlest"                   forall (e in ControlDep_CallInv) (eCut(e) -> xdcBlest(e)); % XXX: relax for optimization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data never leaves enclave except via parameters or return for valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetNonParmDataEnclaveSafe"  forall (e in DataEdgeNoRet) (eSafe(e));

constraint :: "XDCDataReturnAllowed"
 forall (e in DataDepEdge_Ret) (eSafe(e) \/ allowOrRedact(cdfForRemoteLevel[taint[hasSource[e]], tLevel(hasDest[e])]));

constraint :: "XDCParmAllowed"
 forall (e in Parameter)       (eSafe(e) \/ allowOrRedact(cdfForRemoteLevel[taint[hasSource[e]], tLevel(hasDest[e])]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels can only be cooerced inside enclave via parameters or return by noblest functions that are so blest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetDataTaintSafeOrCoerced"  forall (e in DataEdgeNoRet)   (eSafe(e) -> tSafe(e) \/ coercible(e));
constraint :: "ReturnTaintSafeOrCoerced"      forall (e in DataDepEdge_Ret) (eSafe(e) -> tSafe(e) \/ rettaintSafe(e));
constraint :: "ArgumentTaintSafeOrCoerced"    forall (e in Parameter)       (eSafe(e) -> tSafe(e) \/ argtaintSafe(e));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_CallInv where xdcall[e])(1);
solve minimize objective;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output ["Domain assignments for globals:" ++ "\n"];
output [" GLOBAL   : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x])   ++ "::" ++ show(taint[x]) ++ "\n" | x in Global] ;
output ["Domain assignments for functions:" ++ "\n"];
output [" FUNCTION : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x]) ++ "::" ++ show(taint[x]) ++ "\n" | x in FunctionEntry ] ;
output ["Cross-domain cut:" ++ "\n"];
output [" XDCALL   : " ++ "(" ++ show(hasSource[e]) ++ ":" ++ show(taint[hasSource[e]]) ++ ")"
                       ++ "--[" ++ show(nodeEnclave[hasFunction[hasSource[e]]]) ++ "]"
                       ++ "--||-->"
                       ++ "[" ++ show(nodeEnclave[hasDest[e]]) ++ "]--"
                       ++ "(" ++ show(hasDest[e]) ++ ":" ++ show(taint[hasDest[e]]) ++ ")"
                       ++ "\n"
        | e in ControlDep_CallInv where fix(xdcall[e]==true)] ;

output [if debug then "Label and Enclave assignments to non-annotation nodes:\n" else "" endif];

output [" ASSIGN   : " ++
 show(n) ++ " " ++
 (if     (n>=VarNode_start       /\ n<=VarNode_end)       then "VarNode       "
  elseif (n>=FunctionEntry_start /\ n<=FunctionEntry_end) then "FunctionEntry "
  elseif (n>=Inst_start          /\ n<=Inst_end)          then "Inst          "
  elseif (n>=Param_start         /\ n<=Param_end)         then "Param         "
  else                                                         "Annotation    "
  endif)
 ++ "[" ++
 show(nodeEnclave[n])
 ++ "]::" ++ show(taint[n]) ++ "\n"
 | n in PDGNodeIdx where debug];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
