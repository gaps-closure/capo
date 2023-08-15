cleLabel = { nullCleLabel, ORANGE_XD, PURPLE_XD, ORANGE_SHAREABLE, PURPLE_SHAREABLE, TAG_RESPONSE_FOO, TAG_REQUEST_FOO };
hasLabelLevel = [ nullLevel, orange, purple, orange, purple, nullLevel, nullLevel ];
isFunctionAnnotation = [ false, true, true, false, false, false, false ];
cdf = { nullCdf, ORANGE_XD_cdf_0, PURPLE_XD_cdf_0, PURPLE_XD_cdf_1, ORANGE_SHAREABLE_cdf_0, PURPLE_SHAREABLE_cdf_0 };
fromCleLabel = [ nullCleLabel, ORANGE_XD, PURPLE_XD, PURPLE_XD, ORANGE_SHAREABLE, PURPLE_SHAREABLE ];
hasRemotelevel = [ nullLevel, orange, orange, purple, purple, orange ];
hasDirection = [ nullDirection, bidirectional, bidirectional, bidirectional, egress, egress ];
hasGuardOperation = [ nullGuardOperation, allow, allow, allow, allow, allow ];
isOneway = [ false, false, false, false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, ORANGE_XD_cdf_0, nullCdf,
  nullCdf, PURPLE_XD_cdf_0, PURPLE_XD_cdf_1,
  nullCdf, nullCdf, ORANGE_SHAREABLE_cdf_0,
  nullCdf, PURPLE_SHAREABLE_cdf_0, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false,
  false, false, false, true, false, false, false,
  false, false, false, false, false, true, false,
  false, false, false, false, false, true, false,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false,
  false, false, false, true, false, true, false,
  false, false, false, false, true, false, false,
  false, false, false, false, true, false, false,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false, false,
  false, false, false, true, false, false, false,
  false, false, false, false, false, false, true,
  false, false, false, false, false, false, true,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false,
  false, true, false, true, false, true, false,
  false, false, true, false, true, true, true,
  false, false, true, false, true, true, true,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
Inst_FunCall_start = 1;
Inst_FunCall_end = 10;
Inst_Ret_start = 11;
Inst_Ret_end = 14;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 15;
Inst_Other_end = 42;
Inst_start = 1;
Inst_end = 42;
VarNode_StaticGlobal_start = 43;
VarNode_StaticGlobal_end = 43;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 43;
VarNode_end = 43;
FunctionEntry_start = 44;
FunctionEntry_end = 47;
Param_FormalIn_start = 48;
Param_FormalIn_end = 52;
Param_FormalOut_start = 53;
Param_FormalOut_end = 57;
Param_ActualIn_start = 58;
Param_ActualIn_end = 62;
Param_ActualOut_start = 63;
Param_ActualOut_end = 67;
Param_start = 48;
Param_end = 67;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 68;
Annotation_Global_end = 68;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 68;
Annotation_end = 68;
PDGNode_start = 1;
PDGNode_end = 68;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 3;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 4;
ControlDep_CallRet_end = 6;
ControlDep_Entry_start = 7;
ControlDep_Entry_end = 48;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 48;
DataDepEdge_DefUse_start = 49;
DataDepEdge_DefUse_end = 77;
DataDepEdge_RAW_start = 78;
DataDepEdge_RAW_end = 83;
DataDepEdge_Ret_start = 84;
DataDepEdge_Ret_end = 86;
DataDepEdge_Alias_start = 87;
DataDepEdge_Alias_end = 88;
DataDepEdge_start = 49;
DataDepEdge_end = 88;
Parameter_In_start = 89;
Parameter_In_end = 105;
Parameter_Out_start = 106;
Parameter_Out_end = 115;
Parameter_Field_start = 116;
Parameter_Field_end = 123;
Parameter_start = 89;
Parameter_end = 123;
Anno_Global_start = 124;
Anno_Global_end = 126;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 124;
Anno_end = 126;
DataDepEdge_PointsTo_start = 127;
DataDepEdge_PointsTo_end = 148;
PDGEdge_start = 1;
PDGEdge_end = 148;
hasFunction = [
44,45,45,45,45,46,46,46,47,47,44,45,46,47,44,44,44,44,44,45,45,45,45,45,45,45,45,45,45,45,45,45,45,46,46,46,46,46,46,47,47,47,0,44,45,46,47,44,45,45,46,46,44,45,45,46,46,44,45,45,46,46,44,45,45,46,46,0
];
hasSource = [
5,8,9,11,12,13,44,44,44,44,44,44,44,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,46,46,46,46,46,46,46,46,46,46,47,47,47,47,47,47,43,43,15,15,15,17,18,20,20,21,21,22,22,22,24,26,27,29,31,32,33,34,34,35,35,37,39,40,42,16,23,25,28,36,38,11,12,13,26,39,43,48,44,45,33,5,49,46,39,8,51,9,58,59,60,61,62,44,45,5,46,8,9,63,64,66,67,49,54,51,56,59,64,61,66,43,44,45,43,44,65,15,64,20,21,22,24,26,27,29,31,32,67,66,34,35,37,39,47,40
];
hasDest = [
44,45,46,5,8,9,15,16,1,17,18,19,11,20,21,22,23,2,3,24,25,4,26,27,28,29,30,31,32,33,5,12,35,36,6,7,37,38,39,8,13,34,40,41,9,42,10,14,42,9,19,17,16,18,19,24,23,26,25,31,29,27,25,28,28,30,32,33,5,37,36,39,38,38,8,41,10,17,24,26,32,37,39,5,8,9,24,37,61,17,48,49,58,58,24,51,59,59,37,61,48,49,50,51,52,53,54,63,56,64,66,33,39,43,42,50,55,52,57,60,65,62,67,68,68,68,43,44,65,15,43,20,21,22,43,43,22,22,22,43,67,43,34,35,43,43,47,40
];
hasParamIdx = array1d(Param, [
1,1,-1,1,-1,1,1,-1,1,-1,1,1,-1,1,-1,1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true,true,true
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx43" taint[43]=ORANGE_SHAREABLE;
constraint :: "TaintOnNodeIdx44" taint[44]=PURPLE_XD;
constraint :: "TaintOnNodeIdx45" taint[45]=ORANGE_XD;
Level = { nullLevel, orange, purple };
Enclave = { nullEnclave, orange_E, purple_E };
hasEnclaveLevel = [ nullLevel, orange, purple ];
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
predicate isParam_ActualIn(PDGNodeIdx: n)  = (n>=Param_ActualIn_start /\ n<=Param_ActualIn_end);
predicate isParam_ActualOut(PDGNodeIdx: n) = (n>=Param_ActualOut_start /\ n<=Param_ActualOut_end);
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
constraint :: "XDCallBlest"                   forall (e in ControlDep_Call) (xdedge(e) -> userAnnotatedFunction[hasDest[e]]);

constraint :: "XDCallAllowed"
 forall (e in ControlDep_Call) (xdedge(e) -> allowOrRedact(cdfForRemoteLevel[edTaint(e), hasLabelLevel[esTaint(e)]]));

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

constraint :: "TaintsSafeOrCoerced"           forall (e in DataEdgeParam)      (((esTaint(e) != edTaint(e)) /\ (xdedge(e) == false)) -> coerced[e]);

% XXX: do we need something special for Parameter_Field?
constraint :: "ArgumentTaintCoerced"
 forall (e in Parameter_In union Parameter_Out)
  (if     destAnnotFun(e)   /\ isParam_ActualIn(hasDest[e])    /\ (hasParamIdx[hasDest[e]]>0)
   then coerced[e] == hasArgtaints[edFunCdf(e), hasParamIdx[hasDest[e]], esTaint(e)]
   elseif sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]]>0)
   then coerced[e] == hasArgtaints[esFunCdf(e), hasParamIdx[hasSource[e]], edTaint(e)]
   else true 
   endif);

