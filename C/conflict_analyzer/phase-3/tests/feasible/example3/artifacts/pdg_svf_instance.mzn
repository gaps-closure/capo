Inst_FunCall_start = 1;
Inst_FunCall_end = 14;
Inst_Ret_start = 15;
Inst_Ret_end = 20;
Inst_Br_start = 21;
Inst_Br_end = 24;
Inst_Other_start = 25;
Inst_Other_end = 65;
Inst_start = 1;
Inst_end = 65;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 66;
VarNode_StaticFunction_end = 68;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 66;
VarNode_end = 68;
FunctionEntry_start = 69;
FunctionEntry_end = 74;
Param_FormalIn_start = 75;
Param_FormalIn_end = 76;
Param_FormalOut_start = 77;
Param_FormalOut_end = 78;
Param_ActualIn_start = 79;
Param_ActualIn_end = 80;
Param_ActualOut_start = 81;
Param_ActualOut_end = 82;
Param_start = 75;
Param_end = 82;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 83;
Annotation_Global_end = 83;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 83;
Annotation_end = 83;
PDGNode_start = 1;
PDGNode_end = 83;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 5;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 6;
ControlDep_CallRet_end = 10;
ControlDep_Entry_start = 11;
ControlDep_Entry_end = 75;
ControlDep_Br_start = 76;
ControlDep_Br_end = 85;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 85;
DataDepEdge_DefUse_start = 86;
DataDepEdge_DefUse_end = 138;
DataDepEdge_RAW_start = 139;
DataDepEdge_RAW_end = 146;
DataDepEdge_Ret_start = 147;
DataDepEdge_Ret_end = 151;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 86;
DataDepEdge_end = 151;
Parameter_In_start = 152;
Parameter_In_end = 161;
Parameter_Out_start = 162;
Parameter_Out_end = 167;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 152;
Parameter_end = 167;
Anno_Global_start = 168;
Anno_Global_end = 172;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 168;
Anno_end = 172;
DataDepEdge_PointsTo_start = 0;
DataDepEdge_PointsTo_end = -1;
PDGEdge_start = 1;
PDGEdge_end = 172;
hasFunction = [
69,69,69,69,70,70,70,70,70,71,71,71,71,74,69,70,71,72,73,74,71,71,71,71,69,69,69,69,69,69,69,69,69,69,69,69,69,70,70,70,70,70,70,71,71,71,71,71,71,71,71,71,71,71,72,72,72,72,73,73,73,73,73,74,74,0,0,0,69,70,71,72,73,74,69,69,69,69,69,69,69,69,0
];
hasSource = [
6,8,9,12,14,15,16,17,18,19,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,69,70,70,70,70,70,70,70,70,70,70,70,70,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,72,72,72,72,72,73,73,73,73,73,73,74,74,74,74,22,22,22,22,22,22,22,22,22,22,66,66,66,67,67,67,68,68,68,68,25,25,26,26,27,31,32,33,34,35,4,37,38,38,39,39,6,8,42,43,9,44,44,45,45,45,45,47,48,12,50,51,52,53,55,56,58,59,60,61,63,64,14,28,29,36,40,41,49,57,62,15,16,17,18,19,75,69,69,76,42,43,9,9,79,80,69,69,9,9,81,82,67,68,69,70,71
];
hasDest = [
72,73,69,70,71,9,12,14,6,8,25,26,27,28,1,29,2,3,30,31,32,33,34,35,4,36,37,15,39,5,6,40,7,8,41,42,43,9,16,38,45,10,11,46,21,47,48,22,12,49,50,51,13,23,52,53,54,24,17,44,56,57,58,18,55,59,60,61,62,63,19,64,65,14,20,12,49,50,51,13,23,52,53,54,24,37,36,34,58,57,55,63,62,60,59,31,28,32,29,30,33,33,4,35,4,36,15,42,40,43,41,40,41,9,9,16,50,49,54,52,47,46,48,22,49,13,13,53,54,56,57,18,61,61,62,19,65,20,31,32,37,42,43,50,58,63,9,12,14,6,8,31,75,76,32,79,80,79,80,75,76,77,78,81,82,42,43,83,83,83,83,83
];
hasParamIdx = array1d(Param, [
1,2,1,2,1,2,1,2
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true,true,false,false,false
]);
MaxFuncParms = 2;
constraint :: "TaintOnNodeIdx67" taint[67]=ORANGE;
constraint :: "TaintOnNodeIdx68" taint[68]=ORANGE;
constraint :: "TaintOnNodeIdx69" taint[69]=EWMA_SHAREABLE;
constraint :: "TaintOnNodeIdx70" taint[70]=XDLINKAGE_GET_EWMA;
constraint :: "TaintOnNodeIdx71" taint[71]=EWMA_MAIN;