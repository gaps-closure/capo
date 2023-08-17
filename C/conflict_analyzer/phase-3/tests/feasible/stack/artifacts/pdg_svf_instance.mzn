Inst_FunCall_start = 1;
Inst_FunCall_end = 9;
Inst_Ret_start = 10;
Inst_Ret_end = 12;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 13;
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
Annotation_Var_end = 54;
Annotation_Global_start = 55;
Annotation_Global_end = 55;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 52;
Annotation_end = 55;
PDGNode_start = 1;
PDGNode_end = 55;
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
DataDepEdge_DefUse_end = 54;
DataDepEdge_RAW_start = 55;
DataDepEdge_RAW_end = 55;
DataDepEdge_Ret_start = 56;
DataDepEdge_Ret_end = 57;
DataDepEdge_Alias_start = 58;
DataDepEdge_Alias_end = 62;
DataDepEdge_start = 37;
DataDepEdge_end = 62;
Parameter_In_start = 63;
Parameter_In_end = 73;
Parameter_Out_start = 74;
Parameter_Out_end = 79;
Parameter_Field_start = 80;
Parameter_Field_end = 87;
Parameter_start = 63;
Parameter_end = 87;
Anno_Global_start = 88;
Anno_Global_end = 88;
Anno_Var_start = 89;
Anno_Var_end = 94;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 88;
Anno_end = 94;
DataDepEdge_PointsTo_start = 95;
DataDepEdge_PointsTo_end = 116;
PDGEdge_start = 1;
PDGEdge_end = 116;
hasFunction = [
33,33,33,33,34,34,35,35,35,33,34,35,33,33,33,33,33,33,34,34,34,34,34,34,34,34,35,35,35,35,35,35,33,34,35,33,33,34,34,33,33,34,34,34,34,33,33,34,34,33,33,33,34,35,0
];
hasSource = [
4,9,10,11,33,33,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,34,34,34,34,35,35,35,35,35,35,35,35,35,35,13,14,14,14,17,18,19,19,20,20,24,25,27,28,28,28,31,32,21,10,11,16,17,22,30,31,33,18,4,34,38,32,9,44,45,46,47,33,4,34,9,48,50,36,40,38,42,44,48,46,50,33,33,16,34,22,35,30,51,50,13,14,16,18,10,49,48,19,20,22,26,11,35,27,28,30,32,12,18,32
];
hasDest = [
34,33,9,4,13,14,15,1,2,16,17,3,18,4,10,19,20,21,5,6,22,23,24,25,26,11,28,29,7,30,31,8,32,9,12,27,15,18,17,16,3,4,24,21,23,22,25,26,29,32,31,30,8,9,24,9,4,14,14,20,28,28,36,44,44,38,24,46,46,38,39,36,37,40,48,42,50,18,32,37,41,39,43,45,49,47,51,55,52,52,53,53,54,54,51,28,13,14,14,14,14,49,14,19,20,20,14,14,35,27,28,28,28,28,14,28
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx16" taint[16]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx22" taint[22]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx30" taint[30]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx33" taint[33]=FOO;