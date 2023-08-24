Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 7;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 8;
Inst_Other_end = 23;
Inst_start = 1;
Inst_end = 23;
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
FunctionEntry_start = 24;
FunctionEntry_end = 25;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 0;
Param_end = -1;
Annotation_Var_start = 26;
Annotation_Var_end = 27;
Annotation_Global_start = 28;
Annotation_Global_end = 28;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 26;
Annotation_end = 28;
PDGNode_start = 1;
PDGNode_end = 28;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 25;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 25;
DataDepEdge_DefUse_start = 26;
DataDepEdge_DefUse_end = 36;
DataDepEdge_RAW_start = 37;
DataDepEdge_RAW_end = 37;
DataDepEdge_Ret_start = 38;
DataDepEdge_Ret_end = 38;
DataDepEdge_Alias_start = 39;
DataDepEdge_Alias_end = 42;
DataDepEdge_start = 26;
DataDepEdge_end = 42;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 43;
Anno_Global_end = 43;
Anno_Var_start = 44;
Anno_Var_end = 51;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 43;
Anno_end = 51;
PDGEdge_start = 1;
PDGEdge_end = 51;
hasFunction = [
24,24,25,25,25,24,25,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,24,25,24,25,0
];
hasSource = [
5,6,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,8,8,8,2,12,14,15,16,16,17,5,13,6,9,12,14,19,24,24,9,10,11,25,19,20,21
];
hasDest = [
24,5,8,1,9,10,11,2,12,13,14,6,15,16,17,18,3,19,20,21,22,4,5,23,7,14,13,9,12,13,6,18,22,19,23,23,14,5,8,2,12,16,28,26,26,26,26,27,27,27,27
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx9" taint[9]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx19" taint[19]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx24" taint[24]=BAR;
