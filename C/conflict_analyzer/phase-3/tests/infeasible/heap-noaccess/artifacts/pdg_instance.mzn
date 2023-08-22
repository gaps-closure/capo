Inst_FunCall_start = 1;
Inst_FunCall_end = 4;
Inst_Ret_start = 5;
Inst_Ret_end = 6;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 7;
Inst_Other_end = 17;
Inst_start = 1;
Inst_end = 17;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 0;
VarNode_end = -1;
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
ControlDep_Entry_end = 19;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 19;
DataDepEdge_DefUse_start = 20;
DataDepEdge_DefUse_end = 28;
DataDepEdge_RAW_start = 29;
DataDepEdge_RAW_end = 29;
DataDepEdge_Ret_start = 30;
DataDepEdge_Ret_end = 30;
DataDepEdge_Alias_start = 31;
DataDepEdge_Alias_end = 33;
DataDepEdge_start = 20;
DataDepEdge_end = 33;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 34;
Anno_Global_end = 34;
Anno_Var_start = 35;
Anno_Var_end = 38;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 34;
Anno_end = 38;
PDGEdge_start = 1;
PDGEdge_end = 38;
hasFunction = [
18,18,19,19,18,19,18,18,18,18,18,18,18,19,19,19,19,18,19,18,0
];
hasSource = [
4,5,18,18,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,7,7,7,2,11,13,14,15,4,12,5,8,11,13,18,18,8,9,10
];
hasDest = [
18,4,7,1,8,9,10,2,11,12,13,5,14,15,16,3,4,17,6,13,12,8,11,12,5,16,17,17,13,4,7,2,11,21,20,20,20,20
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx8" taint[8]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx18" taint[18]=BAR;
