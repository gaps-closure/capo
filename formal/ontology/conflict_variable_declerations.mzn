% define instruction nodes
set of int: Inst_FunCall = Inst_FunCall_start .. Inst_FunCall_end;
set of int: Inst_Ret = Inst_Ret_start .. Inst_Ret_end;
set of int: Inst_Br = Inst_Br_start .. Inst_Br_end;
set of int: Inst_Other = Inst_Other_start .. Inst_Other_end;
set of int: Inst = Inst_start .. Inst_end;

% define var nodes
set of int: VarNode_StaticGlobal = VarNode_StaticGlobal_start .. VarNode_StaticGlobal_end;
set of int: VarNode_StaticModule = VarNode_StaticModule_start .. VarNode_StaticModule_end;
set of int: VarNode_StaticFunction = VarNode_StaticFunction_start .. VarNode_StaticFunction_end;
set of int: VarNode_StaticOther = VarNode_StaticOther_start .. VarNode_StaticOther_end;
set of int: VarNode = VarNode_start .. VarNode_end;

% define function and param nodes
set of int: FunctionEntry = FunctionEntry_start .. FunctionEntry_end;

set of int: Param_FormalIn = Param_FormalIn_start .. Param_FormalIn_end;
set of int: Param_FormalOut = Param_FormalOut_start .. Param_FormalOut_end;
set of int: Param_ActualIn = Param_ActualIn_start .. Param_ActualIn_end;
set of int: Param_ActualOut = Param_ActualOut_start .. Param_ActualOut_end;
set of int: Param = Param_start .. Param_end;

% define annotation nodes

set of int: Annotation_Var = Annotation_Var_start .. Annotation_Var_end;
set of int: Annotation_Global = Annotation_Global_start .. Annotation_Global_end;
set of int: Annotation_Other = Annotation_Other_start .. Annotation_Other_end;
set of int: Annotation  = Annotation_start .. Annotation_end;


set of int: PDGNodeIdx  = PDGNode_start .. PDGNode_end;

% array[1 .. max(PDGNodeIdx)] of int: PDGNodes;

% edge definitions


% define control dependency edges

set of int: ControlDep_CallInv = ControlDep_CallInv_start .. ControlDep_CallInv_end;
set of int: ControlDep_CallRet = ControlDep_CallRet_start .. ControlDep_CallRet_end;
set of int: ControlDep_Entry = ControlDep_Entry_start .. ControlDep_Entry_end;
set of int: ControlDep_Br = ControlDep_Br_start .. ControlDep_Br_end;
set of int: ControlDep_Other = ControlDep_Other_start .. ControlDep_Other_end;
set of int: ControlDep = ControlDep_start .. ControlDep_end;


% define data dependency edges

set of int: DataDepEdge_DefUse = DataDepEdge_DefUse_start .. DataDepEdge_DefUse_end;
set of int: DataDepEdge_RAW  = DataDepEdge_RAW_start .. DataDepEdge_RAW_end;
set of int: DataDepEdge_Ret  = DataDepEdge_Ret_start .. DataDepEdge_Ret_end;
set of int: DataDepEdge_Alias = DataDepEdge_Alias_start .. DataDepEdge_Alias_end;
set of int: DataDepEdge = DataDepEdge_start .. DataDepEdge_end;
% define parameter edges

set of int: Parameter_In = Parameter_In_start .. Parameter_In_end;
set of int: Parameter_Out = Parameter_Out_start .. Parameter_Out_end;
set of int: Parameter_Field = Parameter_Field_start .. Parameter_Field_end;
set of int: Parameter = Parameter_start .. Parameter_end;
% define annotation edges

set of int: Anno_Global = Anno_Global_start .. Anno_Global_end;
set of int: Anno_Var = Anno_Var_start .. Anno_Var_end;
set of int: Anno_Other = Anno_Other_start .. Anno_Other_end;
set of int: Anno = Anno_start .. Anno_end;

set of int: PDGEdgeIdx = PDGEdge_start .. PDGEdge_end;
% array[1 .. max(PDGEdgeIdx)] of int: PDGEdges;

% convenience aggregations

% globals of interest
set of int: Global = VarNode_StaticGlobal union VarNode_StaticModule;


% seperate control dep
set of int: ControlDep_Call = ControlDep_CallInv union ControlDep_CallRet;
set of int: ControlDep_NonCall = ControlDep_Entry union ControlDep_Br union ControlDep_Other;


set of int: DataEdge = DataDepEdge union Parameter;
set of int: DataEdgeNoRet = DataDepEdge_DefUse union DataDepEdge_RAW union DataDepEdge_Alias;

% node properties
array[int] of int: hasFunction;

%edge properties
array[int] of int: hasSource;
array[int] of int: hasDest;

% array[int] of int: invForRet; % preprocess to match return for call invocation

array[1 .. max(PDGNodeIdx)] of var cleEntry: hasCle ;

% =================== CLE definitions ========================
enum GuardOperation = {allow,deny,redact, noOp};
enum Direction = {bidirectional,egress, ingress, noDir};

enum cleEntry;
enum cdf;
enum remotelevel;
% enum direction;
% enum operation;
% enum argtaints;
% enum codtaints;
% enum rettaints;
% enum hasParamIdx;
% enum hasTaint;


% array[int] hasFuncTaints = {hasBodyTaint,hasArgTaint, hasRetTaint, None};
array[cleEntry] of Level:  haslevel;
array[cleEntry, int] of cdf: hasCDF;
array[cdf] of Level: hasremotelevel;
array[cdf] of Direction: hasdirection;
array[cdf] of GuardOperation: hasoperation;
% array[cdf, hasParamIdx] of cleEntry: hasargtaints;
% array[cdf] of cleEntry : hascodtaints;
% array[cdf] of cleEntry : hasrettaints;




% Enclave Declerations
enum Enclaves; 
enum Level;
array[Enclaves] of Level: hasEnclaveLevel;



% Decision variables
array[1 .. max(PDGNodeIdx)] of var Enclaves: nodeEnclave; % MiniZinc initializes these to first value in Enclaves
% array[1 .. max(PDGNodeIdx)] of var cleEntry: nodeEnclave; % MiniZinc initializes these to first value in Enclaves
array[1 .. max(PDGEdgeIdx)] of var bool: resolvableConflict;



