Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 6;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 7;
Inst_Other_end = 19;
Inst_start = 1;
Inst_end = 19;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 20;
VarNode_StaticFunction_end = 21;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 20;
VarNode_end = 21;
FunctionEntry_start = 22;
FunctionEntry_end = 24;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 25;
Param_end = 24;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 25;
Annotation_Global_end = 25;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 25;
Annotation_end = 25;
PDGNode_start = 1;
PDGNode_end = 25;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 23;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 23;
DataDepEdge_DefUse_start = 24;
DataDepEdge_DefUse_end = 41;
DataDepEdge_RAW_start = 42;
DataDepEdge_RAW_end = 42;
DataDepEdge_Ret_start = 43;
DataDepEdge_Ret_end = 44;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 24;
DataDepEdge_end = 44;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 45;
Parameter_end = -1;
Anno_Global_start = 45;
Anno_Global_end = 46;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 0;
Anno_end = 46;
PDGEdge_start = 1;
PDGEdge_end = 46;
hasFunction = [
23,24,24,22,23,24,22,22,22,23,23,23,23,23,24,24,24,24,24,0,
0,22,23,24,0
];
hasSource = [
1,2,4,5,22,22,22,22,23,23,23,23,23,23,23,24,24,24,24,24,
24,24,24,20,20,21,21,21,7,7,8,10,11,1,13,14,15,16,16,2,
19,18,4,5,20,21
];
hasDest = [
22,23,1,2,7,8,9,4,10,11,12,1,13,14,5,16,17,2,18,19,
3,6,15,9,7,13,12,10,4,8,9,11,12,14,14,5,17,19,18,18,
3,19,1,2,25,25
];
hasParamIdx = array1d(Param, [
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 false,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx20" taint[20]=PURPLE;
constraint ::  "TaintOnNodeIdx21" taint[21]=ORANGE;
