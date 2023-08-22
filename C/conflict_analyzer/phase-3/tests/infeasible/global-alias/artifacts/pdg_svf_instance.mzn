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
VarNode_StaticGlobal_end = 20;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 19;
VarNode_end = 20;
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
Param_start = 23;
Param_end = 22;
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
ControlDep_Entry_end = 20;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 20;
DataDepEdge_DefUse_start = 21;
DataDepEdge_DefUse_end = 30;
DataDepEdge_RAW_start = 31;
DataDepEdge_RAW_end = 31;
DataDepEdge_Ret_start = 32;
DataDepEdge_Ret_end = 32;
DataDepEdge_Alias_start = 33;
DataDepEdge_Alias_end = 34;
DataDepEdge_start = 21;
DataDepEdge_end = 34;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 35;
Parameter_end = 34;
Anno_Global_start = 35;
Anno_Global_end = 36;
Anno_Var_start = 37;
Anno_Var_end = 40;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 35;
Anno_end = 40;
DataDepEdge_PointsTo_start = 41;
DataDepEdge_PointsTo_end = 46;
PDGEdge_start = 1;
PDGEdge_end = 46;
hasFunction = [
22,22,22,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,0,0,21,22,22,0
];
hasSource = [
3,4,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,20,6,7,7,8,8,3,15,16,17,14,4,10,15,19,21,22,10,11,12,4,10,3,15,16,17
];
hasDest = [
21,3,4,6,7,8,9,1,10,11,12,13,2,3,14,15,16,17,18,5,4,9,13,10,15,14,14,16,17,18,15,3,7,3,24,24,23,23,23,23,20,7,20,20,19,19
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx10" taint[10]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx19" taint[19]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx21" taint[21]=BAR;