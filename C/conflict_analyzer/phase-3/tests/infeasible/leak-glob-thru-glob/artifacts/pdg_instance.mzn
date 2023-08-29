Inst_FunCall_start = 1;
Inst_FunCall_end = 2;
Inst_Ret_start = 3;
Inst_Ret_end = 4;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 5;
Inst_Other_end = 12;
Inst_start = 1;
Inst_end = 12;
VarNode_StaticGlobal_start = 13;
VarNode_StaticGlobal_end = 14;
VarNode_StaticModule_start = 0;
VarNode_StaticModule_end = -1;
VarNode_StaticFunction_start = 0;
VarNode_StaticFunction_end = -1;
VarNode_StaticOther_start = 0;
VarNode_StaticOther_end = -1;
VarNode_start = 13;
VarNode_end = 14;
FunctionEntry_start = 15;
FunctionEntry_end = 16;
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
Annotation_Var_start = 0;
Annotation_Var_end = -1;
Annotation_Global_start = 17;
Annotation_Global_end = 17;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 17;
Annotation_end = 17;
PDGNode_start = 1;
PDGNode_end = 17;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 1;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 2;
ControlDep_CallRet_end = 2;
ControlDep_Entry_start = 3;
ControlDep_Entry_end = 14;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 14;
DataDepEdge_DefUse_start = 15;
DataDepEdge_DefUse_end = 22;
DataDepEdge_RAW_start = 23;
DataDepEdge_RAW_end = 23;
DataDepEdge_Ret_start = 24;
DataDepEdge_Ret_end = 24;
DataDepEdge_Alias_start = 25;
DataDepEdge_Alias_end = 25;
DataDepEdge_start = 15;
DataDepEdge_end = 25;
Parameter_In_start = 0;
Parameter_In_end = -1;
Parameter_Out_start = 0;
Parameter_Out_end = -1;
Parameter_Field_start = 0;
Parameter_Field_end = -1;
Parameter_start = 0;
Parameter_end = -1;
Anno_Global_start = 26;
Anno_Global_end = 27;
Anno_Var_start = 0;
Anno_Var_end = -1;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 26;
Anno_end = 27;
PDGEdge_start = 1;
PDGEdge_end = 27;
hasFunction = [
16,16,15,16,16,16,16,16,16,16,16,16,0,0,15,16,0
];
hasSource = [
2,3,15,16,16,16,16,16,16,16,16,16,16,16,14,5,6,6,2,9,10,11,8,3,9,13,15
];
hasDest = [
15,2,3,5,6,7,1,2,8,9,10,11,12,4,3,7,9,8,8,10,11,12,9,2,2,17,17
];
hasParamIdx = array1d(Param, [

]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false
]);
MaxFuncParams = 0;
constraint :: "TaintOnNodeIdx13" taint[13]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx15" taint[15]=BAR;
