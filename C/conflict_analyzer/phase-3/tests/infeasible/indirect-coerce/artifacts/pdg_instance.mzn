Inst_FunCall_start = 1;
Inst_FunCall_end = 4;
Inst_Ret_start = 5;
Inst_Ret_end = 6;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 7;
Inst_Other_end = 17;
Inst_start = 1;
Inst_end = 17;
VarNode_StaticGlobal_start = 0;
VarNode_StaticGlobal_end = -1;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 18;
VarNode_StaticFunction_end = 18;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 18;
VarNode_end = 18;
FunctionEntry_start = 19;
FunctionEntry_end = 20;
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
Annotation_Var_start = 21;
Annotation_Var_end = 21;
Annotation_Global_start = 22;
Annotation_Global_end = 22;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 21;
Annotation_end = 22;
PDGNode_start = 1;
PDGNode_end = 22;
ControlDep_CallInv_start = 0;
ControlDep_CallInv_end = -1;
ControlDep_Indirect_CallInv_start = 1;
ControlDep_Indirect_CallInv_end = 1;
ControlDep_CallRet_start = 0;
ControlDep_CallRet_end = -1;
ControlDep_Entry_start = 2;
ControlDep_Entry_end = 18;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 18;
DataDepEdge_DefUse_start = 19;
DataDepEdge_DefUse_end = 28;
DataDepEdge_RAW_start = 29;
DataDepEdge_RAW_end = 30;
DataDepEdge_Ret_start = 0;
DataDepEdge_Ret_end = -1;
DataDepEdge_Alias_start = 31;
DataDepEdge_Alias_end = 31;
DataDepEdge_start = 19;
DataDepEdge_end = 31;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 32;
Anno_Global_end = 32;
Anno_Var_start = 33;
Anno_Var_end = 34;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 32;
Anno_end = 34;
PDGEdge_start = 1;
PDGEdge_end = 34;
hasFunction = [
19,20,20,20,19,20,19,19,19,19,20,20,20,20,20,20,20,0,19,20,19,0
];
hasSource = [
4,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,7,7,7,10,11,12,12,13,16,4,9,15,8,18,19,8
];
hasDest = [
19,7,1,8,9,10,5,11,12,13,14,2,15,3,16,4,17,6,10,9,8,5,14,16,15,17,4,17,10,16,7,22,21,21
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
false,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx8" taint[8]=ORANGE_2;
constraint :: "TaintOnNodeIdx18" taint[18]=ORANGE_1;
