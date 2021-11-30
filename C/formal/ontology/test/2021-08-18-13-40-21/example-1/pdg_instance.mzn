Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 10;
Inst_Br_start = 11;
Inst_Br_end = 14;
Inst_Other_start = 15;
Inst_Other_end = 61;
Inst_start = 1;
Inst_end = 61;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 62;
VarNode_StaticFunction_end = 64;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 62;
VarNode_end = 64;
FunctionEntry_start = 65;
FunctionEntry_end = 69;
Param_FormalIn_start = 70;
Param_FormalIn_end = 74;
Param_FormalOut_start = 75;
Param_FormalOut_end = 79;
Param_ActualIn_start = 80;
Param_ActualIn_end = 81;
Param_ActualOut_start = 82;
Param_ActualOut_end = 83;
Param_start = 70;
Param_end = 83;
Annotation_Var_start = 84;
Annotation_Var_end = 84;
Annotation_Global_start = 85;
Annotation_Global_end = 85;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 84;
Annotation_end = 85;
PDGNode_start = 1;
PDGNode_end = 85;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 4;
ControlDep_CallRet_start = 5;
ControlDep_CallRet_end = 8;
ControlDep_Entry_start = 9;
ControlDep_Entry_end = 69;
ControlDep_Br_start = 70;
ControlDep_Br_end = 84;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 84;
DataDepEdge_DefUse_start = 85;
DataDepEdge_DefUse_end = 139;
DataDepEdge_RAW_start = 140;
DataDepEdge_RAW_end = 147;
DataDepEdge_Ret_start = 148;
DataDepEdge_Ret_end = 151;
DataDepEdge_Alias_start = 152;
DataDepEdge_Alias_end = 152;
DataDepEdge_start = 85;
DataDepEdge_end = 152;
Parameter_In_start = 153;
Parameter_In_end = 164;
Parameter_Out_start = 165;
Parameter_Out_end = 172;
Parameter_Field_start = 173;
Parameter_Field_end = 174;
Parameter_start = 153;
Parameter_end = 174;
Anno_Global_start = 175;
Anno_Global_end = 177;
Anno_Var_start = 178;
Anno_Var_end = 179;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 175;
Anno_end = 179;
PDGEdge_start = 1;
PDGEdge_end = 179;
hasFunction = [
68,68,68,68,69,65,66,67,68,69,68,68,68,68,65,65,65,65,65,65,
65,65,67,65,65,65,65,65,65,65,66,66,66,66,67,67,67,67,68,68,
68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,69,69,69,69,69,
69,0,0,0,65,66,67,68,69,65,65,69,69,69,65,65,69,69,69,65,
65,65,65,68,0
];
hasSource = [
1,2,3,5,6,7,8,9,65,65,65,65,65,65,65,65,65,65,65,65,
65,65,65,65,66,66,66,66,66,67,67,67,67,67,67,68,68,68,68,68,
68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,
68,69,69,69,69,69,69,69,69,12,12,12,12,12,12,12,12,12,12,12,
12,12,12,12,62,62,62,63,63,63,64,64,64,64,15,15,16,16,17,21,
22,23,24,25,26,27,28,30,31,32,34,35,36,38,39,39,40,40,41,41,
41,42,42,42,42,45,46,1,2,49,50,3,52,53,54,56,57,58,5,18,
19,29,33,37,47,48,51,6,7,8,9,43,70,65,65,71,49,50,3,3,
69,69,80,81,65,65,3,3,69,69,82,83,73,78,63,64,66,68,43
];
hasDest = [
66,67,65,68,3,1,2,5,15,16,17,18,19,20,21,22,24,25,26,27,
28,29,30,6,32,33,34,7,31,35,23,36,37,38,8,39,40,41,42,43,
44,11,45,46,12,1,47,2,48,49,50,3,51,52,4,13,53,54,55,14,
9,56,57,58,59,60,61,5,10,1,47,2,48,49,50,3,51,52,4,13,
53,54,55,14,30,29,26,34,33,31,38,37,23,35,21,18,22,19,20,24,
24,36,25,28,27,28,29,6,32,33,7,36,37,8,49,47,50,48,52,51,
43,55,53,45,44,46,12,47,48,3,3,51,4,54,55,59,60,61,10,21,
22,30,34,38,49,50,52,3,1,2,5,41,21,70,71,22,80,81,80,81,
72,73,70,71,75,76,82,83,77,78,49,50,74,79,85,85,85,84,84
];
hasParamIdx = array1d(Param, [
1,2,1,2,-1,1,2,1,2,-1,1,2,1,2
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,true,false,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx43" taint[43]=PURPLE;
constraint ::  "TaintOnNodeIdx63" taint[63]=ORANGE;
constraint ::  "TaintOnNodeIdx64" taint[64]=PURPLE;
constraint ::  "TaintOnNodeIdx66" taint[66]=XDLINKAGE_GET_A;
