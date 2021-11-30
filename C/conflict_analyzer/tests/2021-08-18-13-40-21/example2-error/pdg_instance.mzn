Inst_FunCall_start = 1;
Inst_FunCall_end = 6;
Inst_Ret_start = 7;
Inst_Ret_end = 12;
Inst_Br_start = 13;
Inst_Br_end = 16;
Inst_Other_start = 17;
Inst_Other_end = 63;
Inst_start = 1;
Inst_end = 63;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 64;
VarNode_StaticFunction_end = 66;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 64;
VarNode_end = 66;
FunctionEntry_start = 67;
FunctionEntry_end = 72;
Param_FormalIn_start = 73;
Param_FormalIn_end = 75;
Param_FormalOut_start = 76;
Param_FormalOut_end = 78;
Param_ActualIn_start = 79;
Param_ActualIn_end = 81;
Param_ActualOut_start = 82;
Param_ActualOut_end = 84;
Param_start = 73;
Param_end = 84;
Annotation_Var_start = 85;
Annotation_Var_end = 85;
Annotation_Global_start = 86;
Annotation_Global_end = 86;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 85;
Annotation_end = 86;
PDGNode_start = 1;
PDGNode_end = 86;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 5;
ControlDep_CallRet_start = 6;
ControlDep_CallRet_end = 10;
ControlDep_Entry_start = 11;
ControlDep_Entry_end = 73;
ControlDep_Br_start = 74;
ControlDep_Br_end = 85;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 85;
DataDepEdge_DefUse_start = 86;
DataDepEdge_DefUse_end = 142;
DataDepEdge_RAW_start = 143;
DataDepEdge_RAW_end = 151;
DataDepEdge_Ret_start = 152;
DataDepEdge_Ret_end = 156;
DataDepEdge_Alias_start = 157;
DataDepEdge_Alias_end = 157;
DataDepEdge_start = 86;
DataDepEdge_end = 157;
Parameter_In_start = 158;
Parameter_In_end = 172;
Parameter_Out_start = 173;
Parameter_Out_end = 181;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 158;
Parameter_end = 181;
Anno_Global_start = 182;
Anno_Global_end = 184;
Anno_Var_start = 185;
Anno_Var_end = 186;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 182;
Anno_end = 186;
PDGEdge_start = 1;
PDGEdge_end = 186;
hasFunction = [
70,70,71,71,71,72,67,68,69,70,71,72,71,71,71,71,67,67,67,67,
67,67,67,67,69,67,67,67,67,67,67,67,68,68,68,68,69,69,69,69,
70,70,70,70,70,70,71,71,71,71,71,71,71,71,71,71,71,71,71,71,
71,72,72,0,0,0,67,68,69,70,71,72,67,67,70,67,67,70,67,67,
70,67,67,70,71,0
];
hasSource = [
1,2,3,4,6,7,8,9,10,11,67,67,67,67,67,67,67,67,67,67,
67,67,67,67,67,67,68,68,68,68,68,69,69,69,69,69,69,70,70,70,
70,70,70,70,70,70,71,71,71,71,71,71,71,71,71,71,71,71,71,71,
71,71,71,71,71,71,71,71,71,72,72,72,72,14,14,14,14,14,14,14,
14,14,14,14,14,64,64,64,65,65,65,66,66,66,66,17,17,18,18,19,
23,24,25,26,27,28,29,30,32,33,34,36,37,38,40,41,41,42,42,1,
45,46,2,47,47,49,49,49,50,50,50,50,53,54,3,56,4,58,59,60,
62,6,20,21,31,35,39,43,44,55,57,7,8,9,10,11,51,73,67,67,
74,70,45,46,2,2,75,56,4,79,80,81,67,67,70,2,2,4,82,83,
84,65,66,70,71,51
];
hasDest = [
69,67,68,70,71,2,3,1,4,6,18,19,20,21,22,23,24,26,27,28,
29,30,31,32,7,17,33,34,35,36,8,37,25,38,39,40,9,42,43,1,
44,45,46,2,10,41,48,49,50,51,52,13,53,54,14,3,55,56,4,57,
58,5,15,59,60,61,16,11,47,62,63,6,12,3,55,56,4,57,58,5,
15,59,60,61,16,32,31,28,36,35,33,40,39,25,37,23,20,24,21,22,
26,26,38,27,30,29,30,31,7,34,35,8,38,39,9,45,43,46,44,44,
2,2,10,56,55,58,57,51,61,59,53,52,54,14,55,4,57,5,60,61,
63,12,23,24,32,36,40,45,46,56,58,2,3,1,4,6,49,23,73,74,
24,75,79,80,79,80,45,81,81,73,74,75,76,77,78,82,83,84,45,46,
56,86,86,86,85,85
];
hasParamIdx = array1d(Param, [
1,2,1,1,2,1,1,2,1,1,2,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false,false,true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx51" taint[51]=ORANGE;
constraint ::  "TaintOnNodeIdx65" taint[65]=ORANGE;
constraint ::  "TaintOnNodeIdx66" taint[66]=PURPLE;
constraint ::  "TaintOnNodeIdx70" taint[70]=XDLINKAGE_GET_EWMA;
