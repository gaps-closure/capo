Inst_FunCall_start = 1;
Inst_FunCall_end = 2;
Inst_Ret_start = 3;
Inst_Ret_end = 4;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 5;
Inst_Other_end = 8;
Inst_start = 1;
Inst_end = 8;
VarNode_StaticGlobal_start = 9;
VarNode_StaticGlobal_end = 9;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 9;
VarNode_end = 9;
FunctionEntry_start = 10;
FunctionEntry_end = 11;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 0;
Param_end = -1;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 12;
Annotation_Global_end = 12;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 12;
Annotation_end = 12;
PDGNode_start = 1;
PDGNode_end = 12;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 10;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 10;
DataDepEdge_DefUse_start = 11;
DataDepEdge_DefUse_end = 13;
DataDepEdge_RAW_start = 0;
DataDepEdge_RAW_end = -1;
DataDepEdge_Ret_start = 14;
DataDepEdge_Ret_end = 14;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 11;
DataDepEdge_end = 14;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 15;
Anno_Global_end = 16;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 15;
Anno_end = 16;
PDGEdge_start = 1;
PDGEdge_end = 16;
hasFunction = [
11,11,10,11,11,11,11,11,0,10,11,0
];
hasSource = [
2,3,10,11,11,11,11,11,11,11,5,6,2,3,9,10
];
hasDest = [
10,2,3,5,6,7,1,2,8,4,7,8,8,2,12,12
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx9" taint[9]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx10" taint[10]=BAR;
