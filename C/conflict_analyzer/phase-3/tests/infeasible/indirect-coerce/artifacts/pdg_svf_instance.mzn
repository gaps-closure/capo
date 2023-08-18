Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 7;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 8;
Inst_Other_end = 25;
Inst_start = 1;
Inst_end = 25;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 26;
VarNode_end = 25;
FunctionEntry_start = 26;
FunctionEntry_end = 27;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 28;
Param_end = 27;
Annotation_Var_start = 28;
Annotation_Var_end = 29;
Annotation_Global_start = 0;
Annotation_Global_end = -1;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 28;
Annotation_end = 29;
PDGNode_start = 1;
PDGNode_end = 29;
ControlDep_CallInv_start = 0;
ControlDep_CallInv_end = -1;
ControlDep_Indirect_CallInv_start = 1;
ControlDep_Indirect_CallInv_end = 1;
ControlDep_CallRet_start = 0;
ControlDep_CallRet_end = -1;
ControlDep_Entry_start = 2;
ControlDep_Entry_end = 26;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 26;
DataDepEdge_DefUse_start = 27;
DataDepEdge_DefUse_end = 38;
DataDepEdge_RAW_start = 39;
DataDepEdge_RAW_end = 40;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 41;
DataDepEdge_Alias_end = 42;
DataDepEdge_start = 27;
DataDepEdge_end = 42;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 43;
Parameter_end = 42;
Anno_Global_start = 0;
Anno_Global_end = -1;
Anno_Var_start = 43;
Anno_Var_end = 50;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 43;
Anno_end = 50;
DataDepEdge_PointsTo_start = 51;
DataDepEdge_PointsTo_end = 60;
PDGEdge_start = 1;
PDGEdge_end = 60;
hasFunction = [
26,27,27,27,27,26,27,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,26,27,26,27
];
hasSource = [
5,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,8,8,8,13,14,15,15,16,16,17,24,5,12,23,9,19,26,9,10,11,27,19,20,21,26,8,9,27,14,15,16,17,19,24
];
hasDest = [
26,8,1,9,10,11,12,13,6,15,16,17,18,2,19,20,21,22,3,23,4,24,5,25,7,14,13,12,9,6,18,22,19,24,23,25,5,25,13,24,8,15,28,28,28,28,29,29,29,29,26,8,8,27,14,15,16,17,15,26
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx9" taint[9]=ORANGE_2;
constraint :: "TaintOnNodeIdx19" taint[19]=ORANGE_1;