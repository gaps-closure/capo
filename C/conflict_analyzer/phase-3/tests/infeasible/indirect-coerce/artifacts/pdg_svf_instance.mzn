Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 7;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 8;
Inst_Other_end = 21;
Inst_start = 1;
Inst_end = 21;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 22;
VarNode_end = 21;
FunctionEntry_start = 22;
FunctionEntry_end = 23;
Param_FormalIn_start = 0;
Param_FormalIn_end = -1;
Param_FormalOut_start = 0;
Param_FormalOut_end = -1;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 24;
Param_end = 23;
Annotation_Var_start = 24;
Annotation_Var_end = 25;
Annotation_Global_start = 0;
Annotation_Global_end = -1;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 24;
Annotation_end = 25;
PDGNode_start = 1;
PDGNode_end = 25;
ControlDep_CallInv_start = 0;
ControlDep_CallInv_end = -1;
ControlDep_Indirect_CallInv_start = 1;
ControlDep_Indirect_CallInv_end = 1;
ControlDep_CallRet_start = 0;
ControlDep_CallRet_end = -1;
ControlDep_Entry_start = 2;
ControlDep_Entry_end = 22;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 22;
DataDepEdge_DefUse_start = 23;
DataDepEdge_DefUse_end = 34;
DataDepEdge_RAW_start = 35;
DataDepEdge_RAW_end = 36;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 37;
DataDepEdge_Alias_end = 38;
DataDepEdge_start = 23;
DataDepEdge_end = 38;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 39;
Parameter_end = 38;
Anno_Global_start = 0;
Anno_Global_end = -1;
Anno_Var_start = 39;
Anno_Var_end = 42;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 39;
Anno_end = 42;
DataDepEdge_PointsTo_start = 43;
DataDepEdge_PointsTo_end = 52;
PDGEdge_start = 1;
PDGEdge_end = 52;
hasFunction = [
22,23,23,23,23,22,23,22,22,22,22,23,23,23,23,23,23,23,23,23,23,22,23,22,23
];
hasSource = [
5,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,8,8,8,11,12,13,13,14,14,15,20,5,10,19,9,17,22,9,23,17,22,8,9,23,12,13,14,15,17,21
];
hasDest = [
22,8,1,9,10,11,6,13,14,15,16,2,17,18,3,19,4,20,5,21,7,12,11,10,9,6,16,18,17,20,19,21,5,21,11,20,8,13,24,24,25,25,22,8,8,23,12,13,14,15,13,22
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx9" taint[9]=ORANGE_2;
constraint :: "TaintOnNodeIdx17" taint[17]=ORANGE_1;