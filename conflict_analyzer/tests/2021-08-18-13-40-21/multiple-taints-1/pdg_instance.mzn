Inst_FunCall_start = 1;
Inst_FunCall_end = 4;
Inst_Ret_start = 5;
Inst_Ret_end = 8;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 9;
Inst_Other_end = 29;
Inst_start = 1;
Inst_end = 29;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 30;
VarNode_StaticFunction_end = 32;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 30;
VarNode_end = 32;
FunctionEntry_start = 33;
FunctionEntry_end = 36;
Param_FormalIn_start = 37;
Param_FormalIn_end = 39;
Param_FormalOut_start = 40;
Param_FormalOut_end = 42;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 37;
Param_end = 42;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 43;
Annotation_Global_end = 43;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 43;
Annotation_end = 43;
PDGNode_start = 1;
PDGNode_end = 43;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 3;
ControlDep_CallRet_start = 4;
ControlDep_CallRet_end = 6;
ControlDep_Entry_start = 7;
ControlDep_Entry_end = 35;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 35;
DataDepEdge_DefUse_start = 36;
DataDepEdge_DefUse_end = 63;
DataDepEdge_RAW_start = 64;
DataDepEdge_RAW_end = 66;
DataDepEdge_Ret_start = 67;
DataDepEdge_Ret_end = 69;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 36;
DataDepEdge_end = 69;
Parameter_In_start = 70;
Parameter_In_end = 71;
Parameter_Out_start = 72;
Parameter_Out_end = 73;
Parameter_Field_start = 74;
Parameter_Field_end = 75;
Parameter_start = 70;
Parameter_end = 75;
Anno_Global_start = 76;
Anno_Global_end = 79;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 76;
Anno_end = 79;
PDGEdge_start = 1;
PDGEdge_end = 79;
hasFunction = [
34,35,36,36,33,34,35,36,33,33,33,33,33,33,33,33,33,36,35,35,
35,35,35,35,36,36,36,36,36,0,0,0,33,34,35,36,36,36,36,36,
36,36,0
];
hasSource = [
1,2,3,5,6,7,33,33,33,33,33,33,33,33,33,33,34,34,35,35,
35,35,35,35,35,35,36,36,36,36,36,36,36,36,36,30,30,30,31,31,
31,32,32,32,32,9,10,12,13,15,16,17,1,19,2,20,21,22,24,25,
26,27,3,11,14,23,5,6,7,36,36,36,36,38,41,30,31,32,34
];
hasDest = [
33,34,35,1,2,3,10,11,12,13,14,15,16,17,5,9,1,6,19,2,
20,21,22,23,24,7,26,27,28,18,29,3,4,8,25,15,11,9,16,14,
12,24,23,21,19,10,11,13,14,17,17,5,6,20,20,22,22,23,7,28,
18,29,4,15,16,24,1,2,3,37,38,40,41,39,42,43,43,43,43
];
hasParamIdx = array1d(Param, [
1,2,-1,1,2,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx30" taint[30]=ORANGE;
constraint ::  "TaintOnNodeIdx31" taint[31]=ORANGE_SHAREABLE;
constraint ::  "TaintOnNodeIdx32" taint[32]=PURPLE;
constraint ::  "TaintOnNodeIdx34" taint[34]=XD_ORANGE;
