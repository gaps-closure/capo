Inst_FunCall_start = 1;
Inst_FunCall_end = 3;
Inst_Ret_start = 4;
Inst_Ret_end = 5;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 6;
Inst_Other_end = 14;
Inst_start = 1;
Inst_end = 14;
VarNode_StaticGlobal_start = 15;
VarNode_StaticGlobal_end = 15;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 16;
VarNode_StaticFunction_end = 16;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 15;
VarNode_end = 16;
FunctionEntry_start = 17;
FunctionEntry_end = 18;
Param_FormalIn_start = 19;
Param_FormalIn_end = 20;
Param_FormalOut_start = 21;
Param_FormalOut_end = 22;
Param_ActualIn_start = 23;
Param_ActualIn_end = 24;
Param_ActualOut_start = 25;
Param_ActualOut_end = 26;
Param_start = 19;
Param_end = 26;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 27;
Annotation_Global_end = 27;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 27;
Annotation_end = 27;
PDGNode_start = 1;
PDGNode_end = 27;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 16;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 16;
DataDepEdge_DefUse_start = 17;
DataDepEdge_DefUse_end = 26;
DataDepEdge_RAW_start = 27;
DataDepEdge_RAW_end = 28;
DataDepEdge_Ret_start = 29;
DataDepEdge_Ret_end = 29;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 17;
DataDepEdge_end = 29;
Parameter_In_start = 30;
Parameter_In_end = 36;
Parameter_Out_start = 37;
Parameter_Out_end = 39;
Parameter_Field_start = 40;
Parameter_Field_end = 43;
Parameter_start = 30;
Parameter_end = 43;
Anno_Global_start = 44;
Anno_Global_end = 45;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 44;
Anno_end = 45;
DataDepEdge_PointsTo_start = 46;
DataDepEdge_PointsTo_end = 50;
PDGEdge_start = 1;
PDGEdge_end = 50;
hasFunction = [
17,17,18,17,18,17,17,17,17,17,18,18,18,18,0,0,17,18,17,17,17,17,17,17,17,17,0
];
hasSource = [
3,4,17,17,17,17,17,17,17,17,18,18,18,18,18,18,16,15,15,6,6,8,9,10,11,14,7,13,4,19,17,20,14,3,23,24,17,3,25,19,21,23,25,17,18,15,25,6,8,14
];
hasDest = [
17,3,6,7,1,8,9,10,2,4,11,12,13,14,3,5,13,14,13,8,7,9,2,2,12,3,8,14,3,8,19,9,23,23,19,20,21,25,14,20,22,24,26,27,27,16,16,16,16,16
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx17" taint[17]=FOO;
constraint :: "TaintOnNodeIdx18" taint[18]=MAIN;