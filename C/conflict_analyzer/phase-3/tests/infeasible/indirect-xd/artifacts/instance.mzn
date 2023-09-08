cleLabel = { nullCleLabel, ORANGE, PURPLE };
hasLabelLevel = [ nullLevel, orange, purple ];
isFunctionAnnotation = [ false, false, false ];
cdf = { nullCdf };
fromCleLabel = [ nullCleLabel ];
hasRemotelevel = [ nullLevel ];
hasDirection = [ nullDirection ];
hasGuardOperation = [ nullGuardOperation ];
isOneway = [ false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false
]);
Inst_FunCall_start = 1;
Inst_FunCall_end = 11;
Inst_Ret_start = 12;
Inst_Ret_end = 14;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 15;
Inst_Other_end = 50;
Inst_start = 1;
Inst_end = 50;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 51;
VarNode_end = 50;
FunctionEntry_start = 51;
FunctionEntry_end = 53;
Param_FormalIn_start = 54;
Param_FormalIn_end = 56;
Param_FormalOut_start = 57;
Param_FormalOut_end = 59;
Param_ActualIn_start = 60;
Param_ActualIn_end = 62;
Param_ActualOut_start = 63;
Param_ActualOut_end = 65;
Param_start = 54;
Param_end = 65;
Annotation_Var_start = 66;
Annotation_Var_end = 67;
Annotation_Global_start = 0;
Annotation_Global_end = -1;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 66;
Annotation_end = 67;
PDGNode_start = 1;
PDGNode_end = 67;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 2;
ControlDep_Indirect_CallInv_end = 2;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 3;
ControlDep_Entry_start = 4;
ControlDep_Entry_end = 53;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 53;
DataDepEdge_DefUse_start = 54;
DataDepEdge_DefUse_end = 85;
DataDepEdge_GlobalDefUse_start = 0;
DataDepEdge_GlobalDefUse_end = -1;
DataDepEdge_RAW_start = 86;
DataDepEdge_RAW_end = 91;
DataDepEdge_Ret_start = 92;
DataDepEdge_Ret_end = 92;
DataDepEdge_Indirect_Ret_start = 93;
DataDepEdge_Indirect_Ret_end = 93;
DataDepEdge_Alias_start = 94;
DataDepEdge_Alias_end = 95;
DataDepEdge_ArgPass_In_start = 96;
DataDepEdge_ArgPass_In_end = 97;
DataDepEdge_ArgPass_Out_start = 98;
DataDepEdge_ArgPass_Out_end = 99;
DataDepEdge_ArgPass_Indirect_In_start = 100;
DataDepEdge_ArgPass_Indirect_In_end = 100;
DataDepEdge_ArgPass_Indirect_Out_start = 101;
DataDepEdge_ArgPass_Indirect_Out_end = 101;
DataDepEdge_Callee_start = 102;
DataDepEdge_Callee_end = 103;
DataDepEdge_start = 54;
DataDepEdge_end = 103;
Parameter_In_start = 104;
Parameter_In_end = 115;
Parameter_Out_start = 116;
Parameter_Out_end = 123;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 104;
Parameter_end = 123;
Anno_Global_start = 0;
Anno_Global_end = -1;
Anno_Var_start = 124;
Anno_Var_end = 131;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 124;
Anno_end = 131;
DataDepEdge_PointsTo_start = 132;
DataDepEdge_PointsTo_end = 135;
PDGEdge_start = 1;
PDGEdge_end = 135;
hasFunction = [
51,51,52,52,53,53,53,53,53,53,53,51,52,53,51,51,51,51,51,51,51,51,51,51,52,52,52,52,52,52,52,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,51,52,53,51,52,52,51,52,52,52,52,51,52,52,51,51,53
];
hasSource = [
11,9,13,51,51,51,51,51,51,51,51,51,51,51,51,51,52,52,52,52,52,52,52,52,52,52,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,15,15,16,16,16,22,23,24,25,25,26,26,29,30,31,32,33,33,33,34,34,34,35,35,36,37,45,46,9,48,49,11,17,21,27,28,43,44,13,12,18,39,48,49,63,64,46,65,9,11,54,51,52,52,55,56,48,49,11,11,60,61,51,52,52,48,49,11,11,11,51,18,19,20,53,39,40,41,18,35,39,45
];
hasDest = [
52,51,11,16,17,1,2,18,19,20,21,22,23,24,12,15,25,26,27,3,28,4,29,30,31,13,33,34,35,36,37,38,5,39,40,41,42,6,43,7,44,8,45,46,9,47,10,48,49,11,50,14,32,23,17,22,21,18,24,24,12,29,27,30,28,31,31,13,38,48,42,39,49,46,43,45,44,47,50,9,9,47,11,11,50,23,22,29,30,46,45,11,51,16,33,60,61,48,49,62,46,45,52,23,54,55,56,29,30,60,61,60,61,55,56,57,58,59,63,64,63,64,1,66,66,66,66,67,67,67,67,16,51,33,51
];
hasParamIdx = array1d(Param, [
1,1,2,1,1,2,1,2,1,1,2,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false,false
]);
MaxFuncParms = 2;
constraint :: "TaintOnNodeIdx18" taint[18]=PURPLE;
constraint :: "TaintOnNodeIdx39" taint[39]=ORANGE;
Level = { nullLevel, purple, orange };
Enclave = { nullEnclave, purple_E, orange_E };
hasEnclaveLevel = [ nullLevel, purple, orange ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flag to include/exclude debug output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debug = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

predicate isVarNode(PDGNodeIdx: n)         = (n>=VarNode_start /\ n<=VarNode_end);
predicate isFunctionEntry(PDGNodeIdx: n)   = (n>=FunctionEntry_start /\ n<=FunctionEntry_end);
predicate isFunCall(PDGNodeIdx: n)         = (n>=Inst_FunCall_start /\ n<=Inst_FunCall_end);
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

constraint :: "NonRetNonParmDataEnclaveSafe"
 forall (e in DataEdgeEnclaveSafe) (xdedge(e) == false);

constraint :: "XDCDataReturnAllowed"
 forall (e in DataDepEdge_Ret) (xdedge(e) -> allowOrRedact(cdfForRemoteLevel[esTaint(e), hasLabelLevel[edTaint(e)]]));

constraint :: "XDCParmAllowed"
 forall (e in DataDepEdge_ArgPass_In union DataDepEdge_ArgPass_Out)
   (xdedge(e) -> allowOrRedact(cdfForRemoteLevel[esTaint(e), hasLabelLevel[edTaint(e)]]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels can only be cooerced inside enclave via parameters or return by noblest functions that are so blest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intra-function and function-to-global edges %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For intra-function data edges:
%   -If the function is un-annotated, the taints must match
%   -If the function is annotated, both endpoints
%    must have labels which are in the ARCtaints of the function.
% Note: this constraint subsumed by
% AnnotatedFunContentCoercible and 
% UnannotatedFunContentTaintMatch

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
  forall (e in DataDepEdge)
    (externUnannotated(e) -> esTaint(e) == edTaint(e));
constraint :: "AnnotatedExternDataEdgeInArctaints"
  forall (e in DataDepEdge)
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
  forall (e in DataDepEdge_Ret union DataDepEdge_Indirect_Ret)
    (not sourceAnnotFun(e)
      -> esTaint(e) == edTaint(e));
constraint :: "returnNodeInRettaints"
  forall (e in DataDepEdge_Ret union DataDepEdge_Indirect_Ret)
    (sourceAnnotFun(e)
      -> (hasRettaints[esFunCdf(e), edTaint(e)] \/ xdedge(e)));

% For caller to callee parameter-in edges:
%   -If the destination function is un-annotated, the taints must match
%   -If the destination function is annotated, the taint on the source node
%    must be in the argtaints of the corresponding parameter index
%    (or it's a cross-domain edge)
constraint :: "argPassInEdgeToUnannotatedTaintsMatch"
  forall (e in DataDepEdge_ArgPass_In union DataDepEdge_ArgPass_Indirect_In)
    (not destAnnotFun(e)
      -> esTaint(e) == edTaint(e));
constraint :: "argPassInSourceInArgtaints"
  forall (e in DataDepEdge_ArgPass_In union DataDepEdge_ArgPass_Indirect_In)
    (destAnnotFun(e)
      -> hasArgtaints[edFunCdf(e), hasParamIdx[hasDest[e]], esTaint(e)] \/ xdedge(e));

% For callee to caller parameter-out edges:
%   -If the source function is un-annotated, the taints must match
%   -If the source function is annotated, the taint on the destination node
%    must be in the argtaints of the corresponding parameter index
%    (or it's a cross-domain edge)
constraint :: "argPassOutFromUnannotatedTaintsMatch"
  forall (e in DataDepEdge_ArgPass_Out union DataDepEdge_ArgPass_Indirect_Out)
    (not sourceAnnotFun(e)
      -> esTaint(e) == edTaint(e));
constraint :: "argPassOutDestInArgtaints"
  forall (e in DataDepEdge_ArgPass_Out union DataDepEdge_ArgPass_Indirect_Out)
    (sourceAnnotFun(e)
      -> hasArgtaints[esFunCdf(e), hasParamIdx[hasSource[e]], edTaint(e)] \/ xdedge(e));

% Parameter_Field edges are not captured by Argpass_In and Argpass_Out.
% If they are intra-function or function-extern edges, they will be 
% constrained appropriately by UnannotatedExternDataEdgeTaintsMatch and
% AnnotatedExternDataEdgeInArctaints.
% If they are inter-function edges, however, they are unconstrained.
% Therefore we introduce the below constraints on inter-function Parameter_Field
% edges to say that the taints must match. This is conservative, as I don't
% know exactly what the constraints on these edges ought to be.
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

% ArgPass and Ret edges of indirect calls must satisfy 
% the same constraints as their direct call counter-parts.
% They are included in the unions above for inter-function edges.

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

% If two global variables are connected by a def-use edge,
% they must have the same taint.
constraint :: "GlobalDefUseTaintsMatch"
  forall (e in DataDepEdge_GlobalDefUse)
    (esTaint(e) == edTaint(e));

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
int: DataDepEdge_GlobalDefUse_start;
int: DataDepEdge_GlobalDefUse_end;
int: DataDepEdge_RAW_start;
int: DataDepEdge_RAW_end;
int: DataDepEdge_Ret_start;
int: DataDepEdge_Ret_end;
int: DataDepEdge_Indirect_Ret_start;
int: DataDepEdge_Indirect_Ret_end;
int: DataDepEdge_Alias_start;
int: DataDepEdge_Alias_end;
int: DataDepEdge_ArgPass_In_start;
int: DataDepEdge_ArgPass_In_end;
int: DataDepEdge_ArgPass_Out_start;
int: DataDepEdge_ArgPass_Out_end;
int: DataDepEdge_ArgPass_Indirect_In_start;
int: DataDepEdge_ArgPass_Indirect_In_end;
int: DataDepEdge_ArgPass_Indirect_Out_start;
int: DataDepEdge_ArgPass_Indirect_Out_end;
int: DataDepEdge_Callee_start;
int: DataDepEdge_Callee_end;
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
set of int: DataDepEdge_GlobalDefUse = DataDepEdge_GlobalDefUse_start .. DataDepEdge_GlobalDefUse_end;
set of int: DataDepEdge_RAW  = DataDepEdge_RAW_start .. DataDepEdge_RAW_end;
set of int: DataDepEdge_Ret  = DataDepEdge_Ret_start .. DataDepEdge_Ret_end;
set of int: DataDepEdge_Indirect_Ret = DataDepEdge_Indirect_Ret_start .. DataDepEdge_Indirect_Ret_end;
set of int: DataDepEdge_Alias = DataDepEdge_Alias_start .. DataDepEdge_Alias_end;
set of int: DataDepEdge_ArgPass_In  = DataDepEdge_ArgPass_In_start .. DataDepEdge_ArgPass_In_end;
set of int: DataDepEdge_ArgPass_Out = DataDepEdge_ArgPass_Out_start .. DataDepEdge_ArgPass_Out_end;
set of int: DataDepEdge_ArgPass_Indirect_In  = DataDepEdge_ArgPass_Indirect_In_start  .. DataDepEdge_ArgPass_Indirect_In_end;
set of int: DataDepEdge_ArgPass_Indirect_Out = DataDepEdge_ArgPass_Indirect_Out_start .. DataDepEdge_ArgPass_Indirect_Out_end;
set of int: DataDepEdge_Callee = DataDepEdge_Callee_start .. DataDepEdge_Callee_end;
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
set of int: ControlDep_NonCall  = ControlDep_Entry union ControlDep_Br union ControlDep_Other;
set of int: DataEdgeEnclaveSafe = DataDepEdge_DefUse union DataDepEdge_GlobalDefUse union DataDepEdge_RAW union 
                                  DataDepEdge_Indirect_Ret union DataDepEdge_Alias union
                                  DataDepEdge_ArgPass_Indirect_In union 
                                  DataDepEdge_ArgPass_Indirect_Out;

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

