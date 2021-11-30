Inst_FunCall_start = 1;
Inst_FunCall_end = 2;
Inst_Ret_start = 3;
Inst_Ret_end = 4;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 5;
Inst_Other_end = 22;
Inst_start = 1;
Inst_end = 22;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 23;
VarNode_StaticFunction_end = 24;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 23;
VarNode_end = 24;
FunctionEntry_start = 25;
FunctionEntry_end = 26;
Param_FormalIn_start = 27;
Param_FormalIn_end = 29;
Param_FormalOut_start = 30;
Param_FormalOut_end = 32;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 27;
Param_end = 32;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 33;
Annotation_Global_end = 33;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 33;
Annotation_end = 33;
PDGNode_start = 1;
PDGNode_end = 33;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 24;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 24;
DataDepEdge_DefUse_start = 25;
DataDepEdge_DefUse_end = 44;
DataDepEdge_RAW_start = 45;
DataDepEdge_RAW_end = 45;
DataDepEdge_Ret_start = 46;
DataDepEdge_Ret_end = 46;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 25;
DataDepEdge_end = 46;
Parameter_In_start = 47;
Parameter_In_end = 48;
Parameter_Out_start = 49;
Parameter_Out_end = 50;
Parameter_Field_start = 51;
Parameter_Field_end = 52;
Parameter_start = 47;
Parameter_end = 52;
Anno_Global_start = 53;
Anno_Global_end = 54;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 53;
Anno_end = 54;
PDGEdge_start = 1;
PDGEdge_end = 54;
hasFunction = [
26,26,25,26,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,
26,26,0,0,25,26,26,26,26,26,26,26,0
];
hasSource = [
1,3,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,
26,26,26,26,23,23,23,24,24,24,5,5,6,7,8,10,11,13,14,16,
17,18,19,1,9,3,26,26,26,26,28,31,23,24
];
hasDest = [
25,1,5,6,7,8,9,10,11,12,13,14,15,16,3,18,19,20,21,22,
1,2,4,17,12,10,6,15,13,7,16,9,8,8,9,11,12,14,15,3,
20,21,22,2,16,1,27,28,30,31,29,32,33,33
];
hasParamIdx = array1d(Param, [
1,2,-1,1,2,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx23" taint[23]=PURPLE;
constraint ::  "TaintOnNodeIdx24" taint[24]=ORANGE;
