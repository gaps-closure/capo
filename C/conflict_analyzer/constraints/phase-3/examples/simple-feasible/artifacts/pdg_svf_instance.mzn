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
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 15;
VarNode_end = 15;
FunctionEntry_start = 16;
FunctionEntry_end = 17;
Param_FormalIn_start = 18;
Param_FormalIn_end = 18;
Param_FormalOut_start = 19;
Param_FormalOut_end = 19;
Param_ActualIn_start = 20;
Param_ActualIn_end = 20;
Param_ActualOut_start = 21;
Param_ActualOut_end = 21;
Param_start = 18;
Param_end = 21;
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 22;
Annotation_Global_end = 22;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 22;
Annotation_end = 22;
PDGNode_start = 1;
PDGNode_end = 22;
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
DataDepEdge_RAW_end = 27;
DataDepEdge_Ret_start = 28;
DataDepEdge_Ret_end = 28;
DataDepEdge_Alias_start = 0;
DataDepEdge_Alias_end = -1;
DataDepEdge_start = 17;
DataDepEdge_end = 28;
Parameter_In_start = 29;
Parameter_In_end = 33;
Parameter_Out_start = 34;
Parameter_Out_end = 36;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 29;
Parameter_end = 36;
Anno_Global_start = 37;
Anno_Global_end = 39;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 37;
Anno_end = 39;
DataDepEdge_PointsTo_start = 40;
DataDepEdge_PointsTo_end = 44;
PDGEdge_start = 1;
PDGEdge_end = 44;
hasFunction = [
16,17,17,16,17,16,16,16,16,16,17,17,17,17,0,16,17,16,16,16,16,0
];
hasSource = [
2,4,16,16,16,16,16,16,16,17,17,17,17,17,17,17,15,15,6,6,6,8,9,11,13,14,7,4,18,16,13,2,20,16,2,21,15,16,17,15,16,17,6,11
];
hasDest = [
16,2,6,7,1,8,9,10,4,11,12,13,2,14,3,5,14,13,10,8,7,9,10,12,2,3,8,2,8,18,20,20,18,19,21,13,22,22,22,15,16,17,6,11
];
hasParamIdx = array1d(Param, [
1,1,1,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,true
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx15" taint[15]=ORANGE_SHAREABLE;
constraint :: "TaintOnNodeIdx16" taint[16]=PURPLE_XD;
constraint :: "TaintOnNodeIdx17" taint[17]=ORANGE_XD;