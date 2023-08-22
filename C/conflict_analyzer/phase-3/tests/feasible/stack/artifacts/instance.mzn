cleLabel = { nullCleLabel, FOO, ORANGE_NOSHARE, ORANGE_SHARE };
hasLabelLevel = [ nullLevel, orange, orange, orange ];
isFunctionAnnotation = [ false, true, false, false ];
cdf = { nullCdf, FOO_cdf_0 };
fromCleLabel = [ nullCleLabel, FOO ];
hasRemotelevel = [ nullLevel, orange ];
hasDirection = [ nullDirection, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow ];
isOneway = [ false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, FOO_cdf_0,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, true, true
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, true, true
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false,
  false, false, true, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, true, true, true
]);
Inst_FunCall_start = 1;
Inst_FunCall_end = 9;
Inst_Ret_start = 10;
Inst_Ret_end = 12;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 13;
Inst_Other_end = 38;
Inst_start = 1;
Inst_end = 38;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 39;
VarNode_end = 38;
FunctionEntry_start = 39;
FunctionEntry_end = 41;
Param_FormalIn_start = 42;
Param_FormalIn_end = 45;
Param_FormalOut_start = 46;
Param_FormalOut_end = 49;
Param_ActualIn_start = 50;
Param_ActualIn_end = 53;
Param_ActualOut_start = 54;
Param_ActualOut_end = 57;
Param_start = 42;
Param_end = 57;
Annotation_Var_start = 58;
Annotation_Var_end = 60;
Annotation_Global_start = 61;
Annotation_Global_end = 61;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 58;
Annotation_end = 61;
PDGNode_start = 1;
PDGNode_end = 61;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 42;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 42;
DataDepEdge_DefUse_start = 43;
DataDepEdge_DefUse_end = 60;
DataDepEdge_RAW_start = 61;
DataDepEdge_RAW_end = 61;
DataDepEdge_Ret_start = 62;
DataDepEdge_Ret_end = 63;
DataDepEdge_Alias_start = 64;
DataDepEdge_Alias_end = 68;
DataDepEdge_start = 43;
DataDepEdge_end = 68;
Parameter_In_start = 69;
Parameter_In_end = 79;
Parameter_Out_start = 80;
Parameter_Out_end = 85;
Parameter_Field_start = 86;
Parameter_Field_end = 93;
Parameter_start = 69;
Parameter_end = 93;
Anno_Global_start = 94;
Anno_Global_end = 94;
Anno_Var_start = 95;
Anno_Var_end = 106;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 94;
Anno_end = 106;
DataDepEdge_PointsTo_start = 107;
DataDepEdge_PointsTo_end = 128;
PDGEdge_start = 1;
PDGEdge_end = 128;
hasFunction = [
39,39,39,39,40,40,41,41,41,39,40,41,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,39,40,41,39,39,40,40,39,39,40,40,40,40,39,39,40,40,39,39,39,40,41,0
];
hasSource = [
4,9,10,11,39,39,39,39,39,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,13,14,14,14,19,20,21,21,22,22,28,29,31,32,32,32,37,38,23,10,11,16,19,24,34,37,39,20,4,40,44,38,9,50,51,52,53,39,4,40,9,54,56,42,46,44,48,50,54,52,56,39,39,16,17,18,40,24,25,26,41,34,35,36,57,56,13,14,16,19,20,55,54,21,22,24,28,29,41,31,32,34,37,38,19,37
];
hasDest = [
40,39,9,4,14,15,1,2,16,17,18,19,3,20,4,10,13,21,22,23,5,6,24,25,26,27,28,29,30,11,32,33,7,34,35,36,37,8,38,9,12,31,15,20,19,16,3,4,28,23,27,24,29,30,33,38,37,34,8,9,28,9,4,14,14,22,32,32,42,50,50,44,28,52,52,44,45,42,43,46,54,48,56,20,38,43,47,45,49,51,55,53,57,61,58,58,58,58,59,59,59,59,60,60,60,60,57,32,13,14,14,14,14,55,14,21,22,22,14,14,41,31,32,32,32,32,14,32
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx16" taint[16]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx34" taint[34]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx39" taint[39]=FOO;
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

% constraint :: "PtrAliasSameEnclave"
%  forall (e in DataDepEdge_PointsTo)
%   (xdedge(e) == false);

% constraint :: "PtrAliasCoerced"
%  forall (e in DataDepEdge_PointsTo)
%   (if (hasFunction[hasSource[e]] != 0) then 
%       coerced[e] == isInArctaint(esFunTaint(e), edTaint(e), hasLabelLevel[edTaint(e)])
%    else
%       coerced[e] == false
%    endif);

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
set of int: DataEdgeNoRet       = DataDepEdge_DefUse union DataDepEdge_RAW union DataDepEdge_Alias union DataDepEdge_PointsTo;
set of int: DataEdgeNoRetParam  = DataEdgeNoRet union Parameter;
set of int: DataEdgeParam       = DataDepEdge union Parameter union DataDepEdge_PointsTo;

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

