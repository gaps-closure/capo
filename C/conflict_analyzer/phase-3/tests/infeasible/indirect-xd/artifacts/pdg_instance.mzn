Inst_FunCall_start = 1;
Inst_FunCall_end = 7;
Inst_Ret_start = 8;
Inst_Ret_end = 9;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 10;
Inst_Other_end = 30;
Inst_start = 1;
Inst_end = 30;
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
FunctionEntry_start = 31;
FunctionEntry_end = 32;
Param_FormalIn_start = 33;
Param_FormalIn_end = 33;
Param_FormalOut_start = 34;
Param_FormalOut_end = 34;
Param_ActualIn_start = 0;
Param_ActualIn_end = -1;
Param_ActualOut_start = 0;
Param_ActualOut_end = -1;
Param_start = 33;
Param_end = 34;
Annotation_Var_start = 35;
Annotation_Var_end = 36;
Annotation_Global_start = 0;
Annotation_Global_end = -1;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 35;
Annotation_end = 36;
PDGNode_start = 1;
PDGNode_end = 36;
ControlDep_CallInv_start = 0;
ControlDep_CallInv_end = -1;
ControlDep_Indirect_CallInv_start = 1;
ControlDep_Indirect_CallInv_end = 1;
ControlDep_CallRet_start = 0;
ControlDep_CallRet_end = -1;
ControlDep_Entry_start = 2;
ControlDep_Entry_end = 31;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 31;
DataDepEdge_DefUse_start = 32;
DataDepEdge_DefUse_end = 50;
DataDepEdge_RAW_start = 51;
DataDepEdge_RAW_end = 54;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 55;
DataDepEdge_Alias_end = 56;
DataDepEdge_start = 32;
DataDepEdge_end = 56;
Parameter_In_start = 57;
Parameter_In_end = 58;
Parameter_Out_start = 59;
Parameter_Out_end = 59;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 57;
Parameter_end = 59;
Anno_Global_start = 0;
Anno_Global_end = -1;
Anno_Var_start = 60;
Anno_Var_end = 63;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 60;
Anno_end = 63;
PDGEdge_start = 1;
PDGEdge_end = 63;
hasFunction = [
31,31,32,32,32,32,32,31,32,31,31,31,31,31,31,31,31,32,32,32,32,32,32,32,32,32,32,32,32,32,31,32,31,31,31,32
];
hasSource = [
7,31,31,31,31,31,31,31,31,31,31,31,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,10,10,11,11,11,15,16,17,18,19,19,20,20,21,21,22,28,29,7,12,14,26,27,13,24,33,31,31,31,13,32,24
];
hasDest = [
31,10,11,12,1,2,13,14,15,16,17,8,19,20,21,22,23,3,24,25,4,26,5,27,6,28,29,7,30,9,18,16,12,15,14,13,17,17,8,23,25,24,29,26,28,27,30,7,7,30,16,15,29,28,11,19,16,33,34,35,35,36,36
];
hasParamIdx = array1d(Param, [
1,1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx13" taint[13]=PURPLE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE;
