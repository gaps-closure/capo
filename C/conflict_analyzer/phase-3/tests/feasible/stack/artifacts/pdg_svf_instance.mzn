Inst_FunCall_start = 1;
Inst_FunCall_end = 9;
Inst_Ret_start = 10;
Inst_Ret_end = 12;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 13;
Inst_Other_end = 38;
Inst_start = 1;
Inst_end = 38;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 39;
VarNode_end = 38;
FunctionEntry_start = 39;
FunctionEntry_end = 41;
Param_FormalIn_start = 42;
Param_FormalIn_end = 45;
Param_FormalOut_start = 46;
Param_FormalOut_end = 49;
Param_ActualIn_start = 50;
Param_ActualIn_end = 53;
Param_ActualOut_start = 54;
Param_ActualOut_end = 57;
Param_start = 42;
Param_end = 57;
Annotation_Var_start = 58;
Annotation_Var_end = 60;
Annotation_Global_start = 61;
Annotation_Global_end = 61;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 58;
Annotation_end = 61;
PDGNode_start = 1;
PDGNode_end = 61;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 42;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 42;
DataDepEdge_DefUse_start = 43;
DataDepEdge_DefUse_end = 60;
DataDepEdge_RAW_start = 61;
DataDepEdge_RAW_end = 61;
DataDepEdge_Ret_start = 62;
DataDepEdge_Ret_end = 63;
DataDepEdge_Alias_start = 64;
DataDepEdge_Alias_end = 68;
DataDepEdge_start = 43;
DataDepEdge_end = 68;
Parameter_In_start = 69;
Parameter_In_end = 79;
Parameter_Out_start = 80;
Parameter_Out_end = 85;
Parameter_Field_start = 86;
Parameter_Field_end = 93;
Parameter_start = 69;
Parameter_end = 93;
Anno_Global_start = 94;
Anno_Global_end = 94;
Anno_Var_start = 95;
Anno_Var_end = 106;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 94;
Anno_end = 106;
DataDepEdge_PointsTo_start = 107;
DataDepEdge_PointsTo_end = 128;
PDGEdge_start = 1;
PDGEdge_end = 128;
hasFunction = [
39,39,39,39,40,40,41,41,41,39,40,41,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,39,40,41,39,39,40,40,39,39,40,40,40,40,39,39,40,40,39,39,39,40,41,0
];
hasSource = [
4,9,10,11,39,39,39,39,39,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,13,14,14,14,19,20,21,21,22,22,28,29,31,32,32,32,37,38,23,10,11,16,19,24,34,37,39,20,4,40,44,38,9,50,51,52,53,39,4,40,9,54,56,42,46,44,48,50,54,52,56,39,39,16,17,18,40,24,25,26,41,34,35,36,57,56,13,14,16,19,20,55,54,21,22,24,28,29,41,31,32,34,37,38,19,37
];
hasDest = [
40,39,9,4,14,15,1,2,16,17,18,19,3,20,4,10,13,21,22,23,5,6,24,25,26,27,28,29,30,11,32,33,7,34,35,36,37,8,38,9,12,31,15,20,19,16,3,4,28,23,27,24,29,30,33,38,37,34,8,9,28,9,4,14,14,22,32,32,42,50,50,44,28,52,52,44,45,42,43,46,54,48,56,20,38,43,47,45,49,51,55,53,57,61,58,58,58,58,59,59,59,59,60,60,60,60,57,32,13,14,14,14,14,55,14,21,22,22,14,14,41,31,32,32,32,32,14,32
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx16" taint[16]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx34" taint[34]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx39" taint[39]=FOO;