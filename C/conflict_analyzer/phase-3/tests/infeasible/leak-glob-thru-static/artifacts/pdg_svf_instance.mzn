Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 5;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 6;
Inst_Other_end = 17;
Inst_start = 1;
Inst_end = 17;
VarNode_StaticGlobal_start = 18;
VarNode_StaticGlobal_end = 18;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 19;
VarNode_StaticFunction_end = 19;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 18;
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
Param_start = 22;
Param_end = 21;
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
DataDepEdge_Alias_end = 32;
DataDepEdge_start = 20;
DataDepEdge_end = 32;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 33;
Parameter_end = 32;
Anno_Global_start = 33;
Anno_Global_end = 34;
Anno_Var_start = 35;
Anno_Var_end = 38;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 33;
Anno_end = 38;
DataDepEdge_PointsTo_start = 39;
DataDepEdge_PointsTo_end = 46;
PDGEdge_start = 1;
PDGEdge_end = 46;
hasFunction = [
21,21,21,20,21,21,21,21,21,21,21,21,21,21,21,21,21,0,0,20,21,21,0
];
hasSource = [
3,4,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,19,6,7,8,8,3,14,15,16,13,4,10,14,18,20,21,10,11,12,19,4,8,10,3,14,15,16
];
hasDest = [
20,3,4,6,7,8,9,1,10,11,12,2,3,13,14,15,16,17,5,4,9,10,14,13,13,15,16,17,14,3,7,3,23,23,22,22,22,22,18,19,19,7,19,19,18,18
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx10" taint[10]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx18" taint[18]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx20" taint[20]=BAR;