constraint :: "ReturnTaintCoerced"
 forall (e in DataDepEdge_Ret) (coerced[e] == (if sourceAnnotFun(e) then hasRettaints[esFunCdf(e), edTaint(e)] else false endif));

constraint :: "DataTaintCoerced"
 forall (e in DataEdgeNoRetParam)
  (if (hasFunction[hasSource[e]]!=0 /\ hasFunction[hasDest[e]]!=0 /\ hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
   then coerced[e] == (isInArctaint(esFunTaint(e), edTaint(e), hasLabelLevel[edTaint(e)]) /\
                       isInArctaint(esFunTaint(e), esTaint(e), hasLabelLevel[esTaint(e)]))     % source and dest taints okay
   elseif (isVarNode(hasDest[e]) /\ hasFunction[hasSource[e]]!=0)
   then coerced[e] == (isInArctaint(esFunTaint(e), edTaint(e), hasLabelLevel[edTaint(e)]) /\
                       isInArctaint(esFunTaint(e), esTaint(e), hasLabelLevel[esTaint(e)]))
   elseif (isVarNode(hasSource[e]) /\ hasFunction[hasDest[e]]!=0)
   then coerced[e] == (isInArctaint(edFunTaint(e), esTaint(e), hasLabelLevel[esTaint(e)]) /\
                       isInArctaint(edFunTaint(e), edTaint(e), hasLabelLevel[edTaint(e)]))
   elseif (destAnnotFun(e) /\ isParam_ActualIn(hasDest[e]) /\ (hasParamIdx[hasDest[e]]>0)) \/ (sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]]>0))
   then true
   else coerced[e] == false
   endif);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phase 3 test constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "PtrAliasSameEnclave"
 forall (e in DataDepEdge_PointsTo)
  (xdedge(e) == false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_Call where xdedge(e))(1);
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
        | e in ControlDep_Call where fix(nodeEnclave[hasSource[e]] != nodeEnclave[hasDest[e]])] ;

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
set of int: ControlDep_Call     = ControlDep_CallInv union ControlDep_Indirect_CallInv;
set of int: ControlDep_NonCall  = ControlDep_Entry union ControlDep_Br union ControlDep_Other;
set of int: DataEdgeNoRet       = DataDepEdge_DefUse union DataDepEdge_RAW union DataDepEdge_Alias;
set of int: DataEdgeNoRetParam  = DataEdgeNoRet union Parameter;
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

