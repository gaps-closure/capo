Inst_FunCall_start = 1;
Inst_FunCall_end = 7;
Inst_Ret_start = 8;
Inst_Ret_end = 10;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 11;
Inst_Other_end = 31;
Inst_start = 1;
Inst_end = 31;
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
FunctionEntry_start = 32;
FunctionEntry_end = 34;
Param_FormalIn_start = 35;
Param_FormalIn_end = 38;
Param_FormalOut_start = 39;
Param_FormalOut_end = 42;
Param_ActualIn_start = 43;
Param_ActualIn_end = 46;
Param_ActualOut_start = 47;
Param_ActualOut_end = 50;
Param_start = 35;
Param_end = 50;
Annotation_Var_start = 51;
Annotation_Var_end = 52;
Annotation_Global_start = 53;
Annotation_Global_end = 53;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 51;
Annotation_end = 53;
PDGNode_start = 1;
PDGNode_end = 53;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 35;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 35;
DataDepEdge_DefUse_start = 36;
DataDepEdge_DefUse_end = 50;
DataDepEdge_RAW_start = 51;
DataDepEdge_RAW_end = 52;
DataDepEdge_Ret_start = 53;
DataDepEdge_Ret_end = 54;
DataDepEdge_Alias_start = 55;
DataDepEdge_Alias_end = 57;
DataDepEdge_start = 36;
DataDepEdge_end = 57;
Parameter_In_start = 58;
Parameter_In_end = 69;
Parameter_Out_start = 70;
Parameter_Out_end = 75;
Parameter_Field_start = 76;
Parameter_Field_end = 83;
Parameter_start = 58;
Parameter_end = 83;
Anno_Global_start = 84;
Anno_Global_end = 84;
Anno_Var_start = 85;
Anno_Var_end = 92;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 84;
Anno_end = 92;
PDGEdge_start = 1;
PDGEdge_end = 92;
hasFunction = [
32,32,33,33,34,34,34,32,33,34,32,32,32,33,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,34,32,33,34,32,32,33,33,32,32,33,33,33,33,32,32,33,33,32,32,33,34,0
];
hasSource = [
2,7,8,9,32,32,32,32,32,32,33,33,33,33,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,34,34,34,34,34,11,11,13,14,14,15,15,21,22,24,25,25,25,30,31,12,16,8,9,17,27,30,35,32,13,2,33,37,31,7,43,44,45,46,32,2,33,7,47,49,35,39,37,41,43,47,45,49,32,33,17,18,19,34,27,28,29
];
hasDest = [
33,32,7,2,11,12,1,13,2,8,15,16,3,4,17,18,19,20,21,22,23,9,14,24,25,26,5,27,28,29,30,6,31,7,10,13,12,2,21,16,20,17,22,23,26,31,30,27,6,7,13,21,7,2,15,25,25,13,35,43,43,37,21,45,45,37,38,35,36,39,47,41,49,13,31,36,40,38,42,44,48,46,50,53,51,51,51,51,52,52,52,52
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx17" taint[17]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx27" taint[27]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx32" taint[32]=FOO;
