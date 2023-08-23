Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 8;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 9;
Inst_Other_end = 23;
Inst_start = 1;
Inst_end = 23;
VarNode_StaticGlobal_start = 24;
VarNode_StaticGlobal_end = 24;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 24;
VarNode_end = 24;
FunctionEntry_start = 25;
FunctionEntry_end = 27;
Param_FormalIn_start = 28;
Param_FormalIn_end = 29;
Param_FormalOut_start = 30;
Param_FormalOut_end = 31;
Param_ActualIn_start = 32;
Param_ActualIn_end = 33;
Param_ActualOut_start = 34;
Param_ActualOut_end = 35;
Param_start = 28;
Param_end = 35;
Annotation_Var_start = 36;
Annotation_Var_end = 36;
Annotation_Global_start = 37;
Annotation_Global_end = 37;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 36;
Annotation_end = 37;
PDGNode_start = 1;
PDGNode_end = 37;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 27;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 27;
DataDepEdge_DefUse_start = 28;
DataDepEdge_DefUse_end = 38;
DataDepEdge_RAW_start = 39;
DataDepEdge_RAW_end = 39;
DataDepEdge_Ret_start = 40;
DataDepEdge_Ret_end = 41;
DataDepEdge_Alias_start = 42;
DataDepEdge_Alias_end = 42;
DataDepEdge_start = 28;
DataDepEdge_end = 42;
Parameter_In_start = 43;
Parameter_In_end = 49;
Parameter_Out_start = 50;
Parameter_Out_end = 52;
Parameter_Field_start = 53;
Parameter_Field_end = 56;
Parameter_start = 43;
Parameter_end = 56;
Anno_Global_start = 57;
Anno_Global_end = 58;
Anno_Var_start = 59;
Anno_Var_end = 62;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 57;
Anno_end = 62;
PDGEdge_start = 1;
PDGEdge_end = 62;
hasFunction = [
25,25,26,26,27,25,26,27,25,25,25,26,26,26,26,26,26,26,26,26,26,27,27,0,25,26,27,26,26,26,26,26,26,26,26,26,0
];
hasSource = [
2,5,6,7,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,24,9,9,10,12,12,13,18,19,20,22,14,6,7,15,9,2,26,28,29,32,33,2,26,34,28,30,32,34,24,25,26,15,16,17
];
hasDest = [
26,25,5,2,9,1,10,11,2,6,12,13,14,3,4,15,16,17,18,19,20,21,7,23,5,8,22,10,2,11,11,18,14,15,19,20,21,23,18,5,2,13,32,32,28,18,19,28,29,34,30,9,29,31,33,35,37,37,36,36,36,36
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx15" taint[15]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx25" taint[25]=BAR;
