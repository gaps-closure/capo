Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 5;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 6;
Inst_Other_end = 13;
Inst_start = 1;
Inst_end = 13;
VarNode_StaticGlobal_start = 14;
VarNode_StaticGlobal_end = 15;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 14;
VarNode_end = 15;
FunctionEntry_start = 16;
FunctionEntry_end = 17;
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
Annotation_Var_start = 18;
Annotation_Var_end = 18;
Annotation_Global_start = 19;
Annotation_Global_end = 19;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 18;
Annotation_end = 19;
PDGNode_start = 1;
PDGNode_end = 19;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 15;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 15;
DataDepEdge_DefUse_start = 16;
DataDepEdge_DefUse_end = 20;
DataDepEdge_RAW_start = 0;
DataDepEdge_RAW_end = -1;
DataDepEdge_Ret_start = 21;
DataDepEdge_Ret_end = 21;
DataDepEdge_Alias_start = 22;
DataDepEdge_Alias_end = 22;
DataDepEdge_start = 16;
DataDepEdge_end = 22;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 23;
Anno_Global_end = 24;
Anno_Var_start = 25;
Anno_Var_end = 28;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 23;
Anno_end = 28;
PDGEdge_start = 1;
PDGEdge_end = 28;
hasFunction = [
17,17,17,16,17,17,17,17,17,17,17,17,17,0,0,16,17,17,0
];
hasSource = [
3,4,16,17,17,17,17,17,17,17,17,17,17,17,17,15,6,7,8,3,4,10,14,16,17,10,11,12
];
hasDest = [
16,3,4,6,7,8,9,1,10,11,12,2,3,13,5,4,9,10,13,13,3,7,19,19,18,18,18,18
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx10" taint[10]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx14" taint[14]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx16" taint[16]=BAR;
