Inst_FunCall_start = 1;
Inst_FunCall_end = 2;
Inst_Ret_start = 3;
Inst_Ret_end = 4;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 5;
Inst_Other_end = 9;
Inst_start = 1;
Inst_end = 9;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 10;
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
Param_start = 12;
Param_end = 11;
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
ControlDep_CallInv_start = 0;
ControlDep_CallInv_end = -1;
ControlDep_Indirect_CallInv_start = 1;
ControlDep_Indirect_CallInv_end = 1;
ControlDep_CallRet_start = 0;
ControlDep_CallRet_end = -1;
ControlDep_Entry_start = 2;
ControlDep_Entry_end = 10;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 10;
DataDepEdge_DefUse_start = 11;
DataDepEdge_DefUse_end = 15;
DataDepEdge_RAW_start = 16;
DataDepEdge_RAW_end = 16;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 11;
DataDepEdge_end = 16;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 17;
Parameter_end = 16;
Anno_Global_start = 17;
Anno_Global_end = 17;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 17;
Anno_end = 17;
DataDepEdge_PointsTo_start = 18;
DataDepEdge_PointsTo_end = 19;
PDGEdge_start = 1;
PDGEdge_end = 19;
hasFunction = [
11,11,10,11,11,11,11,11,11,10,11,0
];
hasSource = [
2,10,11,11,11,11,11,11,11,11,5,6,6,9,2,8,10,6,9
];
hasDest = [
10,3,5,6,7,1,8,9,2,4,7,9,8,2,4,9,12,10,10
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx10" taint[10]=FOO;