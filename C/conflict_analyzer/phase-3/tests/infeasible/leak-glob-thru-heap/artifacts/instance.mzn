cleLabel = { nullCleLabel, BAR, ORANGE_NOSHARE, ORANGE_SHARE };
hasLabelLevel = [ nullLevel, orange, orange, orange ];
isFunctionAnnotation = [ false, true, false, false ];
cdf = { nullCdf, BAR_cdf_0 };
fromCleLabel = [ nullCleLabel, BAR ];
hasRemotelevel = [ nullLevel, orange ];
hasDirection = [ nullDirection, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow ];
isOneway = [ false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, BAR_cdf_0,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, false, true
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, true, true
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false,
  false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, true, true, true
]);
Inst_FunCall_start = 1;
Inst_FunCall_end = 4;
Inst_Ret_start = 5;
Inst_Ret_end = 6;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 7;
Inst_Other_end = 21;
Inst_start = 1;
Inst_end = 21;
VarNode_StaticGlobal_start = 22;
VarNode_StaticGlobal_end = 22;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 22;
VarNode_end = 22;
FunctionEntry_start = 23;
FunctionEntry_end = 24;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 25;
Param_end = 24;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 25;
Annotation_Global_end = 25;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 25;
Annotation_end = 25;
PDGNode_start = 1;
PDGNode_end = 25;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 23;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 23;
DataDepEdge_DefUse_start = 24;
DataDepEdge_DefUse_end = 39;
DataDepEdge_RAW_start = 40;
DataDepEdge_RAW_end = 41;
DataDepEdge_Ret_start = 42;
DataDepEdge_Ret_end = 42;
DataDepEdge_Alias_start = 43;
DataDepEdge_Alias_end = 46;
DataDepEdge_start = 24;
DataDepEdge_end = 46;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 47;
Parameter_end = 46;
Anno_Global_start = 47;
Anno_Global_end = 48;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 47;
Anno_end = 48;
DataDepEdge_PointsTo_start = 49;
DataDepEdge_PointsTo_end = 60;
PDGEdge_start = 1;
PDGEdge_end = 60;
hasFunction = [
23,23,24,24,23,24,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,0,23,24,0
];
hasSource = [
4,5,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,22,7,7,7,2,8,10,11,13,14,15,15,4,18,19,20,9,17,5,8,10,13,18,22,23,5,7,2,8,10,11,13,15,4,18,19,20
];
hasDest = [
23,4,7,1,2,8,9,10,11,12,13,5,14,15,16,3,4,17,18,19,20,21,6,11,13,10,9,8,9,12,12,5,16,18,17,17,19,20,21,10,18,4,2,8,8,4,25,25,2,2,22,2,2,22,2,2,2,2,22,22
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx22" taint[22]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx23" taint[23]=BAR;
Level = { nullLevel, orange };
Enclave = { nullEnclave, orange_E };
hasEnclaveLevel = [ nullLevel, orange ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flag to include/exclude debug output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debug = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

predicate isVarNode(PDGNodeIdx: n)         = (n>=VarNode_start /\ n<=VarNode_end);
predicate isFunctionEntry(PDGNodeIdx: n)   = (n>=FunctionEntry_start /\ n<=FunctionEntry_end);
predicate isAnnotation(PDGNodeIdx: n)      = (n>=Annotation_start /\ n<=Annotation_end);
predicate isParam_ActualIn(PDGNodeIdx: n)  = (n>=Param_ActualIn_start /\ n<=Param_ActualIn_end) /\ hasParamIdx[n] > 0;
predicate isParam_ActualOut(PDGNodeIdx: n) = (n>=Param_ActualOut_start /\ n<=Param_ActualOut_end) /\ hasParamIdx[n] > 0;
predicate allowOrRedact(var cdf: c)        = (hasGuardOperation[c]==allow \/ hasGuardOperation[c]==redact);

predicate sourceAnnotFun(PDGEdgeIdx: e) =
 (if hasFunction[hasSource[e]]!=0 then userAnnotatedFunction[hasFunction[hasSource[e]]] else false endif);

predicate destAnnotFun(PDGEdgeIdx: e) =
 (if hasFunction[hasDest[e]]!=0 then userAnnotatedFunction[hasFunction[hasDest[e]]] else false endif);

predicate isInArctaint(var cleLabel: fan, var cleLabel: tnt, var Level: lvl) =
 (if isFunctionAnnotation[fan] then hasARCtaints[cdfForRemoteLevel[fan, lvl], tnt] else false endif);

predicate xdedge(PDGEdgeIdx: e) = nodeEnclave[hasSource[e]] != nodeEnclave[hasDest[e]];

function var cleLabel: esTaint(PDGEdgeIdx: e) = taint[hasSource[e]];
function var cleLabel: edTaint(PDGEdgeIdx: e) = taint[hasDest[e]];

function var cleLabel: esFunTaint(PDGEdgeIdx: e) = if sourceAnnotFun(e) then taint[hasFunction[hasSource[e]]] else nullCleLabel endif;
function var cleLabel: edFunTaint(PDGEdgeIdx: e) = if destAnnotFun(e)   then taint[hasFunction[hasDest[e]]]   else nullCleLabel endif;

function var cdf: esFunCdf(PDGEdgeIdx: e) = if sourceAnnotFun(e) then cdfForRemoteLevel[esFunTaint(e), hasLabelLevel[edTaint(e)]] else nullCdf endif;
function var cdf: edFunCdf(PDGEdgeIdx: e) = if destAnnotFun(e)   then cdfForRemoteLevel[edFunTaint(e), hasLabelLevel[esTaint(e)]] else nullCdf endif;

function var cleLabel: ftaint(PDGNodeIdx: n) = if hasFunction[n]!=0 then taint[hasFunction[n]] else nullCleLabel endif;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "VarNodeHasEnclave"             forall (n in VarNode)            (nodeEnclave[n]!=nullEnclave);
constraint :: "FunctionHasEnclave"            forall (n in FunctionEntry)      (nodeEnclave[n]!=nullEnclave);
constraint :: "InstHasEnclave"                forall (n in Inst)               (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "ParamHasEnclave"               forall (n in Param)              (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "AnnotationHasNoEnclave"        forall (n in Annotation)         (nodeEnclave[n]==nullEnclave);

constraint :: "NodeLevelAtEnclaveLevel"       forall (n in NonAnnotation)      (hasLabelLevel[taint[n]] == hasEnclaveLevel[nodeEnclave[n]]);
constraint :: "FnAnnotationForFnOnly"         forall (n in NonAnnotation)      (isFunctionAnnotation[taint[n]] -> isFunctionEntry(n));
constraint :: "FnAnnotationByUserOnly"        forall (n in FunctionEntry)      (isFunctionAnnotation[taint[n]] -> userAnnotatedFunction[n]);

constraint :: "UnannotatedFunContentTaintMatch"
 forall (n in NonAnnotation where hasFunction[n]!=0) (userAnnotatedFunction[hasFunction[n]] == false -> taint[n] == ftaint(n));

constraint :: "AnnotatedFunContentCoercible"
 forall (n in NonAnnotation where hasFunction[n]!=0 /\ isFunctionEntry(n)==false) 
  (userAnnotatedFunction[hasFunction[n]] -> isInArctaint(ftaint(n), taint[n], hasLabelLevel[taint[n]]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control never leaves enclave except via valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XXX: broken input, annotations in controldep entry edge
constraint :: "NonCallControlEnclaveSafe"     forall (e in ControlDep_NonCall where isAnnotation(hasDest[e])==false) (xdedge(e)==false);
constraint :: "XDCallBlest"                   forall (e in ControlDep_CallInv) (xdedge(e) -> userAnnotatedFunction[hasDest[e]]);

constraint :: "XDCallAllowed"
 forall (e in ControlDep_CallInv) (xdedge(e) -> allowOrRedact(cdfForRemoteLevel[edTaint(e), hasLabelLevel[esTaint(e)]]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data never leaves enclave except via parameters or return for valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "NonRetNonParmDataEnclaveSafe"  forall (e in DataEdgeNoRet)      (xdedge(e)==false);

constraint :: "XDCDataReturnAllowed"
 forall (e in DataDepEdge_Ret) (xdedge(e) -> allowOrRedact(cdfForRemoteLevel[esTaint(e), hasLabelLevel[edTaint(e)]]));

constraint :: "XDCParmAllowed"
 forall (e in Parameter)       (xdedge(e) -> allowOrRedact(cdfForRemoteLevel[esTaint(e), hasLabelLevel[edTaint(e)]]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels can only be cooerced inside enclave via parameters or return by noblest functions that are so blest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intra-function and function-to-global edges %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: this constraint subsumed by
% AnnotatedFunContentCoercible and 
% UnannotatedFunContentTaintMatch,
% so it is commented out

% For intra-function data edges:
%   -If the function is un-annotated, the taints must match
%   -If the function is annotated, both endpoints
%    must have labels which are in the ARCtaints of the function.
% predicate intraFunctionEdge(PDGEdgeIdx: e) =
%   (hasFunction[hasSource[e]] == hasFunction[hasDest[e]] /\
%    hasFunction[hasSource[e]] != 0);
% constraint :: "UnannotatedIntraFunctionDataEdgeTaintsMatch"
%   forall (e in DataEdgeNoRet)
%     (intraFunctionEdge(e) /\ !sourceAnnotFun(e)
%       -> esTaint(e) == edTaint(e));
% constraint :: "AnnotatedIntraFunctionDataEdgeInArctaints"
%   forall (e in DataEdgeNoRet)
%     (intraFunctionEdge(e) /\  sourceAnnotFun(e)
%       -> isInArctaint(esFunTaint(e), edTaint(e), hasLabelLevel[edTaint(e)]) /\
%          isInArctaint(esFunTaint(e), esTaint(e), hasLabelLevel[esTaint(e)]));

% For data edges between a function and external data not in any
% function:
%   -If the function is annotated, the taint on the 
%    external node must be in the function's ARCtaints.
%   -If the function is un-annotated, the taints must match.
predicate interFunEdge(PDGEdgeIdx: e) =
  (hasFunction[hasSource[e]] != 0 /\ hasFunction[hasDest[e]] != 0 /\
   hasFunction[hasSource[e]] != hasFunction[hasDest[e]]);
predicate srcFunExternEdge(PDGEdgeIdx: e) =
  (hasFunction[hasSource[e]] != 0 /\ hasFunction[hasDest[e]] == 0);
predicate destFunExternEdge(PDGEdgeIdx: e) =
  (hasFunction[hasDest[e]] != 0 /\ hasFunction[hasSource[e]] == 0);

predicate externUnannotated(PDGEdgeIdx: e) =
  ((srcFunExternEdge(e)  /\ not sourceAnnotFun(e)) \/
   (destFunExternEdge(e) /\ not destAnnotFun(e)));
predicate srcFunExternAnnotated(PDGEdgeIdx: e) =
  (srcFunExternEdge(e) /\ sourceAnnotFun(e));
predicate destFunExternAnnotated(PDGEdgeIdx: e) =
  (destFunExternEdge(e) /\ destAnnotFun(e));

constraint :: "UnannotatedExternDataEdgeTaintsMatch"
  forall (e in DataEdgeParam)
    (externUnannotated(e) -> esTaint(e) == edTaint(e));
constraint :: "AnnotatedExternDataEdgeInArctaints"
  forall (e in DataEdgeParam)
    ((srcFunExternAnnotated(e) ->
       isInArctaint(esFunTaint(e), edTaint(e), hasLabelLevel[edTaint(e)])) /\
     (destFunExternAnnotated(e) ->
       isInArctaint(edFunTaint(e), esTaint(e), hasLabelLevel[esTaint(e)])));

%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-function edges %
%%%%%%%%%%%%%%%%%%%%%%%%

% For return edges from a callee function to a callsite:
%   -If the callee (source) function is un-annotated, the taints must match
%   -If the callee (source) function is annotated, the taint on the dest node
%    must be in the callee's rettaints (or it's a cross-domain edge)
constraint :: "retEdgeFromUnannotatedTaintsMatch"
  forall (e in DataDepEdge_Ret)
    (not sourceAnnotFun(e)
      -> esTaint(e) == edTaint(e));
constraint :: "returnNodeInRettaints"
  forall (e in DataDepEdge_Ret)
    (sourceAnnotFun(e)
      -> (hasRettaints[esFunCdf(e), edTaint(e)] \/ xdedge(e)));

% For caller to callee parameter-in edges:
%   -If the destination function is un-annotated, the taints must match
%   -If the destination function is annotated, the taint on the source node
%    must be in the argtaints of the corresponding parameter index
%    (or it's a cross-domain edge)
constraint :: "paramEdgeToUnannotatedTaintsMatch"
  forall (e in Parameter_In)
    (isParam_ActualIn(hasDest[e]) /\ not destAnnotFun(e)
      -> esTaint(e) == edTaint(e));
constraint :: "paramterInSourceInArgtaints"
  forall (e in Parameter_In)
    ((isParam_ActualIn(hasDest[e]) /\ destAnnotFun(e))
      -> (hasArgtaints[edFunCdf(e), hasParamIdx[hasDest[e]], esTaint(e)] \/ xdedge(e)));

% For callee to caller parameter-out edges:
%   -If the source function is un-annotated, the taints must match
%   -If the source function is annotated, the taint on the destination node
%    must be in the argtaints of the corresponding parameter index
%    (or it's a cross-domain edge)
constraint :: "paramEdgeFromUnannotatedTaintsMatch"
  forall (e in Parameter_Out)
    (isParam_ActualOut(hasSource[e]) /\ not sourceAnnotFun(e)
      -> esTaint(e) == edTaint(e));
constraint :: "parameterOutDestInArgtaints"
  forall (e in Parameter_Out)
    (isParam_ActualOut(hasSource[e]) /\ sourceAnnotFun(e)
      -> hasArgtaints[esFunCdf(e), hasParamIdx[hasSource[e]], edTaint(e)] \/ xdedge(e));

% Some Parameter edges are not covered in the above sets. If they are
% intra-function or function-extern edges, they will be constrained by
% UnannotatedExternDataEdgeTaintsMatch and
% AnnotatedExternDataEdgeInArctaints.
% If they are inter-function edges, however, they are unconstrained.
% Therefore we introduce the below constraints on inter-function "other"
% parameter edges to say that the taints must match. This is conservative;
% I do not know whether any inter-function parameter edges exist which are
% not included in the above constraints, and if so, what the constraints on
% them ought to be.
constraint :: "interFunOtherParamInTaintsMatch"
  forall (e in Parameter_In)
    ((not isParam_ActualIn(hasDest[e])) /\ interFunEdge(e)
      -> esTaint(e) == edTaint(e) \/ xdedge(e));
constraint :: "interFunOtherParamOutTaintsMatch"
  forall (e in Parameter_Out)
    ((not isParam_ActualOut(hasSource[e])) /\ interFunEdge(e)
      -> esTaint(e) == edTaint(e) \/ xdedge(e));
constraint :: "interFunParameterFieldTaintsMatch"
  forall (e in Parameter_Field)
    (interFunEdge(e)
      -> esTaint(e) == edTaint(e) \/ xdedge(e));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phase 3 edge constraints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Indirect call invocations cannot be cross-domain.
constraint :: "IndirectCallSameEnclave"
  forall (e in ControlDep_Indirect_CallInv)
    (xdedge(e) == false);

% MISSING:
% Parameter and return edges of indirect calls must satisfy 
% the same constraints as their direct call counter-parts.
% N.B: If we continue to constrain pointed-to functions to be
% un-annotated, we have the option of not implementing this
% constraint and the associated edges, because they would be
% redundant. The indirect callee would always be un-annotated,
% in which case the only constraint on the parameter and 
% return edges is matching taints, but the points-to edge to
% the callee will already accomplish this.

% Endpoints of a points-to edge must be in the same enclave.
constraint :: "PointsToSameEnclave"
  forall (e in DataDepEdge_PointsTo)
    (xdedge(e) == false);

% Endpoints of a points-to edge must have the same taint
% (including cases in which either endpoint is 
% global/module-static/function).
% Sometimes pointer dependencies are captured by a chain
% of points-to edges which may be intra-function edges. Therefore
% we restrict intra-function points-to edges to have the
% same taint, even in annotated functions.
constraint :: "PointsToTaintsMatch"
  forall (e in DataDepEdge_PointsTo)
    (esTaint(e) == edTaint(e));

% MISSING:
% If two global variables are connected by a def-use edge,
% they must have the same taint.

% Any function whose address is taken in the program 
% cannot have a function annotation. Indirect callees,
% as a consequence, cannot have a function annotation,
% but we include the constraint separately for completeness.
constraint :: "FunctionPtrSinglyTainted"
  forall (e in DataDepEdge_PointsTo)
    (isFunctionEntry(hasDest[e]) -> not userAnnotatedFunction[hasDest[e]]);
constraint :: "IndirectCalleeSinglyTainted"
  forall (e in ControlDep_Indirect_CallInv)
    (not userAnnotatedFunction[hasDest[e]]);

% MISSING:
% A structure or array and all its fields/elements 
% must have the same taint

% MISSING:
% External callback subgraph constraint

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_CallInv where xdedge(e))(1);
solve minimize objective;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output ["Domain assignments for globals:" ++ "\n"];
output [" GLOBAL   : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x]) ++ "::" ++ show(taint[x]) ++ "::" ++ show(hasLabelLevel[taint[x]]) ++ "\n" | x in Global];
output ["Domain assignments for functions:" ++ "\n"];
output [" FUNCTION : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x]) ++ "::" ++ show(taint[x]) ++ "::" ++ show(hasLabelLevel[taint[x]]) ++ "\n" | x in FunctionEntry ] ;
output ["Cross-domain cut:" ++ "\n"];
output [" XDCALL   : " ++ "(" ++ show(hasSource[e]) ++ ":" ++ show(taint[hasSource[e]]) ++ ")"
                       ++ "--[" ++ show(nodeEnclave[hasFunction[hasSource[e]]]) ++ "]"
                       ++ "--||-->"
                       ++ "[" ++ show(nodeEnclave[hasDest[e]]) ++ "]--"
                       ++ "(" ++ show(hasDest[e]) ++ ":" ++ show(taint[hasDest[e]]) ++ ")"
                       ++ "\n"
        | e in ControlDep_CallInv where fix(nodeEnclave[hasSource[e]] != nodeEnclave[hasDest[e]])] ;

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
 ++ "]::" ++ show(taint[n]) ++ "::" ++ show(hasLabelLevel[taint[n]]) ++ "\n"
 | n in PDGNodeIdx where debug];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDG Nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int: Inst_FunCall_start;
int: Inst_FunCall_end;
int: Inst_Ret_start;
int: Inst_Ret_end;
int: Inst_Br_start;
int: Inst_Br_end;
int: Inst_Other_start;
int: Inst_Other_end;
int: Inst_start;
int: Inst_end;

int: VarNode_StaticGlobal_start;
int: VarNode_StaticGlobal_end;
int: VarNode_StaticModule_start;
int: VarNode_StaticModule_end;
int: VarNode_StaticFunction_start;
int: VarNode_StaticFunction_end;
int: VarNode_StaticOther_start;
int: VarNode_StaticOther_end;
int: VarNode_start;
int: VarNode_end;

int: FunctionEntry_start;
int: FunctionEntry_end;

int: Param_FormalIn_start;
int: Param_FormalIn_end;
int: Param_FormalOut_start;
int: Param_FormalOut_end;
int: Param_ActualIn_start;
int: Param_ActualIn_end;
int: Param_ActualOut_start;
int: Param_ActualOut_end;
int: Param_start;
int: Param_end;

int: Annotation_Var_start;
int: Annotation_Var_end;
int: Annotation_Global_start;
int: Annotation_Global_end;
int: Annotation_Other_start;
int: Annotation_Other_end;
int: Annotation_start;
int: Annotation_end;

int: PDGNode_start;
int: PDGNode_end;

set of int: Inst = Inst_start .. Inst_end;

set of int: VarNode_StaticGlobal = VarNode_StaticGlobal_start .. VarNode_StaticGlobal_end;
set of int: VarNode_StaticModule = VarNode_StaticModule_start .. VarNode_StaticModule_end;
set of int: VarNode_StaticFunction = VarNode_StaticFunction_start .. VarNode_StaticFunction_end;
set of int: VarNode_StaticOther = VarNode_StaticOther_start .. VarNode_StaticOther_end;
set of int: VarNode = VarNode_start .. VarNode_end;

set of int: FunctionEntry = FunctionEntry_start .. FunctionEntry_end;

set of int: Param_FormalIn = Param_FormalIn_start .. Param_FormalIn_end;
set of int: Param_FormalOut = Param_FormalOut_start .. Param_FormalOut_end;
set of int: Param_ActualIn = Param_ActualIn_start .. Param_ActualIn_end;
set of int: Param_ActualOut = Param_ActualOut_start .. Param_ActualOut_end;
set of int: Param = Param_start .. Param_end;

set of int: Annotation_Var = Annotation_Var_start .. Annotation_Var_end;
set of int: Annotation_Global = Annotation_Global_start .. Annotation_Global_end;
set of int: Annotation_Other = Annotation_Other_start .. Annotation_Other_end;
set of int: Annotation  = Annotation_start .. Annotation_end;

set of int: PDGNodeIdx  = PDGNode_start .. PDGNode_end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDG Edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int: ControlDep_CallInv_start;
int: ControlDep_CallInv_end;
int: ControlDep_Indirect_CallInv_start;
int: ControlDep_Indirect_CallInv_end;
int: ControlDep_CallRet_start;
int: ControlDep_CallRet_end;
int: ControlDep_Entry_start;
int: ControlDep_Entry_end;
int: ControlDep_Br_start;
int: ControlDep_Br_end;
int: ControlDep_Other_start;
int: ControlDep_Other_end;
int: ControlDep_start;
int: ControlDep_end;

int: DataDepEdge_DefUse_start;
int: DataDepEdge_DefUse_end;
int: DataDepEdge_RAW_start;
int: DataDepEdge_RAW_end;
int: DataDepEdge_Ret_start;
int: DataDepEdge_Ret_end;
int: DataDepEdge_Alias_start;
int: DataDepEdge_Alias_end;
int: DataDepEdge_start;
int: DataDepEdge_end;

int: Parameter_In_start;
int: Parameter_In_end;
int: Parameter_Out_start;
int: Parameter_Out_end;
int: Parameter_Field_start;
int: Parameter_Field_end;
int: Parameter_start;
int: Parameter_end;

int: Anno_Global_start;
int: Anno_Global_end;
int: Anno_Var_start;
int: Anno_Var_end;
int: Anno_Other_start;
int: Anno_Other_end;
int: Anno_start;
int: Anno_end;

int: DataDepEdge_PointsTo_start;
int: DataDepEdge_PointsTo_end;

int: PDGEdge_start;
int: PDGEdge_end;

set of int: ControlDep_CallInv = ControlDep_CallInv_start .. ControlDep_CallInv_end;
set of int: ControlDep_Indirect_CallInv = ControlDep_Indirect_CallInv_start .. ControlDep_Indirect_CallInv_end;
set of int: ControlDep_CallRet = ControlDep_CallRet_start .. ControlDep_CallRet_end;
set of int: ControlDep_Entry = ControlDep_Entry_start .. ControlDep_Entry_end;
set of int: ControlDep_Br = ControlDep_Br_start .. ControlDep_Br_end;
set of int: ControlDep_Other = ControlDep_Other_start .. ControlDep_Other_end;
set of int: ControlDep = ControlDep_start .. ControlDep_end;

set of int: DataDepEdge_DefUse = DataDepEdge_DefUse_start .. DataDepEdge_DefUse_end;
set of int: DataDepEdge_RAW  = DataDepEdge_RAW_start .. DataDepEdge_RAW_end;
set of int: DataDepEdge_Ret  = DataDepEdge_Ret_start .. DataDepEdge_Ret_end;
set of int: DataDepEdge_Alias = DataDepEdge_Alias_start .. DataDepEdge_Alias_end;
set of int: DataDepEdge = DataDepEdge_start .. DataDepEdge_end;

set of int: Parameter_In = Parameter_In_start .. Parameter_In_end;
set of int: Parameter_Out = Parameter_Out_start .. Parameter_Out_end;
set of int: Parameter_Field = Parameter_Field_start .. Parameter_Field_end;
set of int: Parameter = Parameter_start .. Parameter_end;

set of int: Anno_Global = Anno_Global_start .. Anno_Global_end;
set of int: Anno_Var = Anno_Var_start .. Anno_Var_end;
set of int: Anno_Other = Anno_Other_start .. Anno_Other_end;
set of int: Anno = Anno_start .. Anno_end;

set of int: DataDepEdge_PointsTo = DataDepEdge_PointsTo_start .. DataDepEdge_PointsTo_end;

set of int: PDGEdgeIdx = PDGEdge_start .. PDGEdge_end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Containing Function for PDG Nodes, Endpoints for PDG Edges, Indices of Fucntion Formal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

array[PDGNodeIdx]     of int:  hasFunction;
array[PDGEdgeIdx]     of int:  hasSource;
array[PDGEdgeIdx]     of int:  hasDest;
array[Param]          of int:  hasParamIdx;
array[FunctionEntry]  of bool: userAnnotatedFunction;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convenience Aggregations of PDG Nodes and Edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set of int: Global              = VarNode_StaticGlobal union VarNode_StaticModule;
set of int: NonAnnotation       = Inst union VarNode union FunctionEntry union Param;
set of int: ControlDep_Call     = ControlDep_CallInv union ControlDep_CallRet;
set of int: ControlDep_NonCall  = ControlDep_Entry union ControlDep_Br union ControlDep_Other;
set of int: DataEdgeNoRet       = DataDepEdge_DefUse union DataDepEdge_RAW union DataDepEdge_Alias;
set of int: DataEdgeParam       = DataDepEdge union Parameter;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Security Levels and Enclaves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enum Level;
enum Enclave;
array[Enclave] of Level: hasEnclaveLevel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLE Input Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enum cleLabel;
enum cdf;
enum GuardOperation = {nullGuardOperation, allow, deny, redact};
enum Direction      = {nullDirection, bidirectional, egress, ingress};

int: MaxFuncParms;  % Max number of function parameters in the program (C<128, C++<256)
set of int: parmIdx = 1..MaxFuncParms;

array[cleLabel]                       of Level:          hasLabelLevel;
array[cleLabel]                       of bool:           isFunctionAnnotation;

array[cdf]                            of cleLabel:       fromCleLabel;
array[cdf]                            of Level:          hasRemotelevel;
array[cdf]                            of GuardOperation: hasGuardOperation;
array[cdf]                            of Direction:      hasDirection;
array[cdf]                            of bool:           isOneway;
array[cleLabel, Level]                of cdf:            cdfForRemoteLevel;

array[cdf, cleLabel]          of bool:           hasRettaints;
array[cdf, cleLabel]          of bool:           hasCodtaints;
array[cdf, parmIdx, cleLabel] of bool:           hasArgtaints;
array[cdf, cleLabel]          of bool:           hasARCtaints;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Debug flag and decision variables for the solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bool:                              debug;

array[PDGNodeIdx] of var Enclave:  nodeEnclave;
array[PDGNodeIdx] of var cleLabel: taint;
array[PDGEdgeIdx] of var bool:     coerced;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

