Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 6;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 7;
Inst_Other_end = 18;
Inst_start = 1;
Inst_end = 18;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 19;
VarNode_StaticFunction_end = 19;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 19;
VarNode_end = 19;
FunctionEntry_start = 20;
FunctionEntry_end = 22;
Param_FormalIn_start = 23;
Param_FormalIn_end = 25;
Param_FormalOut_start = 26;
Param_FormalOut_end = 28;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 23;
Param_end = 28;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 29;
Annotation_Global_end = 29;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 29;
Annotation_end = 29;
PDGNode_start = 1;
PDGNode_end = 29;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 22;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 22;
DataDepEdge_DefUse_start = 23;
DataDepEdge_DefUse_end = 36;
DataDepEdge_RAW_start = 37;
DataDepEdge_RAW_end = 37;
DataDepEdge_Ret_start = 38;
DataDepEdge_Ret_end = 39;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 23;
DataDepEdge_end = 39;
Parameter_In_start = 40;
Parameter_In_end = 41;
Parameter_Out_start = 42;
Parameter_Out_end = 43;
Parameter_Field_start = 44;
Parameter_Field_end = 45;
Parameter_start = 40;
Parameter_end = 45;
Anno_Global_start = 46;
Anno_Global_end = 47;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 46;
Anno_end = 47;
PDGEdge_start = 1;
PDGEdge_end = 47;
hasFunction = [
21,22,22,20,21,22,21,21,21,21,21,21,22,22,22,22,22,22,0,20,
21,22,22,22,22,22,22,22,0
];
hasSource = [
1,2,4,5,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,
22,22,19,19,19,19,7,1,8,9,10,12,13,14,15,2,11,4,5,22,
22,22,22,24,27,19,20
];
hasDest = [
20,21,1,2,4,7,1,8,9,10,11,12,5,14,15,16,17,18,2,3,
6,13,12,11,9,7,8,8,10,10,11,5,16,17,18,3,12,1,2,23,
24,26,27,25,28,29,29
];
hasParamIdx = array1d(Param, [
1,2,-1,1,2,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx19" taint[19]=PURPLE;
constraint ::  "TaintOnNodeIdx20" taint[20]=ORANGE;
