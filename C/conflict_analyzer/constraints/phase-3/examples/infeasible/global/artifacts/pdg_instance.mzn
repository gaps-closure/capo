Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 5;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 6;
Inst_Other_end = 16;
Inst_start = 1;
Inst_end = 16;
VarNode_StaticGlobal_start = 17;
VarNode_StaticGlobal_end = 17;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 17;
VarNode_end = 17;
FunctionEntry_start = 18;
FunctionEntry_end = 19;
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
Annotation_Var_start = 20;
Annotation_Var_end = 20;
Annotation_Global_start = 21;
Annotation_Global_end = 21;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 20;
Annotation_end = 21;
PDGNode_start = 1;
PDGNode_end = 21;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 18;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 18;
DataDepEdge_DefUse_start = 19;
DataDepEdge_DefUse_end = 27;
DataDepEdge_RAW_start = 28;
DataDepEdge_RAW_end = 28;
DataDepEdge_Ret_start = 29;
DataDepEdge_Ret_end = 29;
DataDepEdge_Alias_start = 30;
DataDepEdge_Alias_end = 31;
DataDepEdge_start = 19;
DataDepEdge_end = 31;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 32;
Anno_Global_end = 33;
Anno_Var_start = 34;
Anno_Var_end = 35;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 32;
Anno_end = 35;
PDGEdge_start = 1;
PDGEdge_end = 35;
hasFunction = [
19,19,19,18,19,19,19,19,19,19,19,19,19,19,19,19,0,18,19,19,0
];
hasSource = [
3,4,18,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,6,7,7,8,8,3,13,14,15,12,4,10,13,17,18,19,10
];
hasDest = [
18,3,4,6,7,8,9,1,10,11,2,3,12,13,14,15,16,5,9,11,10,13,12,12,14,15,16,13,3,7,3,21,21,20,20
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx10" taint[10]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx17" taint[17]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx18" taint[18]=BAR;
