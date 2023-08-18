Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 7;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 8;
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
VarNode_end = 22;
FunctionEntry_start = 23;
FunctionEntry_end = 24;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 25;
Param_end = 24;
Annotation_Var_start = 25;
Annotation_Var_end = 25;
Annotation_Global_start = 26;
Annotation_Global_end = 26;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 25;
Annotation_end = 26;
PDGNode_start = 1;
PDGNode_end = 26;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 24;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 24;
DataDepEdge_DefUse_start = 25;
DataDepEdge_DefUse_end = 38;
DataDepEdge_RAW_start = 39;
DataDepEdge_RAW_end = 40;
DataDepEdge_Ret_start = 41;
DataDepEdge_Ret_end = 41;
DataDepEdge_Alias_start = 42;
DataDepEdge_Alias_end = 47;
DataDepEdge_start = 25;
DataDepEdge_end = 47;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 48;
Parameter_end = 47;
Anno_Global_start = 48;
Anno_Global_end = 48;
Anno_Var_start = 49;
Anno_Var_end = 52;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 48;
Anno_end = 52;
DataDepEdge_PointsTo_start = 53;
DataDepEdge_PointsTo_end = 66;
PDGEdge_start = 1;
PDGEdge_end = 66;
hasFunction = [
23,23,24,24,24,23,24,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,23,24,23,0
];
hasSource = [
4,6,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,8,8,8,2,12,14,15,16,16,16,4,19,21,22,13,18,6,9,12,14,19,21,22,23,23,9,10,11,23,6,8,9,2,12,14,24,15,16,4,19,21,22
];
hasDest = [
23,4,8,1,9,10,11,2,12,13,14,6,15,16,17,3,4,18,19,20,21,22,5,7,14,13,9,12,13,6,17,21,19,18,18,20,22,5,14,19,4,8,2,12,4,4,21,26,25,25,25,25,23,2,8,8,2,2,2,24,15,16,2,2,2,2
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx9" taint[9]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx23" taint[23]=BAR;