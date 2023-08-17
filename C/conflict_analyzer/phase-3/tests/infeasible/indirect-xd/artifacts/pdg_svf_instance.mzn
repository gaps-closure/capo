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
VarNode_StaticFunction_start = 23;
VarNode_StaticFunction_end = 24;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 23;
VarNode_end = 24;
FunctionEntry_start = 25;
FunctionEntry_end = 26;
Param_FormalIn_start = 27;
Param_FormalIn_end = 27;
Param_FormalOut_start = 28;
Param_FormalOut_end = 28;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 27;
Param_end = 28;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 29;
Annotation_Global_end = 29;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 29;
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
ControlDep_Entry_end = 23;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 23;
DataDepEdge_DefUse_start = 24;
DataDepEdge_DefUse_end = 38;
DataDepEdge_RAW_start = 39;
DataDepEdge_RAW_end = 41;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 24;
DataDepEdge_end = 41;
Parameter_In_start = 42;
Parameter_In_end = 43;
Parameter_Out_start = 44;
Parameter_Out_end = 44;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 42;
Parameter_end = 44;
Anno_Global_start = 45;
Anno_Global_end = 46;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 45;
Anno_end = 46;
DataDepEdge_PointsTo_start = 47;
DataDepEdge_PointsTo_end = 56;
PDGEdge_start = 1;
PDGEdge_end = 56;
hasFunction = [
25,26,26,26,26,25,26,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,0,0,25,26,25,25,0
];
hasSource = [
5,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,23,8,8,10,11,12,13,14,14,15,15,16,20,21,5,9,18,19,27,25,25,23,24,23,24,25,8,26,13,14,15,16,20
];
hasDest = [
25,8,9,1,10,11,12,6,14,15,16,17,2,18,3,19,4,20,21,5,22,7,13,10,11,9,12,12,6,17,21,18,20,19,22,5,5,22,11,21,20,11,27,28,29,29,23,24,25,8,26,13,14,15,16,25
];
hasParamIdx = array1d(Param, [
1,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx23" taint[23]=PURPLE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE;