Inst_FunCall_start = 1;
Inst_FunCall_end = 14;
Inst_Ret_start = 15;
Inst_Ret_end = 19;
Inst_Br_start = 20;
Inst_Br_end = 23;
Inst_Other_start = 24;
Inst_Other_end = 70;
Inst_start = 1;
Inst_end = 70;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 71;
VarNode_StaticFunction_end = 73;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 71;
VarNode_end = 73;
FunctionEntry_start = 74;
FunctionEntry_end = 78;
Param_FormalIn_start = 79;
Param_FormalIn_end = 83;
Param_FormalOut_start = 84;
Param_FormalOut_end = 88;
Param_ActualIn_start = 89;
Param_ActualIn_end = 90;
Param_ActualOut_start = 91;
Param_ActualOut_end = 92;
Param_start = 79;
Param_end = 92;
Annotation_Var_start = 93;
Annotation_Var_end = 93;
Annotation_Global_start = 94;
Annotation_Global_end = 94;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 93;
Annotation_end = 94;
PDGNode_start = 1;
PDGNode_end = 94;
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
77,77,77,77,78,74,74,74,77,77,77,77,78,78,74,75,76,77,78,77,
77,77,77,74,74,74,74,74,74,74,74,76,74,74,74,74,74,74,74,75,
75,75,75,76,76,76,76,77,77,77,77,77,77,77,77,77,77,77,77,77,
77,77,77,77,78,78,78,78,78,78,0,0,0,74,75,76,77,78,74,74,
78,78,78,74,74,78,78,78,74,74,74,74,77,0
];
hasSource = [
1,2,3,5,15,16,17,18,74,74,74,74,74,74,74,74,74,74,74,74,
74,74,74,74,75,75,75,75,75,76,76,76,76,76,76,77,77,77,77,77,
77,77,77,77,77,77,77,77,77,77,77,77,77,77,77,77,77,77,77,77,
77,78,78,78,78,78,78,78,78,21,21,21,21,21,21,21,21,21,21,21,
21,21,21,21,71,71,71,72,72,72,73,73,73,73,24,24,25,25,26,30,
31,32,33,34,35,36,37,39,40,41,43,44,45,47,48,48,49,49,50,50,
50,51,51,51,51,54,55,1,2,58,59,3,61,62,63,65,66,67,5,27,
28,38,42,46,56,57,60,15,16,17,18,52,79,74,74,80,58,59,3,3,
78,78,89,90,74,74,3,3,78,78,91,92,82,87,72,73,75,77,52
];
hasDest = [
75,76,74,77,3,1,2,5,24,25,26,27,28,29,30,31,33,34,35,36,
37,38,39,15,41,42,43,16,40,44,32,45,46,47,17,48,49,50,51,52,
53,20,54,55,21,1,56,2,57,58,59,3,60,61,4,22,62,63,64,23,
18,65,66,67,68,69,70,5,19,1,56,2,57,58,59,3,60,61,4,22,
62,63,64,23,39,38,35,43,42,40,47,46,32,44,30,27,31,28,29,33,
33,45,34,37,36,37,38,15,41,42,16,45,46,17,58,56,59,57,61,60,
52,64,62,54,53,55,21,56,57,3,3,60,4,63,64,68,69,70,19,30,
31,39,43,47,58,59,61,3,1,2,5,50,30,79,80,31,89,90,89,90,
81,82,79,80,84,85,91,92,86,87,58,59,83,88,94,94,94,93,93
];
hasParamIdx = array1d(Param, [
1,2,1,2,-1,1,2,1,2,-1,1,2,1,2
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,true,false,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx52" taint[52]=PURPLE;
constraint ::  "TaintOnNodeIdx72" taint[72]=ORANGE;
constraint ::  "TaintOnNodeIdx73" taint[73]=PURPLE;
constraint ::  "TaintOnNodeIdx75" taint[75]=XDLINKAGE_GET_A;
