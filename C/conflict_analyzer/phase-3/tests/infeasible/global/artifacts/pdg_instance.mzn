Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 5;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 6;
Inst_Other_end = 18;
Inst_start = 1;
Inst_end = 18;
VarNode_StaticGlobal_start = 19;
VarNode_StaticGlobal_end = 19;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 19;
VarNode_end = 19;
FunctionEntry_start = 20;
FunctionEntry_end = 21;
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
Annotation_Var_start = 22;
Annotation_Var_end = 22;
Annotation_Global_start = 23;
Annotation_Global_end = 23;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 22;
Annotation_end = 23;
PDGNode_start = 1;
PDGNode_end = 23;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 20;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 20;
DataDepEdge_DefUse_start = 21;
DataDepEdge_DefUse_end = 29;
DataDepEdge_RAW_start = 30;
DataDepEdge_RAW_end = 30;
DataDepEdge_Ret_start = 31;
DataDepEdge_Ret_end = 31;
DataDepEdge_Alias_start = 32;
DataDepEdge_Alias_end = 33;
DataDepEdge_start = 21;
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
Anno_Global_end = 35;
Anno_Var_start = 36;
Anno_Var_end = 39;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 34;
Anno_end = 39;
PDGEdge_start = 1;
PDGEdge_end = 39;
hasFunction = [
21,21,21,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,0,20,21,21,0
];
hasSource = [
3,4,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,6,7,7,8,8,3,15,16,17,14,4,10,15,19,20,21,10,11,12
];
hasDest = [
20,3,4,6,7,8,9,1,10,11,12,13,2,3,14,15,16,17,18,5,9,13,10,15,14,14,16,17,18,15,3,7,3,23,23,22,22,22,22
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx10" taint[10]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx19" taint[19]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx20" taint[20]=BAR;
