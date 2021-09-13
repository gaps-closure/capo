Inst_FunCall_start = 1;
Inst_FunCall_end = 6;
Inst_Ret_start = 7;
Inst_Ret_end = 12;
Inst_Br_start = 13;
Inst_Br_end = 16;
Inst_Other_start = 17;
Inst_Other_end = 62;
Inst_start = 1;
Inst_end = 62;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 63;
VarNode_StaticFunction_end = 65;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 63;
VarNode_end = 65;
FunctionEntry_start = 66;
FunctionEntry_end = 71;
Param_FormalIn_start = 72;
Param_FormalIn_end = 76;
Param_FormalOut_start = 77;
Param_FormalOut_end = 81;
Param_ActualIn_start = 82;
Param_ActualIn_end = 83;
Param_ActualOut_start = 84;
Param_ActualOut_end = 85;
Param_start = 72;
Param_end = 85;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 86;
Annotation_Global_end = 86;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 86;
Annotation_end = 86;
PDGNode_start = 1;
PDGNode_end = 86;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 5;
ControlDep_CallRet_start = 6;
ControlDep_CallRet_end = 10;
ControlDep_Entry_start = 11;
ControlDep_Entry_end = 72;
ControlDep_Br_start = 73;
ControlDep_Br_end = 81;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 81;
DataDepEdge_DefUse_start = 82;
DataDepEdge_DefUse_end = 136;
DataDepEdge_RAW_start = 137;
DataDepEdge_RAW_end = 144;
DataDepEdge_Ret_start = 145;
DataDepEdge_Ret_end = 149;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 82;
DataDepEdge_end = 149;
Parameter_In_start = 150;
Parameter_In_end = 161;
Parameter_Out_start = 162;
Parameter_Out_end = 169;
Parameter_Field_start = 170;
Parameter_Field_end = 171;
Parameter_start = 150;
Parameter_end = 171;
Anno_Global_start = 172;
Anno_Global_end = 176;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 172;
Anno_end = 176;
PDGEdge_start = 1;
PDGEdge_end = 176;
hasFunction = [
67,67,67,68,68,71,66,67,68,69,70,71,68,68,68,68,66,66,66,66,
66,66,66,66,67,66,66,66,66,66,66,66,67,67,67,67,67,68,68,68,
68,68,68,68,68,68,68,69,69,69,69,70,70,70,70,70,71,71,71,71,
71,71,0,0,0,66,67,68,69,70,71,66,66,71,71,71,66,66,71,71,
71,66,66,66,66,0
];
hasSource = [
1,2,3,4,6,7,8,9,10,11,66,66,66,66,66,66,66,66,66,66,
66,66,66,66,66,66,67,67,67,67,67,67,67,67,67,67,68,68,68,68,
68,68,68,68,68,68,68,68,68,68,68,68,68,69,69,69,69,69,70,70,
70,70,70,70,71,71,71,71,71,71,71,71,14,14,14,14,14,14,14,14,
14,63,63,63,64,64,64,64,65,65,65,17,17,18,18,19,23,24,26,27,
28,29,30,32,33,33,34,34,1,2,36,37,3,38,38,39,39,39,39,41,
42,4,44,45,46,48,49,51,52,53,54,56,57,58,59,6,20,21,25,31,
35,43,50,55,7,8,9,10,11,72,66,66,73,36,37,3,3,71,71,82,
83,66,66,3,3,71,71,84,85,75,80,63,64,66,67,68
];
hasDest = [
69,70,66,67,68,3,4,6,1,2,18,19,20,21,22,23,24,26,27,28,
29,30,31,32,7,17,33,34,1,35,2,25,36,37,3,8,39,40,13,41,
42,14,4,43,44,5,15,45,46,47,16,9,38,49,50,51,10,48,52,53,
54,55,56,11,57,58,59,60,61,62,6,12,4,43,44,5,15,45,46,47,
16,51,50,48,56,55,53,52,32,31,28,23,20,24,21,22,26,26,27,30,
29,30,31,7,36,35,37,25,35,25,3,3,8,44,43,47,45,41,40,42,
14,43,5,46,47,49,50,10,54,54,55,11,60,61,62,12,23,24,37,32,
36,44,51,56,3,4,6,1,2,23,72,73,24,82,83,82,83,74,75,72,
73,77,78,84,85,79,80,36,37,76,81,86,86,86,86,86
];
hasParamIdx = array1d(Param, [
1,2,1,2,-1,1,2,1,2,-1,1,2,1,2
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 true,true,true,false,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx63" taint[63]=ORANGE;
constraint ::  "TaintOnNodeIdx64" taint[64]=ORANGE;
constraint ::  "TaintOnNodeIdx66" taint[66]=EWMA_SHAREABLE;
constraint ::  "TaintOnNodeIdx67" taint[67]=XDLINKAGE_GET_EWMA;
constraint ::  "TaintOnNodeIdx68" taint[68]=PURPLE;
