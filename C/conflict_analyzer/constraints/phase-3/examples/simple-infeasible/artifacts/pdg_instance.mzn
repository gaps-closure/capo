Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 5;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 6;
Inst_Other_end = 15;
Inst_start = 1;
Inst_end = 15;
VarNode_StaticGlobal_start = 16;
VarNode_StaticGlobal_end = 16;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 16;
VarNode_end = 16;
FunctionEntry_start = 17;
FunctionEntry_end = 18;
Param_FormalIn_start = 19;
Param_FormalIn_end = 20;
Param_FormalOut_start = 21;
Param_FormalOut_end = 22;
Param_ActualIn_start = 23;
Param_ActualIn_end = 24;
Param_ActualOut_start = 25;
Param_ActualOut_end = 26;
Param_start = 19;
Param_end = 26;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 27;
Annotation_Global_end = 27;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 27;
Annotation_end = 27;
PDGNode_start = 1;
PDGNode_end = 27;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 17;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 17;
DataDepEdge_DefUse_start = 18;
DataDepEdge_DefUse_end = 28;
DataDepEdge_RAW_start = 29;
DataDepEdge_RAW_end = 29;
DataDepEdge_Ret_start = 30;
DataDepEdge_Ret_end = 30;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 18;
DataDepEdge_end = 30;
Parameter_In_start = 31;
Parameter_In_end = 38;
Parameter_Out_start = 39;
Parameter_Out_end = 44;
Parameter_Field_start = 45;
Parameter_Field_end = 48;
Parameter_start = 31;
Parameter_end = 48;
Anno_Global_start = 49;
Anno_Global_end = 51;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 49;
Anno_end = 51;
PDGEdge_start = 1;
PDGEdge_end = 51;
hasFunction = [
17,18,18,17,18,17,17,17,17,17,17,17,18,18,18,0,17,18,17,17,17,17,17,17,17,17,0
];
hasSource = [
2,4,17,17,17,17,17,17,17,17,17,18,18,18,18,18,18,16,16,6,6,6,8,9,10,11,13,15,7,4,19,19,16,17,20,2,23,24,17,11,21,2,25,26,19,21,23,25,16,17,18
];
hasDest = [
17,2,6,7,1,8,9,10,11,12,4,14,2,15,3,5,13,15,2,11,8,7,9,10,12,12,14,3,8,2,11,8,23,19,9,23,19,20,21,21,25,25,16,15,20,22,24,26,27,27,27
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx16" taint[16]=ORANGE_SHAREABLE;
constraint :: "TaintOnNodeIdx17" taint[17]=PURPLE_XD;
constraint :: "TaintOnNodeIdx18" taint[18]=ORANGE_XD;
