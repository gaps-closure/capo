% Node definitions

% define instruction nodes
enum Inst_FunCall;
enum Inst_Ret;
enum Inst_Br;
enum Inst_Other;
enum Inst = C_Inst_FunCall(Inst_FunCall) ++ C_Inst_Ret(Inst_Ret) ++ C_Inst_Br(Inst_Br) ++ C_Inst_Other(Inst_Other);

array[Inst_FunCall] of int : funcall2ID;

% define var nodes
enum VarNode_StaticGlobal;
enum VarNode_StaticModule;
enum VarNode_StaticFunction;
enum VarNode_StaticOther;
enum VarNode = C_VarNode_StaticGlobal(VarNode_StaticGlobal) ++ C_VarNode_StaticModule(VarNode_StaticModule) ++ C_VarNode_StaticFunction(VarNode_StaticFunction) ++ C_VarNode_StaticOther(VarNode_StaticOther);


% define function and param nodes
enum FunctionEntry;

enum Param_FormalIn;
enum Param_FormalOut;
enum Param_ActualIn;
enum Param_ActualOut;
enum Param = C_Param_FormalIn(Param_FormalIn) ++ C_Param_FormalOut(Param_FormalOut) ++ C_Param_ActualIn(Param_ActualIn) ++ C_Param_ActualOut(Param_ActualOut);


% define annotation nodes

enum Annotation_Var;
enum Annotation_Global;
enum Annotation_Other;
enum Annotation = C_Annotation_Var(Annotation_Var) ++ C_Annotation_Global(Annotation_Global) ++ C_Annotation_Other(Annotation_Other);

enum PDGNode =    C_Inst(Inst)  ++ C_VarNode(VarNode) ++  C_FunctionEntry(FunctionEntry) ++ C_Param(Param)  ++  C_Annotation(Annotation);

% edge definitions


% define control dependency edges

enum ControlDep_CallInv;
enum ControlDep_CallRet;
enum ControlDep_Entry;
enum ControlDep_Br;
enum ControlDep_Other;
enum ControlDep = C_ControlDep_CallInv(ControlDep_CallInv) ++ C_ControlDep_CallRet(ControlDep_CallRet) ++ C_ControlDep_Entry(ControlDep_Entry) ++ C_ControlDep_Br(ControlDep_Br) ++ C_ControlDep_Other(ControlDep_Other);

% define data dependency edges

enum DataDepEdge_DefUse;
enum DataDepEdge_RAW;
enum DataDepEdge_Ret;
enum DataDepEdge_Alias;
enum DataDep = C_DataDepEdge_DefUse(DataDepEdge_DefUse) ++ C_DataDepEdge_RAW(DataDepEdge_RAW) ++ C_DataDepEdge_Ret(DataDepEdge_Ret) ++ C_DataDepEdge_Alias(DataDepEdge_Alias);

% define parameter edges

enum Parameter_In;
enum Parameter_Out;
enum Parameter_Field;
enum Parameter = C_Parameter_In(Parameter_In) ++ C_Parameter_Out(Parameter_Out) ++ C_Parameter_Field(Parameter_Field);

% define annotation edges

enum Anno_Global;
enum Anno_Var;
enum Anno_Other;
enum Anno = C_Anno_Global(Anno_Global) ++ C_Anno_Var(Anno_Var) ++ C_Anno_Other(Anno_Other);

% break constraint into 2 Constraints
% remove artificial ordering dependency
% enum DataEdge = C_DataDep(DataDep) ++ C_Parameter(Parameter);

enum PDGEdge = C_ControlDep(ControlDep) ++ C_DataDep(DataDep) ++ C_Parameter(Parameter) ++ C_Anno(Anno);


% convenience aggregations

% globals of interest
enum Global = C_VarNode_StaticGlobal2(VarNode_StaticGlobal) ++ C_VarNode_StaticModule2(VarNode_StaticModule);


% seperate control dep
enum ControlDep_Call = C_ControlDep_CallInv2(ControlDep_CallInv) ++ C_ControlDep_CallRet2(ControlDep_CallRet);
enum ControlDep_NonCall = C_ControlDep_Entry2(ControlDep_Entry) ++ C_ControlDep_Br2(ControlDep_Br) ++ C_ControlDep_Other2(ControlDep_Other);


% node properties
array[PDGNode] of Function: hasFunction;
% array[Inst] of Function: hasFunction;
% enum PDGNode =    C_Inst(Inst)  ++ C_VarNode(VarNode) ++  C_FunctionEntry(FunctionEntry) ++ C_Param(Param)  ++  C_Annotation(Annotation);



% =================== CLE definitions ========================
% ===== CLE Constants =======
enum GuardOperation = {noOp,allow,deny,redact};
enum Direction = {noDir,bidirectional,egress, ingress};

enum Level; = {none,orange,purple};
enum cleEntry;
enum cdf;

enum remotelevel;
enum direction;
enum operation;
enum argtaints;
enum codtaints;
enum rettaints;

array[int,int] of cleEntry : hasargtaints;
array[int] of cleEntry : hascodtaints;
array[int] of cleEntry : hasrettaints;

enum hasParamIdx = {};
enum hasTaint = {};
% array[int] hasFuncTaints = {hasBodyTaint,hasArgTaint, hasRetTaint, None};
cleEntry : hasBodyTaint = None;
array[int] of cleEntry: hasArgTaint = [];
cleEntry : hasRetTaint = None;
array[int] of cdf: hasCDF = [];

set of int: num_nodes = 0..max(PDGNode);
array[num_nodes] of var cleEntry:  hasCle ;
array[cleEntry] of Level:  haslevel;
array[cleEntry] of Level: hasremotelevel;
array[cdf] of Direction: hasdirection;
array[cdf] of GuardOperation: hasoperation;




array[int] of int: hasSource;
array[int] of int: hasDest;

array[int] of int: invForRet; % preprocess to match return for call invocation

% Decision variables
% array[PDGNode] of var Enclaves: nodeEnclave; % MiniZinc initializes these to first value in Enclaves
array[PDGNode] of var cleEntry: nodeEnclave; % MiniZinc initializes these to first value in Enclaves
array[PDGEdge] of var bool: resolvableConflict;


%Enclaves
enum Enclaves;              % { nullEnclave } + all possible enclaves
array[Enclaves] of Level:  enclaveLevel;
