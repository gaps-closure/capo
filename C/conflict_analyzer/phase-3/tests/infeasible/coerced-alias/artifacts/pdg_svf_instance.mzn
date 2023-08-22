Inst_FunCall_start = 1;
Inst_FunCall_end = 7;
Inst_Ret_start = 8;
Inst_Ret_end = 10;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 11;
Inst_Other_end = 32;
Inst_start = 1;
Inst_end = 32;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 33;
VarNode_end = 32;
FunctionEntry_start = 33;
FunctionEntry_end = 35;
Param_FormalIn_start = 36;
Param_FormalIn_end = 39;
Param_FormalOut_start = 40;
Param_FormalOut_end = 43;
Param_ActualIn_start = 44;
Param_ActualIn_end = 47;
Param_ActualOut_start = 48;
Param_ActualOut_end = 51;
Param_start = 36;
Param_end = 51;
Annotation_Var_start = 52;
Annotation_Var_end = 53;
Annotation_Global_start = 54;
Annotation_Global_end = 54;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 52;
Annotation_end = 54;
PDGNode_start = 1;
PDGNode_end = 54;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 36;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 36;
DataDepEdge_DefUse_start = 37;
DataDepEdge_DefUse_end = 53;
DataDepEdge_RAW_start = 54;
DataDepEdge_RAW_end = 56;
DataDepEdge_Ret_start = 57;
DataDepEdge_Ret_end = 58;
DataDepEdge_Alias_start = 59;
DataDepEdge_Alias_end = 62;
DataDepEdge_start = 37;
DataDepEdge_end = 62;
Parameter_In_start = 63;
Parameter_In_end = 74;
Parameter_Out_start = 75;
Parameter_Out_end = 80;
Parameter_Field_start = 81;
Parameter_Field_end = 88;
Parameter_start = 63;
Parameter_end = 88;
Anno_Global_start = 89;
Anno_Global_end = 89;
Anno_Var_start = 90;
Anno_Var_end = 97;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 89;
Anno_end = 97;
DataDepEdge_PointsTo_start = 98;
DataDepEdge_PointsTo_end = 108;
PDGEdge_start = 1;
PDGEdge_end = 108;
hasFunction = [
33,33,33,34,35,35,35,33,34,35,33,33,33,33,33,33,33,33,33,34,34,34,34,34,35,35,35,35,35,35,35,35,33,34,35,33,33,34,34,33,33,34,34,34,34,33,33,34,34,33,33,33,35,0
];
hasSource = [
3,7,8,9,33,33,33,33,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,35,35,35,35,35,35,35,35,35,35,35,35,11,11,12,12,12,17,19,20,20,22,23,25,26,26,26,31,32,13,18,21,8,9,14,19,28,31,36,33,19,3,34,38,32,7,44,45,46,47,33,3,34,7,48,50,36,40,38,42,44,48,46,50,33,33,14,15,16,35,28,29,30,50,14,17,19,48,22,23,28,31,32,31
];
hasDest = [
34,33,7,3,11,12,13,1,2,14,15,16,17,18,19,3,8,21,4,22,23,24,9,20,25,26,27,5,28,29,30,31,6,32,7,10,17,13,19,18,14,18,3,22,21,23,24,27,32,31,28,6,7,17,19,22,7,3,12,17,26,26,17,36,44,44,38,22,46,46,38,39,36,37,40,48,42,50,19,32,37,41,39,43,45,49,47,51,54,52,52,52,52,53,53,53,53,26,12,26,26,26,26,26,26,26,26,26
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx14" taint[14]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx28" taint[28]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx33" taint[33]=FOO;