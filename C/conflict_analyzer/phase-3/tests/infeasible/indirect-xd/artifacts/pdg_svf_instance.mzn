Inst_FunCall_start = 1;
Inst_FunCall_end = 7;
Inst_Ret_start = 8;
Inst_Ret_end = 9;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 10;
Inst_Other_end = 34;
Inst_start = 1;
Inst_end = 34;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 35;
VarNode_end = 34;
FunctionEntry_start = 35;
FunctionEntry_end = 36;
Param_FormalIn_start = 37;
Param_FormalIn_end = 37;
Param_FormalOut_start = 38;
Param_FormalOut_end = 38;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 37;
Param_end = 38;
Annotation_Var_start = 39;
Annotation_Var_end = 40;
Annotation_Global_start = 0;
Annotation_Global_end = -1;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 39;
Annotation_end = 40;
PDGNode_start = 1;
PDGNode_end = 40;
ControlDep_CallInv_start = 0;
ControlDep_CallInv_end = -1;
ControlDep_Indirect_CallInv_start = 1;
ControlDep_Indirect_CallInv_end = 1;
ControlDep_CallRet_start = 0;
ControlDep_CallRet_end = -1;
ControlDep_Entry_start = 2;
ControlDep_Entry_end = 35;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 35;
DataDepEdge_DefUse_start = 36;
DataDepEdge_DefUse_end = 54;
DataDepEdge_RAW_start = 55;
DataDepEdge_RAW_end = 58;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 59;
DataDepEdge_Alias_end = 60;
DataDepEdge_start = 36;
DataDepEdge_end = 60;
Parameter_In_start = 61;
Parameter_In_end = 62;
Parameter_Out_start = 63;
Parameter_Out_end = 63;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 61;
Parameter_end = 63;
Anno_Global_start = 0;
Anno_Global_end = -1;
Anno_Var_start = 64;
Anno_Var_end = 71;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 64;
Anno_end = 71;
DataDepEdge_PointsTo_start = 72;
DataDepEdge_PointsTo_end = 75;
PDGEdge_start = 1;
PDGEdge_end = 75;
hasFunction = [
35,35,36,36,36,36,36,35,36,35,35,35,35,35,35,35,35,35,35,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,35,36,35,35,35,36
];
hasSource = [
7,35,35,35,35,35,35,35,35,35,35,35,35,35,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,10,10,11,11,11,17,18,19,20,21,21,22,22,23,23,24,32,33,7,12,16,30,31,13,26,37,35,35,35,13,14,15,36,26,27,28,13,23,26,32
];
hasDest = [
35,10,11,12,1,2,13,14,15,16,17,18,19,8,21,22,23,24,25,3,26,27,28,29,4,30,5,31,6,32,33,7,34,9,20,18,12,17,16,13,19,19,8,25,29,26,33,30,32,31,34,7,7,34,18,17,33,32,11,21,18,37,38,39,39,39,39,40,40,40,40,11,35,21,35
];
hasParamIdx = array1d(Param, [
1,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx13" taint[13]=PURPLE;
constraint :: "TaintOnNodeIdx26" taint[26]=ORANGE;