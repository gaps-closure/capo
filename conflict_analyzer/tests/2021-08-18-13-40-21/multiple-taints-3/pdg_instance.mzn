Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 10;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 11;
Inst_Other_end = 40;
Inst_start = 1;
Inst_end = 40;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 41;
VarNode_StaticFunction_end = 43;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 41;
VarNode_end = 43;
FunctionEntry_start = 44;
FunctionEntry_end = 48;
Param_FormalIn_start = 49;
Param_FormalIn_end = 53;
Param_FormalOut_start = 54;
Param_FormalOut_end = 58;
Param_ActualIn_start = 59;
Param_ActualIn_end = 60;
Param_ActualOut_start = 61;
Param_ActualOut_end = 62;
Param_start = 49;
Param_end = 62;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 63;
Annotation_Global_end = 63;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 63;
Annotation_end = 63;
PDGNode_start = 1;
PDGNode_end = 63;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 4;
ControlDep_CallRet_start = 5;
ControlDep_CallRet_end = 8;
ControlDep_Entry_start = 9;
ControlDep_Entry_end = 48;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 48;
DataDepEdge_DefUse_start = 49;
DataDepEdge_DefUse_end = 86;
DataDepEdge_RAW_start = 87;
DataDepEdge_RAW_end = 91;
DataDepEdge_Ret_start = 92;
DataDepEdge_Ret_end = 95;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 49;
DataDepEdge_end = 95;
Parameter_In_start = 96;
Parameter_In_end = 107;
Parameter_Out_start = 108;
Parameter_Out_end = 115;
Parameter_Field_start = 116;
Parameter_Field_end = 117;
Parameter_start = 96;
Parameter_end = 117;
Anno_Global_start = 118;
Anno_Global_end = 121;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 118;
Anno_end = 121;
PDGEdge_start = 1;
PDGEdge_end = 121;
hasFunction = [
46,46,47,48,48,44,46,45,47,48,44,44,44,44,45,45,45,45,45,45,
45,46,46,46,46,46,46,46,47,47,47,47,47,47,48,48,48,48,48,48,
0,0,0,44,45,46,47,48,45,45,48,48,48,45,45,48,48,48,45,45,
45,45,0
];
hasSource = [
1,2,3,4,6,7,8,9,44,44,44,44,44,45,45,45,45,45,45,45,
45,46,46,46,46,46,46,46,46,46,46,47,47,47,47,47,47,47,47,48,
48,48,48,48,48,48,48,48,41,41,41,42,42,42,43,43,43,43,11,12,
14,15,15,16,16,19,20,21,22,22,23,24,1,27,28,2,29,3,30,31,
32,34,35,36,37,4,13,17,18,26,33,6,7,8,9,45,45,49,50,27,
28,2,2,48,48,59,60,45,45,2,2,48,48,61,62,52,57,41,42,43,
46
];
hasDest = [
44,45,46,47,1,3,2,4,12,13,14,6,11,15,16,17,18,19,20,21,
8,22,23,24,25,1,26,27,28,2,7,3,30,31,32,33,34,9,29,35,
36,37,38,39,40,4,5,10,14,13,11,27,25,23,34,33,31,29,12,13,
6,19,17,20,18,21,21,8,28,26,24,25,26,2,2,7,30,30,32,32,
33,9,38,39,40,5,14,19,20,28,34,1,3,2,4,49,50,19,20,59,
60,59,60,51,52,49,50,54,55,61,62,56,57,27,28,53,58,63,63,63,
63
];
hasParamIdx = array1d(Param, [
1,2,1,2,-1,1,2,1,2,-1,1,2,1,2
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false,true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx41" taint[41]=ORANGE_SHAREABLE;
constraint ::  "TaintOnNodeIdx42" taint[42]=ORANGE;
constraint ::  "TaintOnNodeIdx43" taint[43]=PURPLE;
constraint ::  "TaintOnNodeIdx46" taint[46]=XD_ORANGE;
