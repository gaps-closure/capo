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
Param_FormalIn_start = 25;
Param_FormalIn_end = 27;
Param_FormalOut_start = 28;
Param_FormalOut_end = 30;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 25;
Param_end = 30;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 31;
Annotation_Global_end = 31;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 31;
Annotation_end = 31;
PDGNode_start = 1;
PDGNode_end = 31;
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
DataDepEdge_DefUse_end = 39;
DataDepEdge_RAW_start = 40;
DataDepEdge_RAW_end = 40;
DataDepEdge_Ret_start = 41;
DataDepEdge_Ret_end = 42;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 24;
DataDepEdge_end = 42;
Parameter_In_start = 43;
Parameter_In_end = 44;
Parameter_Out_start = 45;
Parameter_Out_end = 46;
Parameter_Field_start = 47;
Parameter_Field_end = 48;
Parameter_start = 43;
Parameter_end = 48;
Anno_Global_start = 49;
Anno_Global_end = 51;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 49;
Anno_end = 51;
PDGEdge_start = 1;
PDGEdge_end = 51;
hasFunction = [
23,24,24,22,23,24,22,23,23,23,23,23,23,24,24,24,24,24,24,0,
0,22,23,24,24,24,24,24,24,24,0
];
hasSource = [
1,2,4,5,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,
24,24,24,20,21,21,21,21,7,8,1,9,10,11,13,14,15,16,2,12,
4,5,24,24,24,24,26,29,20,21,22
];
hasDest = [
22,23,1,2,7,4,8,1,9,10,11,12,13,5,15,16,17,18,19,2,
3,6,14,7,13,12,10,8,4,9,9,11,11,12,5,17,18,19,3,13,
1,2,25,26,28,29,27,30,31,31,31
];
hasParamIdx = array1d(Param, [
1,2,-1,1,2,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
 true,false,false
]);
MaxFuncParms = 3;
constraint ::  "TaintOnNodeIdx20" taint[20]=ORANGE;
constraint ::  "TaintOnNodeIdx21" taint[21]=PURPLE;
constraint ::  "TaintOnNodeIdx22" taint[22]=XD_FOO;
