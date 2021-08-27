Inst_FunCall_start = 1;
Inst_FunCall_end = 6;
Inst_Ret_start = 7;
Inst_Ret_end = 12;
Inst_Br_start = 13;
Inst_Br_end = 16;
Inst_Other_start = 17;
Inst_Other_end = 73;
Inst_start = 1;
Inst_end = 73;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 74;
VarNode_StaticFunction_end = 76;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 74;
VarNode_end = 76;
FunctionEntry_start = 77;
FunctionEntry_end = 82;
Param_FormalIn_start = 83;
Param_FormalIn_end = 85;
Param_FormalOut_start = 86;
Param_FormalOut_end = 88;
Param_ActualIn_start = 89;
Param_ActualIn_end = 91;
Param_ActualOut_start = 92;
Param_ActualOut_end = 94;
Param_start = 83;
Param_end = 94;
Annotation_Var_start = 95;
Annotation_Var_end = 99;
Annotation_Global_start = 100;
Annotation_Global_end = 100;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 95;
Annotation_end = 100;
PDGNode_start = 1;
PDGNode_end = 100;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 5;
ControlDep_CallRet_start = 6;
ControlDep_CallRet_end = 10;
ControlDep_Entry_start = 11;
ControlDep_Entry_end = 88;
ControlDep_Br_start = 89;
ControlDep_Br_end = 100;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 100;
DataDepEdge_DefUse_start = 101;
DataDepEdge_DefUse_end = 167;
DataDepEdge_RAW_start = 168;
DataDepEdge_RAW_end = 176;
DataDepEdge_Ret_start = 177;
DataDepEdge_Ret_end = 181;
DataDepEdge_Alias_start = 182;
DataDepEdge_Alias_end = 186;
DataDepEdge_start = 101;
DataDepEdge_end = 186;
Parameter_In_start = 187;
Parameter_In_end = 201;
Parameter_Out_start = 202;
Parameter_Out_end = 210;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 187;
Parameter_end = 210;
Anno_Global_start = 211;
Anno_Global_end = 213;
Anno_Var_start = 214;
Anno_Var_end = 218;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 211;
Anno_end = 218;
PDGEdge_start = 1;
PDGEdge_end = 218;
hasFunction = [
77,77,81,81,81,82,77,78,79,80,81,82,81,81,81,81,77,77,77,77,
77,77,77,77,77,77,77,77,77,77,77,77,78,78,78,78,78,79,79,79,
79,79,79,79,79,79,79,79,79,79,79,79,80,80,80,80,81,81,81,81,
81,81,81,81,81,81,81,81,81,81,81,82,82,0,0,0,77,78,79,80,
81,82,77,79,79,77,79,79,79,79,77,79,79,77,77,77,77,77,81,0
];
hasSource = [
1,2,3,4,6,7,8,9,10,11,77,77,77,77,77,77,77,77,77,77,
77,77,77,77,77,77,77,77,77,77,77,77,77,78,78,78,78,78,78,79,
79,79,79,79,79,79,79,79,79,79,79,79,79,79,79,80,80,80,80,80,
81,81,81,81,81,81,81,81,81,81,81,81,81,81,81,81,81,81,81,81,
81,81,81,81,82,82,82,82,14,14,14,14,14,14,14,14,14,14,14,14,
74,74,74,75,75,75,75,76,76,76,17,17,17,18,18,18,19,19,19,20,
20,20,26,1,29,30,2,32,33,34,35,37,38,38,39,39,40,44,45,46,
47,48,49,50,52,53,54,56,57,57,59,59,59,60,60,60,60,63,64,3,
66,4,68,69,70,72,6,28,31,36,41,42,51,55,65,67,7,8,9,10,
11,22,23,24,25,61,83,77,29,30,2,2,79,79,84,85,66,4,89,90,
91,77,2,2,79,79,4,92,93,94,74,75,77,22,23,24,25,61
];
hasDest = [
78,79,80,77,81,4,1,2,3,6,18,19,20,21,22,95,23,96,24,97,
25,98,26,27,1,28,29,30,2,31,32,7,17,34,35,36,37,8,33,38,
39,40,41,42,43,44,45,46,47,48,49,50,51,52,9,54,55,56,10,53,
57,58,59,60,61,99,62,13,63,64,14,3,65,66,4,67,68,5,15,69,
70,71,16,11,72,73,6,12,3,65,66,4,67,68,5,15,69,70,71,16,
56,55,53,37,36,34,33,52,51,48,26,22,21,29,27,23,30,28,24,32,
31,25,27,28,2,2,31,7,35,35,36,8,44,41,45,42,43,46,46,47,
50,49,50,51,9,54,55,10,66,65,68,67,61,71,69,63,62,64,14,65,
4,67,5,70,71,73,12,30,32,37,44,45,52,56,66,68,4,1,2,3,
6,17,18,19,20,59,26,83,89,90,89,90,84,85,44,45,91,91,84,85,
83,86,92,93,87,88,94,29,30,66,100,100,100,95,96,97,98,99
];
hasParamIdx = array1d(Param, [
1,1,2,1,1,2,1,2,1,1,2,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 true,false,false,false,false,false
]);
MaxFuncParms = 3;
% constraint ::  "TaintOnNodeIdx22" taint[22]=XDLINKAGE_GET_EWMA;
constraint ::  "TaintOnNodeIdx23" taint[23]=PURPLE_SHAREABLE;
constraint ::  "TaintOnNodeIdx24" taint[24]=PURPLE_SHAREABLE;
constraint ::  "TaintOnNodeIdx25" taint[25]=PURPLE_SHAREABLE;
constraint ::  "TaintOnNodeIdx61" taint[61]=ORANGE;
constraint ::  "TaintOnNodeIdx74" taint[74]=ORANGE;
constraint ::  "TaintOnNodeIdx75" taint[75]=PURPLE;
constraint ::  "TaintOnNodeIdx77" taint[77]=XDLINKAGE_GET_EWMA;
