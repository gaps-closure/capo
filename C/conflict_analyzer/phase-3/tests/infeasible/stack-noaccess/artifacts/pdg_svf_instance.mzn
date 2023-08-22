Inst_FunCall_start = 1;
Inst_FunCall_end = 7;
Inst_Ret_start = 8;
Inst_Ret_end = 10;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 11;
Inst_Other_end = 28;
Inst_start = 1;
Inst_end = 28;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 29;
VarNode_end = 28;
FunctionEntry_start = 29;
FunctionEntry_end = 31;
Param_FormalIn_start = 32;
Param_FormalIn_end = 35;
Param_FormalOut_start = 36;
Param_FormalOut_end = 39;
Param_ActualIn_start = 40;
Param_ActualIn_end = 43;
Param_ActualOut_start = 44;
Param_ActualOut_end = 47;
Param_start = 32;
Param_end = 47;
Annotation_Var_start = 48;
Annotation_Var_end = 49;
Annotation_Global_start = 50;
Annotation_Global_end = 50;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 48;
Annotation_end = 50;
PDGNode_start = 1;
PDGNode_end = 50;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 32;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 32;
DataDepEdge_DefUse_start = 33;
DataDepEdge_DefUse_end = 44;
DataDepEdge_RAW_start = 45;
DataDepEdge_RAW_end = 45;
DataDepEdge_Ret_start = 46;
DataDepEdge_Ret_end = 47;
DataDepEdge_Alias_start = 48;
DataDepEdge_Alias_end = 50;
DataDepEdge_start = 33;
DataDepEdge_end = 50;
Parameter_In_start = 51;
Parameter_In_end = 61;
Parameter_Out_start = 62;
Parameter_Out_end = 67;
Parameter_Field_start = 68;
Parameter_Field_end = 75;
Parameter_start = 51;
Parameter_end = 75;
Anno_Global_start = 76;
Anno_Global_end = 76;
Anno_Var_start = 77;
Anno_Var_end = 84;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 76;
Anno_end = 84;
DataDepEdge_PointsTo_start = 85;
DataDepEdge_PointsTo_end = 92;
PDGEdge_start = 1;
PDGEdge_end = 92;
hasFunction = [
29,29,30,30,31,31,31,29,30,31,29,29,29,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,29,30,31,29,29,30,30,29,29,30,30,30,30,29,29,30,30,29,29,30,31,0
];
hasSource = [
2,7,8,9,29,29,29,29,29,29,30,30,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,31,31,31,31,11,11,13,14,15,15,21,22,22,22,27,28,12,8,9,17,24,27,32,29,13,2,30,28,7,40,41,42,43,29,2,30,7,44,46,32,36,34,38,40,44,42,46,29,30,17,18,19,31,24,25,26,46,13,44,17,24,27,28,27
];
hasDest = [
30,29,7,2,11,12,1,13,2,8,15,16,3,4,17,18,19,20,9,14,21,22,23,5,24,25,26,27,6,28,7,10,13,12,2,16,20,17,23,28,27,24,6,7,13,7,2,15,22,22,13,32,40,40,34,42,42,34,35,32,33,36,44,38,46,13,28,33,37,35,39,41,45,43,47,50,48,48,48,48,49,49,49,49,22,22,22,15,22,22,22,22
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx17" taint[17]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx29" taint[29]=FOO;