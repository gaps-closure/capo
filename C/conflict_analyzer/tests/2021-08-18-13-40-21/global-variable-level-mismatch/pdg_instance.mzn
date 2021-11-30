Inst_FunCall_start = 1;
Inst_FunCall_end = 2;
Inst_Ret_start = 3;
Inst_Ret_end = 4;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 5;
Inst_Other_end = 19;
Inst_start = 1;
Inst_end = 19;
VarNode_StaticGlobal_start = 20;
VarNode_StaticGlobal_end = 21;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 20;
VarNode_end = 21;
FunctionEntry_start = 22;
FunctionEntry_end = 23;
Param_FormalIn_start = 24;
Param_FormalIn_end = 26;
Param_FormalOut_start = 27;
Param_FormalOut_end = 29;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 24;
Param_end = 29;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 30;
Annotation_Global_end = 30;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 30;
Annotation_end = 30;
PDGNode_start = 1;
PDGNode_end = 30;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 21;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 21;
DataDepEdge_DefUse_start = 22;
DataDepEdge_DefUse_end = 38;
DataDepEdge_RAW_start = 39;
DataDepEdge_RAW_end = 40;
DataDepEdge_Ret_start = 41;
DataDepEdge_Ret_end = 41;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 22;
DataDepEdge_end = 41;
Parameter_In_start = 42;
Parameter_In_end = 43;
Parameter_Out_start = 44;
Parameter_Out_end = 45;
Parameter_Field_start = 46;
Parameter_Field_end = 47;
Parameter_start = 42;
Parameter_end = 47;
Anno_Global_start = 48;
Anno_Global_end = 49;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 48;
Anno_end = 49;
PDGEdge_start = 1;
PDGEdge_end = 49;
hasFunction = [
23,23,22,23,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,0,
0,22,23,23,23,23,23,23,23,0
];
hasSource = [
1,3,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,
23,20,20,20,21,21,21,5,6,8,9,11,12,13,14,15,16,1,7,10,
3,23,23,23,23,25,28,20,21
];
hasDest = [
22,1,5,6,7,8,9,10,11,12,13,3,15,16,17,18,19,1,2,4,
14,11,7,5,12,10,8,6,7,9,10,13,13,3,17,18,19,2,11,12,
1,24,25,27,28,26,29,30,30
];
hasParamIdx = array1d(Param, [
1,2,-1,1,2,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx20" taint[20]=ORANGE;
constraint ::  "TaintOnNodeIdx21" taint[21]=PURPLE;
