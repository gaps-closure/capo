Inst_FunCall_start = 1;
Inst_FunCall_end = 5;
Inst_Ret_start = 6;
Inst_Ret_end = 7;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 8;
Inst_Other_end = 26;
Inst_start = 1;
Inst_end = 26;
VarNode_StaticGlobal_start = 27;
VarNode_StaticGlobal_end = 27;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 27;
VarNode_end = 27;
FunctionEntry_start = 28;
FunctionEntry_end = 29;
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
Annotation_Var_start = 30;
Annotation_Var_end = 30;
Annotation_Global_start = 31;
Annotation_Global_end = 31;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 30;
Annotation_end = 31;
PDGNode_start = 1;
PDGNode_end = 31;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 28;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 28;
DataDepEdge_DefUse_start = 29;
DataDepEdge_DefUse_end = 45;
DataDepEdge_RAW_start = 46;
DataDepEdge_RAW_end = 47;
DataDepEdge_Ret_start = 48;
DataDepEdge_Ret_end = 48;
DataDepEdge_Alias_start = 49;
DataDepEdge_Alias_end = 53;
DataDepEdge_start = 29;
DataDepEdge_end = 53;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 54;
Anno_Global_end = 54;
Anno_Var_start = 55;
Anno_Var_end = 58;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 54;
Anno_end = 58;
PDGEdge_start = 1;
PDGEdge_end = 58;
hasFunction = [
28,28,29,29,29,28,29,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,0,28,29,29,0
];
hasSource = [
5,6,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,27,8,8,8,2,9,11,12,14,15,16,17,17,5,23,24,25,10,22,6,9,11,14,19,23,27,29,19,20,21
];
hasDest = [
28,5,8,1,2,9,10,11,12,13,14,6,15,16,17,18,3,19,20,21,4,5,22,23,24,25,26,7,12,14,11,10,9,10,13,13,6,18,19,23,22,22,24,25,26,11,23,5,2,9,9,16,5,31,30,30,30,30
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx19" taint[19]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx27" taint[27]=ORANGE_NOSHARE;
