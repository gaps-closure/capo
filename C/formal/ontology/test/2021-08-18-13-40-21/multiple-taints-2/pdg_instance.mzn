Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 10;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 11;
Inst_Other_end = 34;
Inst_start = 1;
Inst_end = 34;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 35;
VarNode_StaticFunction_end = 37;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 35;
VarNode_end = 37;
FunctionEntry_start = 38;
FunctionEntry_end = 42;
Param_FormalIn_start = 43;
Param_FormalIn_end = 45;
Param_FormalOut_start = 46;
Param_FormalOut_end = 48;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 43;
Param_end = 48;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 49;
Annotation_Global_end = 49;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 49;
Annotation_end = 49;
PDGNode_start = 1;
PDGNode_end = 49;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 4;
ControlDep_CallRet_start = 5;
ControlDep_CallRet_end = 8;
ControlDep_Entry_start = 9;
ControlDep_Entry_end = 42;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 42;
DataDepEdge_DefUse_start = 43;
DataDepEdge_DefUse_end = 74;
DataDepEdge_RAW_start = 75;
DataDepEdge_RAW_end = 77;
DataDepEdge_Ret_start = 78;
DataDepEdge_Ret_end = 81;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 43;
DataDepEdge_end = 81;
Parameter_In_start = 82;
Parameter_In_end = 83;
Parameter_Out_start = 84;
Parameter_Out_end = 85;
Parameter_Field_start = 86;
Parameter_Field_end = 87;
Parameter_start = 82;
Parameter_end = 87;
Anno_Global_start = 88;
Anno_Global_end = 91;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 88;
Anno_end = 91;
PDGEdge_start = 1;
PDGEdge_end = 91;
hasFunction = [
39,40,41,42,42,38,39,40,41,42,38,38,38,38,39,39,39,39,41,39,
39,39,39,41,41,41,41,41,42,42,42,42,42,42,0,0,0,38,39,40,
41,42,42,42,42,42,42,42,0
];
hasSource = [
1,2,3,4,6,7,8,9,38,38,38,38,38,39,39,39,39,39,39,39,
39,39,39,40,40,41,41,41,41,41,41,41,41,42,42,42,42,42,42,42,
42,42,35,35,35,36,36,36,37,37,37,37,11,12,14,15,15,16,17,19,
1,21,22,23,2,24,3,25,26,27,29,30,31,4,13,20,28,6,7,8,
9,42,42,42,42,44,47,35,36,37,40
];
hasDest = [
38,39,40,41,1,2,3,4,12,13,14,6,11,15,16,17,18,1,20,21,
22,23,7,2,8,3,25,26,27,28,19,9,24,29,30,31,32,33,34,4,
5,10,14,13,11,22,18,16,19,28,26,24,12,13,6,21,20,17,18,9,
20,23,23,7,8,25,25,27,27,28,32,33,34,5,14,21,19,1,2,3,
4,43,44,46,47,45,48,49,49,49,49
];
hasParamIdx = array1d(Param, [
1,2,-1,1,2,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false,true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx35" taint[35]=ORANGE_SHAREABLE;
constraint ::  "TaintOnNodeIdx36" taint[36]=ORANGE;
constraint ::  "TaintOnNodeIdx37" taint[37]=PURPLE;
constraint ::  "TaintOnNodeIdx40" taint[40]=XD_ORANGE;
