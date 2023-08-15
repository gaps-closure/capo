Inst_FunCall_start = 1;
Inst_FunCall_end = 10;
Inst_Ret_start = 11;
Inst_Ret_end = 14;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 15;
Inst_Other_end = 43;
Inst_start = 1;
Inst_end = 43;
VarNode_StaticGlobal_start = 44;
VarNode_StaticGlobal_end = 44;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 44;
VarNode_end = 44;
FunctionEntry_start = 45;
FunctionEntry_end = 48;
Param_FormalIn_start = 49;
Param_FormalIn_end = 54;
Param_FormalOut_start = 55;
Param_FormalOut_end = 60;
Param_ActualIn_start = 61;
Param_ActualIn_end = 66;
Param_ActualOut_start = 67;
Param_ActualOut_end = 72;
Param_start = 49;
Param_end = 72;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 73;
Annotation_Global_end = 73;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 73;
Annotation_end = 73;
PDGNode_start = 1;
PDGNode_end = 73;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 3;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 4;
ControlDep_CallRet_end = 6;
ControlDep_Entry_start = 7;
ControlDep_Entry_end = 49;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 49;
DataDepEdge_DefUse_start = 50;
DataDepEdge_DefUse_end = 79;
DataDepEdge_RAW_start = 80;
DataDepEdge_RAW_end = 85;
DataDepEdge_Ret_start = 86;
DataDepEdge_Ret_end = 88;
DataDepEdge_Alias_start = 89;
DataDepEdge_Alias_end = 90;
DataDepEdge_start = 50;
DataDepEdge_end = 90;
Parameter_In_start = 91;
Parameter_In_end = 110;
Parameter_Out_start = 111;
Parameter_Out_end = 122;
Parameter_Field_start = 123;
Parameter_Field_end = 134;
Parameter_start = 91;
Parameter_end = 134;
Anno_Global_start = 135;
Anno_Global_end = 137;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 135;
Anno_end = 137;
PDGEdge_start = 1;
PDGEdge_end = 137;
hasFunction = [
45,46,46,46,46,47,47,47,48,48,45,46,47,48,45,45,45,45,45,45,45,46,46,46,46,46,46,46,46,46,46,46,46,46,47,47,47,47,47,47,48,48,48,0,45,46,47,48,45,45,46,46,47,47,45,45,46,46,47,47,45,45,46,46,47,47,45,45,46,46,47,47,0
];
hasSource = [
5,8,9,11,12,13,45,45,45,45,45,45,45,45,45,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,47,47,47,47,47,47,47,47,47,47,48,48,48,48,48,48,44,44,15,15,15,17,18,19,20,22,22,23,23,24,24,24,26,28,29,31,33,34,35,35,36,36,38,40,41,43,16,25,27,30,37,39,11,12,13,28,40,49,50,50,44,45,46,34,5,51,47,40,8,53,9,61,62,63,64,65,66,45,20,55,46,5,47,8,9,67,69,71,72,50,55,51,57,53,59,61,67,63,69,65,71,44,45,46
];
hasDest = [
45,46,47,5,8,9,16,1,17,18,19,20,21,11,15,22,23,24,25,2,3,26,27,4,28,29,30,31,32,33,34,5,12,36,37,6,7,38,39,40,8,13,35,41,42,9,43,10,14,43,9,20,17,16,18,19,21,21,26,25,28,27,33,31,29,27,30,30,32,34,5,38,37,40,39,39,8,42,10,17,26,28,34,38,40,5,8,9,26,38,18,20,17,65,50,51,61,61,26,53,63,63,38,65,50,49,51,52,53,54,55,55,67,57,67,59,69,71,34,40,44,43,49,56,52,58,54,60,62,68,64,70,66,72,73,73,73
];
hasParamIdx = array1d(Param, [
-1,1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true,false,false
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx44" taint[44]=ORANGE_SHAREABLE;
constraint :: "TaintOnNodeIdx45" taint[45]=PURPLE_XD;
constraint :: "TaintOnNodeIdx46" taint[46]=ORANGE_XD;
