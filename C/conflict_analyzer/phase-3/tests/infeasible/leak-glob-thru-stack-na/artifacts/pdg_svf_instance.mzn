Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 8;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 9;
Inst_Other_end = 19;
Inst_start = 1;
Inst_end = 19;
VarNode_StaticGlobal_start = 20;
VarNode_StaticGlobal_end = 20;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 20;
VarNode_end = 20;
FunctionEntry_start = 21;
FunctionEntry_end = 23;
Param_FormalIn_start = 24;
Param_FormalIn_end = 25;
Param_FormalOut_start = 26;
Param_FormalOut_end = 27;
Param_ActualIn_start = 28;
Param_ActualIn_end = 29;
Param_ActualOut_start = 30;
Param_ActualOut_end = 31;
Param_start = 24;
Param_end = 31;
Annotation_Var_start = 32;
Annotation_Var_end = 32;
Annotation_Global_start = 33;
Annotation_Global_end = 33;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 32;
Annotation_end = 33;
PDGNode_start = 1;
PDGNode_end = 33;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 23;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 23;
DataDepEdge_DefUse_start = 24;
DataDepEdge_DefUse_end = 30;
DataDepEdge_RAW_start = 0;
DataDepEdge_RAW_end = -1;
DataDepEdge_Ret_start = 31;
DataDepEdge_Ret_end = 32;
DataDepEdge_Alias_start = 33;
DataDepEdge_Alias_end = 33;
DataDepEdge_start = 24;
DataDepEdge_end = 33;
Parameter_In_start = 34;
Parameter_In_end = 38;
Parameter_Out_start = 39;
Parameter_Out_end = 41;
Parameter_Field_start = 42;
Parameter_Field_end = 45;
Parameter_start = 34;
Parameter_end = 45;
Anno_Global_start = 46;
Anno_Global_end = 47;
Anno_Var_start = 48;
Anno_Var_end = 51;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 46;
Anno_end = 51;
DataDepEdge_PointsTo_start = 52;
DataDepEdge_PointsTo_end = 56;
PDGEdge_start = 1;
PDGEdge_end = 56;
hasFunction = [
21,21,22,22,23,21,22,23,21,21,21,22,22,22,22,22,22,23,23,0,21,22,23,22,22,22,22,22,22,22,22,22,0
];
hasSource = [
2,5,6,7,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,23,23,23,23,20,9,9,10,12,13,18,6,7,15,9,2,22,28,29,2,22,30,24,26,28,30,20,21,22,15,16,17,9,10,30,12,15
];
hasDest = [
22,21,5,2,1,10,11,2,6,9,12,13,14,3,4,15,16,17,7,19,5,8,18,10,2,11,11,14,15,19,5,2,13,28,28,24,24,25,30,26,9,25,27,29,31,33,33,32,32,32,32,20,20,9,9,13
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParms = 1;
constraint :: "TaintOnNodeIdx15" taint[15]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx20" taint[20]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx21" taint[21]=BAR;