Inst_FunCall_start = 1;
Inst_FunCall_end = 8;
Inst_Ret_start = 9;
Inst_Ret_end = 11;
Inst_Br_start = 0;
Inst_Br_end = -1;
Inst_Other_start = 12;
Inst_Other_end = 38;
Inst_start = 1;
Inst_end = 38;
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
FunctionEntry_start = 39;
FunctionEntry_end = 41;
Param_FormalIn_start = 42;
Param_FormalIn_end = 45;
Param_FormalOut_start = 46;
Param_FormalOut_end = 49;
Param_ActualIn_start = 50;
Param_ActualIn_end = 53;
Param_ActualOut_start = 54;
Param_ActualOut_end = 57;
Param_start = 42;
Param_end = 57;
Annotation_Var_start = 58;
Annotation_Var_end = 60;
Annotation_Global_start = 61;
Annotation_Global_end = 61;
Annotation_Other_start = 0;
Annotation_Other_end = -1;
Annotation_start = 58;
Annotation_end = 61;
PDGNode_start = 1;
PDGNode_end = 61;
ControlDep_CallInv_start = 1;
ControlDep_CallInv_end = 2;
ControlDep_Indirect_CallInv_start = 0;
ControlDep_Indirect_CallInv_end = -1;
ControlDep_CallRet_start = 3;
ControlDep_CallRet_end = 4;
ControlDep_Entry_start = 5;
ControlDep_Entry_end = 42;
ControlDep_Br_start = 0;
ControlDep_Br_end = -1;
ControlDep_Other_start = 0;
ControlDep_Other_end = -1;
ControlDep_start = 1;
ControlDep_end = 42;
DataDepEdge_DefUse_start = 43;
DataDepEdge_DefUse_end = 61;
DataDepEdge_RAW_start = 62;
DataDepEdge_RAW_end = 64;
DataDepEdge_Ret_start = 65;
DataDepEdge_Ret_end = 66;
DataDepEdge_Alias_start = 67;
DataDepEdge_Alias_end = 71;
DataDepEdge_start = 43;
DataDepEdge_end = 71;
Parameter_In_start = 72;
Parameter_In_end = 83;
Parameter_Out_start = 84;
Parameter_Out_end = 89;
Parameter_Field_start = 90;
Parameter_Field_end = 97;
Parameter_start = 72;
Parameter_end = 97;
Anno_Global_start = 98;
Anno_Global_end = 98;
Anno_Var_start = 99;
Anno_Var_end = 110;
Anno_Other_start = 0;
Anno_Other_end = -1;
Anno_start = 98;
Anno_end = 110;
PDGEdge_start = 1;
PDGEdge_end = 110;
hasFunction = [
39,39,39,40,40,41,41,41,39,40,41,39,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,39,40,41,39,39,40,40,39,39,40,40,40,40,39,39,40,40,39,39,39,40,41,0
];
hasSource = [
3,8,9,10,39,39,39,39,39,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,12,12,13,13,13,18,20,21,21,22,22,28,29,31,32,32,32,37,38,14,19,23,9,10,15,20,24,34,37,42,39,20,3,40,44,38,8,50,51,52,53,39,3,40,8,54,56,42,46,44,48,50,54,52,56,39,39,15,16,17,40,24,25,26,41,34,35,36
];
hasDest = [
40,39,8,3,12,13,14,1,2,15,16,17,18,19,20,3,9,22,23,4,5,24,25,26,27,28,29,30,10,21,31,32,33,6,34,35,36,37,7,38,8,11,18,14,20,19,15,19,3,28,23,27,24,29,30,33,38,37,34,7,8,18,20,28,8,3,13,18,22,32,32,18,42,50,50,44,28,52,52,44,45,42,43,46,54,48,56,20,38,43,47,45,49,51,55,53,57,61,58,58,58,58,59,59,59,59,60,60,60,60
];
hasParamIdx = array1d(Param, [
1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1
]);
userAnnotatedFunction = array1d(FunctionEntry, [
true,false,false
]);
MaxFuncParams = 1;
constraint :: "TaintOnNodeIdx15" taint[15]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx24" taint[24]=ORANGE_SHARE;
constraint :: "TaintOnNodeIdx34" taint[34]=ORANGE_NOSHARE;
constraint :: "TaintOnNodeIdx39" taint[39]=FOO;
