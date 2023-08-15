Inst_FunCall_start = 1;
Inst_FunCall_end = 10;
Inst_Ret_start = 11;
Inst_Ret_end = 14;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 15;
Inst_Other_end = 42;
Inst_start = 1;
Inst_end = 42;
VarNode_StaticGlobal_start = 43;
VarNode_StaticGlobal_end = 43;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 43;
VarNode_end = 43;
FunctionEntry_start = 44;
FunctionEntry_end = 47;
Param_FormalIn_start = 48;
Param_FormalIn_end = 52;
Param_FormalOut_start = 53;
Param_FormalOut_end = 57;
Param_ActualIn_start = 58;
Param_ActualIn_end = 62;
Param_ActualOut_start = 63;
Param_ActualOut_end = 67;
Param_start = 48;
Param_end = 67;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 68;
Annotation_Global_end = 68;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 68;
Annotation_end = 68;
PDGNode_start = 1;
PDGNode_end = 68;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 3;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 4;
ControlDep_CallRet_end = 6;
ControlDep_Entry_start = 7;
ControlDep_Entry_end = 48;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 48;
DataDepEdge_DefUse_start = 49;
DataDepEdge_DefUse_end = 77;
DataDepEdge_RAW_start = 78;
DataDepEdge_RAW_end = 83;
DataDepEdge_Ret_start = 84;
DataDepEdge_Ret_end = 86;
DataDepEdge_Alias_start = 87;
DataDepEdge_Alias_end = 88;
DataDepEdge_start = 49;
DataDepEdge_end = 88;
Parameter_In_start = 89;
Parameter_In_end = 105;
Parameter_Out_start = 106;
Parameter_Out_end = 115;
Parameter_Field_start = 116;
Parameter_Field_end = 123;
Parameter_start = 89;
Parameter_end = 123;
Anno_Global_start = 124;
Anno_Global_end = 126;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 124;
Anno_end = 126;
DataDepEdge_PointsTo_start = 127;
DataDepEdge_PointsTo_end = 148;
PDGEdge_start = 1;
PDGEdge_end = 148;
hasFunction = [
44,45,45,45,45,46,46,46,47,47,44,45,46,47,44,44,44,44,44,45,45,45,45,45,45,45,45,45,45,45,45,45,45,46,46,46,46,46,46,47,47,47,0,44,45,46,47,44,45,45,46,46,44,45,45,46,46,44,45,45,46,46,44,45,45,46,46,0
];
hasSource = [
5,8,9,11,12,13,44,44,44,44,44,44,44,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,46,46,46,46,46,46,46,46,46,46,47,47,47,47,47,47,43,43,15,15,15,17,18,20,20,21,21,22,22,22,24,26,27,29,31,32,33,34,34,35,35,37,39,40,42,16,23,25,28,36,38,11,12,13,26,39,43,48,44,45,33,5,49,46,39,8,51,9,58,59,60,61,62,44,45,5,46,8,9,63,64,66,67,49,54,51,56,59,64,61,66,43,44,45,43,44,65,15,64,20,21,22,24,26,27,29,31,32,67,66,34,35,37,39,47,40
];
hasDest = [
44,45,46,5,8,9,15,16,1,17,18,19,11,20,21,22,23,2,3,24,25,4,26,27,28,29,30,31,32,33,5,12,35,36,6,7,37,38,39,8,13,34,40,41,9,42,10,14,42,9,19,17,16,18,19,24,23,26,25,31,29,27,25,28,28,30,32,33,5,37,36,39,38,38,8,41,10,17,24,26,32,37,39,5,8,9,24,37,61,17,48,49,58,58,24,51,59,59,37,61,48,49,50,51,52,53,54,63,56,64,66,33,39,43,42,50,55,52,57,60,65,62,67,68,68,68,43,44,65,15,43,20,21,22,43,43,22,22,22,43,67,43,34,35,43,43,47,40
];
hasParamIdx = array1d(Param, [
1,1,-1,1,-1,1,1,-1,1,-1,1,1,-1,1,-1,1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true,true,true
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx43" taint[43]=ORANGE_SHAREABLE;
constraint :: "TaintOnNodeIdx44" taint[44]=PURPLE_XD;
constraint :: "TaintOnNodeIdx45" taint[45]=ORANGE_XD;