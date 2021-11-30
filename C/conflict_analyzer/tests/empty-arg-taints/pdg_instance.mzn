Inst_FunCall_start = 1;
Inst_FunCall_end = 6;
Inst_Ret_start = 7;
Inst_Ret_end = 9;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 10;
Inst_Other_end = 22;
Inst_start = 1;
Inst_end = 22;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 23;
VarNode_end = -1;
FunctionEntry_start = 23;
FunctionEntry_end = 25;
Param_FormalIn_start = 26;
Param_FormalIn_end = 26;
Param_FormalOut_start = 27;
Param_FormalOut_end = 27;
Param_ActualIn_start = 28;
Param_ActualIn_end = 28;
Param_ActualOut_start = 29;
Param_ActualOut_end = 29;
Param_start = 26;
Param_end = 29;
Annotation_Var_start = 30;
Annotation_Var_end = 30;
Annotation_Global_start = 31;
Annotation_Global_end = 31;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 30;
Annotation_end = 31;
PDGNode_start = 1;
PDGNode_end = 31;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 23;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 23;
DataDepEdge_DefUse_start = 24;
DataDepEdge_DefUse_end = 37;
DataDepEdge_RAW_start = 38;
DataDepEdge_RAW_end = 40;
DataDepEdge_Ret_start = 41;
DataDepEdge_Ret_end = 42;
DataDepEdge_Alias_start = 43;
DataDepEdge_Alias_end = 43;
DataDepEdge_start = 24;
DataDepEdge_end = 43;
Parameter_In_start = 44;
Parameter_In_end = 48;
Parameter_Out_start = 49;
Parameter_Out_end = 51;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 44;
Parameter_end = 51;
Anno_Global_start = 52;
Anno_Global_end = 52;
Anno_Var_start = 53;
Anno_Var_end = 54;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 52;
Anno_end = 54;
PDGEdge_start = 1;
PDGEdge_end = 54;
hasFunction = [
24,25,25,23,24,25,23,24,25,23,23,23,23,24,24,24,25,25,25,25,
25,25,23,24,25,23,23,23,23,25,0
];
hasSource = [
1,2,7,8,23,23,23,23,23,24,24,24,24,24,25,25,25,25,25,25,
25,25,25,10,10,12,13,14,14,16,1,17,18,18,18,2,22,11,15,21,
7,8,20,26,23,16,1,28,23,1,29,23,25,20
];
hasDest = [
23,24,1,2,10,11,12,13,7,15,16,1,8,14,17,18,19,20,2,21,
22,3,9,12,11,13,7,16,15,1,8,19,22,21,20,21,3,12,16,22,
1,2,18,12,26,28,28,26,27,29,16,31,30,30
];
hasParamIdx = array1d(Param, [
1,1,1,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx20" taint[20]=ORANGE;
constraint ::  "TaintOnNodeIdx23" taint[23]=XD_BAR;
