Inst_FunCall_start = 1;
Inst_FunCall_end = 7;
Inst_Ret_start = 8;
Inst_Ret_end = 10;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 11;
Inst_Other_end = 27;
Inst_start = 1;
Inst_end = 27;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 0;
VarNode_end = -1;
FunctionEntry_start = 28;
FunctionEntry_end = 30;
Param_FormalIn_start = 31;
Param_FormalIn_end = 34;
Param_FormalOut_start = 35;
Param_FormalOut_end = 38;
Param_ActualIn_start = 39;
Param_ActualIn_end = 42;
Param_ActualOut_start = 43;
Param_ActualOut_end = 46;
Param_start = 31;
Param_end = 46;
Annotation_Var_start = 47;
Annotation_Var_end = 48;
Annotation_Global_start = 49;
Annotation_Global_end = 49;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 47;
Annotation_end = 49;
PDGNode_start = 1;
PDGNode_end = 49;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 31;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 31;
DataDepEdge_DefUse_start = 32;
DataDepEdge_DefUse_end = 46;
DataDepEdge_RAW_start = 47;
DataDepEdge_RAW_end = 48;
DataDepEdge_Ret_start = 49;
DataDepEdge_Ret_end = 50;
DataDepEdge_Alias_start = 51;
DataDepEdge_Alias_end = 53;
DataDepEdge_start = 32;
DataDepEdge_end = 53;
Parameter_In_start = 54;
Parameter_In_end = 65;
Parameter_Out_start = 66;
Parameter_Out_end = 71;
Parameter_Field_start = 72;
Parameter_Field_end = 79;
Parameter_start = 54;
Parameter_end = 79;
Anno_Global_start = 80;
Anno_Global_end = 80;
Anno_Var_start = 81;
Anno_Var_end = 84;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 80;
Anno_end = 84;
PDGEdge_start = 1;
PDGEdge_end = 84;
hasFunction = [
28,28,29,29,30,30,30,28,29,30,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,28,29,30,28,28,29,29,28,28,29,29,29,29,28,28,29,29,28,28,29,30,0
];
hasSource = [
2,7,8,9,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,30,30,11,11,13,14,14,15,15,19,20,22,23,23,23,26,27,12,16,8,9,17,25,26,31,28,13,2,29,33,27,7,39,40,41,42,28,2,29,7,43,45,31,35,33,37,39,43,41,45,28,29,17,30,25
];
hasDest = [
29,28,7,2,11,12,1,13,2,8,15,16,3,4,17,18,19,20,21,9,14,22,23,24,5,25,26,6,27,7,10,13,12,2,19,16,18,17,20,21,24,27,26,25,6,7,13,19,7,2,15,23,23,13,31,39,39,33,19,41,41,33,34,31,32,35,43,37,45,13,27,32,36,34,38,40,44,42,46,49,47,47,48,48
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx17" taint[17]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx25" taint[25]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx28" taint[28]=FOO;
