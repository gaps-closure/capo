Inst_FunCall_start = 1;
Inst_FunCall_end = 6;
Inst_Ret_start = 7;
Inst_Ret_end = 12;
Inst_Br_start = 13;
Inst_Br_end = 16;
Inst_Other_start = 17;
Inst_Other_end = 64;
Inst_start = 1;
Inst_end = 64;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 65;
VarNode_StaticFunction_end = 67;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 65;
VarNode_end = 67;
FunctionEntry_start = 68;
FunctionEntry_end = 73;
Param_FormalIn_start = 74;
Param_FormalIn_end = 78;
Param_FormalOut_start = 79;
Param_FormalOut_end = 83;
Param_ActualIn_start = 84;
Param_ActualIn_end = 85;
Param_ActualOut_start = 86;
Param_ActualOut_end = 87;
Param_start = 74;
Param_end = 87;
Annotation_Var_start = 88;
Annotation_Var_end = 89;
Annotation_Global_start = 90;
Annotation_Global_end = 90;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 88;
Annotation_end = 90;
PDGNode_start = 1;
PDGNode_end = 90;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 5;
ControlDep_CallRet_start = 6;
ControlDep_CallRet_end = 10;
ControlDep_Entry_start = 11;
ControlDep_Entry_end = 76;
ControlDep_Br_start = 77;
ControlDep_Br_end = 85;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 85;
DataDepEdge_DefUse_start = 86;
DataDepEdge_DefUse_end = 142;
DataDepEdge_RAW_start = 143;
DataDepEdge_RAW_end = 148;
DataDepEdge_Ret_start = 149;
DataDepEdge_Ret_end = 153;
DataDepEdge_Alias_start = 154;
DataDepEdge_Alias_end = 155;
DataDepEdge_start = 86;
DataDepEdge_end = 155;
Parameter_In_start = 156;
Parameter_In_end = 167;
Parameter_Out_start = 168;
Parameter_Out_end = 175;
Parameter_Field_start = 176;
Parameter_Field_end = 177;
Parameter_start = 156;
Parameter_end = 177;
Anno_Global_start = 178;
Anno_Global_end = 182;
Anno_Var_start = 183;
Anno_Var_end = 184;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 178;
Anno_end = 184;
PDGEdge_start = 1;
PDGEdge_end = 184;
hasFunction = [
69,69,69,70,70,73,68,69,70,71,72,73,70,70,70,70,68,68,68,68,
68,68,68,68,68,68,68,68,68,68,68,68,68,69,69,69,69,69,69,70,
70,70,70,70,70,70,70,70,70,71,71,71,71,72,72,72,72,72,73,73,
73,73,73,73,0,0,0,68,69,70,71,72,73,68,68,73,73,73,68,68,
73,73,73,68,68,68,68,68,68,0
];
hasSource = [
1,2,3,4,6,7,8,9,10,11,68,68,68,68,68,68,68,68,68,68,
68,68,68,68,68,68,68,68,68,68,69,69,69,69,69,69,69,69,69,69,
70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,71,71,71,
71,71,72,72,72,72,72,72,73,73,73,73,73,73,73,73,14,14,14,14,
14,14,14,14,14,65,65,65,66,66,66,66,67,67,67,17,17,17,18,18,
18,19,1,25,26,27,28,29,30,31,33,34,34,35,35,2,38,39,3,40,
40,41,41,41,41,43,44,4,46,47,48,50,51,53,54,55,56,58,59,60,
61,6,32,36,37,45,52,57,7,8,9,10,11,21,23,74,68,68,75,38,
39,3,3,73,73,84,85,68,68,3,3,73,73,86,87,77,82,65,66,68,
69,70,21,23
];
hasDest = [
71,72,68,69,70,3,4,6,1,2,18,19,20,21,88,22,23,89,24,25,
26,27,28,29,30,31,32,33,7,17,34,35,1,36,2,37,38,39,3,8,
41,42,13,43,44,14,4,45,46,5,15,47,48,49,16,9,40,51,52,53,
10,50,54,55,56,57,58,11,59,60,61,62,63,64,6,12,4,45,46,5,
15,47,48,49,16,53,52,50,58,57,55,54,33,32,29,25,21,20,26,23,
22,24,36,27,27,28,31,30,31,32,7,38,36,39,37,37,3,3,8,46,
45,49,47,43,42,44,14,45,5,48,49,51,52,10,56,56,57,11,62,63,
64,12,33,38,39,46,53,58,3,4,6,1,2,17,18,25,74,75,26,84,
85,84,85,76,77,74,75,79,80,86,87,81,82,38,39,78,83,90,90,90,
90,90,88,89
];
hasParamIdx = array1d(Param, [
1,2,1,2,-1,1,2,1,2,-1,1,2,1,2
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 true,true,true,false,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx21" taint[21]=EWMA_SHAREABLE;
constraint ::  "TaintOnNodeIdx23" taint[23]=EWMA_SHAREABLE;
constraint ::  "TaintOnNodeIdx65" taint[65]=ORANGE;
constraint ::  "TaintOnNodeIdx66" taint[66]=ORANGE;
constraint ::  "TaintOnNodeIdx68" taint[68]=EWMA_SHAREABLE;
constraint ::  "TaintOnNodeIdx69" taint[69]=XDLINKAGE_GET_EWMA;
constraint ::  "TaintOnNodeIdx70" taint[70]=PURPLE;
