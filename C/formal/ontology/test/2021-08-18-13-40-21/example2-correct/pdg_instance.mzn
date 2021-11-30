Inst_FunCall_start = 1;
Inst_FunCall_end = 6;
Inst_Ret_start = 7;
Inst_Ret_end = 12;
Inst_Br_start = 13;
Inst_Br_end = 16;
Inst_Other_start = 17;
Inst_Other_end = 72;
Inst_start = 1;
Inst_end = 72;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 73;
VarNode_StaticFunction_end = 75;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 73;
VarNode_end = 75;
FunctionEntry_start = 76;
FunctionEntry_end = 81;
Param_FormalIn_start = 82;
Param_FormalIn_end = 84;
Param_FormalOut_start = 85;
Param_FormalOut_end = 87;
Param_ActualIn_start = 88;
Param_ActualIn_end = 90;
Param_ActualOut_start = 91;
Param_ActualOut_end = 93;
Param_start = 82;
Param_end = 93;
Annotation_Var_start = 94;
Annotation_Var_end = 97;
Annotation_Global_start = 98;
Annotation_Global_end = 98;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 94;
Annotation_end = 98;
PDGNode_start = 1;
PDGNode_end = 98;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 5;
ControlDep_CallRet_start = 6;
ControlDep_CallRet_end = 10;
ControlDep_Entry_start = 11;
ControlDep_Entry_end = 82;
ControlDep_Br_start = 83;
ControlDep_Br_end = 94;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 94;
DataDepEdge_DefUse_start = 95;
DataDepEdge_DefUse_end = 160;
DataDepEdge_RAW_start = 161;
DataDepEdge_RAW_end = 170;
DataDepEdge_Ret_start = 171;
DataDepEdge_Ret_end = 175;
DataDepEdge_Alias_start = 176;
DataDepEdge_Alias_end = 179;
DataDepEdge_start = 95;
DataDepEdge_end = 179;
Parameter_In_start = 180;
Parameter_In_end = 194;
Parameter_Out_start = 195;
Parameter_Out_end = 203;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 180;
Parameter_end = 203;
Anno_Global_start = 204;
Anno_Global_end = 206;
Anno_Var_start = 207;
Anno_Var_end = 214;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 204;
Anno_end = 214;
PDGEdge_start = 1;
PDGEdge_end = 214;
hasFunction = [
79,79,80,80,80,81,76,77,78,79,80,81,80,80,80,80,76,76,76,76,
76,76,76,76,78,76,76,76,76,76,76,76,77,77,77,77,78,78,78,78,
79,79,79,79,79,79,79,79,79,79,79,79,79,79,79,80,80,80,80,80,
80,80,80,80,80,80,80,80,80,80,81,81,0,0,0,76,77,78,79,80,
81,76,76,79,76,76,79,76,76,79,76,76,79,79,79,79,80,0
];
hasSource = [
1,2,3,4,6,7,8,9,10,11,76,76,76,76,76,76,76,76,76,76,
76,76,76,76,76,76,77,77,77,77,77,78,78,78,78,78,78,79,79,79,
79,79,79,79,79,79,79,79,79,79,79,79,79,79,79,80,80,80,80,80,
80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,81,81,
81,81,14,14,14,14,14,14,14,14,14,14,14,14,73,73,73,74,74,74,
75,75,75,75,17,17,18,18,19,23,24,25,26,27,28,29,30,32,33,34,
36,37,38,40,41,41,42,42,42,43,43,43,44,44,44,49,1,52,53,2,
55,56,56,58,58,58,59,59,59,59,62,63,3,65,4,67,68,69,71,6,
20,21,31,35,39,45,51,54,64,66,7,8,9,10,11,46,47,48,60,82,
76,76,83,79,52,53,2,2,84,65,4,88,89,90,76,76,79,2,2,4,
91,92,93,74,75,79,79,79,79,80,46,47,48,60
];
hasDest = [
78,76,77,79,80,2,3,1,4,6,18,19,20,21,22,23,24,26,27,28,
29,30,31,32,7,17,33,34,35,36,8,25,38,39,40,9,37,41,42,43,
44,45,46,47,48,49,50,1,51,52,53,2,54,55,10,56,57,58,59,60,
61,13,62,63,14,3,64,65,4,66,67,5,15,68,69,70,16,11,71,72,
6,12,3,64,65,4,66,67,5,15,68,69,70,16,32,31,28,36,35,33,
40,39,25,37,23,20,24,21,22,26,26,38,27,30,29,30,31,7,34,35,
8,38,39,9,49,45,52,50,46,53,51,47,55,54,48,50,51,2,2,54,
10,64,65,67,66,60,70,68,62,61,63,14,64,4,66,5,69,70,72,12,
23,24,32,36,40,49,53,55,65,67,2,3,1,4,6,42,43,44,58,23,
82,83,24,84,88,89,88,89,49,90,90,82,83,84,85,86,87,91,92,93,
52,53,65,98,98,98,94,95,96,97,94,95,96,97
];
hasParamIdx = array1d(Param, [
1,2,1,1,2,1,1,2,1,1,2,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false,false,true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx46" taint[46]=PURPLE_SHAREABLE;
constraint ::  "TaintOnNodeIdx47" taint[47]=PURPLE_SHAREABLE;
constraint ::  "TaintOnNodeIdx48" taint[48]=PURPLE_SHAREABLE;
constraint ::  "TaintOnNodeIdx60" taint[60]=ORANGE;
constraint ::  "TaintOnNodeIdx74" taint[74]=ORANGE;
constraint ::  "TaintOnNodeIdx75" taint[75]=PURPLE;
constraint ::  "TaintOnNodeIdx79" taint[79]=XDLINKAGE_GET_EWMA;
