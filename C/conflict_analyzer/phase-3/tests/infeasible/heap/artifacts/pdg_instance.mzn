Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 7;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 8;
Inst_Other_end = 20;
Inst_start = 1;
Inst_end = 20;
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
FunctionEntry_start = 21;
FunctionEntry_end = 22;
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
Annotation_Var_start = 23;
Annotation_Var_end = 23;
Annotation_Global_start = 24;
Annotation_Global_end = 24;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 23;
Annotation_end = 24;
PDGNode_start = 1;
PDGNode_end = 24;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
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
DataDepEdge_RAW_end = 38;
DataDepEdge_Ret_start = 39;
DataDepEdge_Ret_end = 39;
DataDepEdge_Alias_start = 40;
DataDepEdge_Alias_end = 45;
DataDepEdge_start = 23;
DataDepEdge_end = 45;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 46;
Anno_Global_end = 46;
Anno_Var_start = 47;
Anno_Var_end = 48;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 46;
Anno_end = 48;
PDGEdge_start = 1;
PDGEdge_end = 48;
hasFunction = [
21,21,22,22,22,21,22,21,21,21,21,21,22,22,22,22,22,22,22,22,21,22,21,0
];
hasSource = [
4,6,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,8,8,8,2,10,12,13,14,14,14,4,17,19,20,11,16,6,9,10,12,17,19,20,21,21,9
];
hasDest = [
21,4,8,1,9,2,10,11,12,6,13,14,15,3,4,16,17,18,19,20,5,7,12,11,9,10,11,6,15,19,17,16,16,18,20,5,12,17,4,8,2,10,4,4,19,24,23,23
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx9" taint[9]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx21" taint[21]=BAR;
