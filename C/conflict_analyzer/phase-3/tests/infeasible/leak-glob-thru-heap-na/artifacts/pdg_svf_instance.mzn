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
VarNode_StaticGlobal_start = 23;
VarNode_StaticGlobal_end = 23;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 23;
VarNode_end = 23;
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
Param_start = 26;
Param_end = 25;
Annotation_Var_start = 26;
Annotation_Var_end = 26;
Annotation_Global_start = 27;
Annotation_Global_end = 27;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 26;
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
ControlDep_Entry_end = 24;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 24;
DataDepEdge_DefUse_start = 25;
DataDepEdge_DefUse_end = 37;
DataDepEdge_RAW_start = 38;
DataDepEdge_RAW_end = 38;
DataDepEdge_Ret_start = 39;
DataDepEdge_Ret_end = 39;
DataDepEdge_Alias_start = 40;
DataDepEdge_Alias_end = 43;
DataDepEdge_start = 25;
DataDepEdge_end = 43;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 44;
Parameter_end = 43;
Anno_Global_start = 44;
Anno_Global_end = 44;
Anno_Var_start = 45;
Anno_Var_end = 48;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 44;
Anno_end = 48;
DataDepEdge_PointsTo_start = 49;
DataDepEdge_PointsTo_end = 58;
PDGEdge_start = 1;
PDGEdge_end = 58;
hasFunction = [
24,24,25,25,25,24,25,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,0,24,25,25,0
];
hasSource = [
5,6,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,23,8,8,8,2,9,11,12,14,15,16,17,5,10,6,9,11,14,19,23,25,19,20,21,6,8,2,9,11,12,14,17,19,5
];
hasDest = [
24,5,8,1,2,9,10,11,12,13,14,6,15,16,17,18,3,19,20,21,4,5,22,7,12,14,11,10,9,10,13,13,6,18,19,22,22,11,5,2,9,9,16,27,26,26,26,26,2,2,23,2,2,23,2,2,16,2
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx19" taint[19]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx23" taint[23]=ORANGE_NOSHARE;