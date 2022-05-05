%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDG Nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int: Inst_FunCall_start;
int: Inst_FunCall_end;
int: Inst_Ret_start;
int: Inst_Ret_end;
int: Inst_Br_start;
int: Inst_Br_end;
int: Inst_Other_start;
int: Inst_Other_end;
int: Inst_start;
int: Inst_end;

% int: VarNode_StaticGlobal_start;
% int: VarNode_StaticGlobal_end;
% int: VarNode_StaticModule_start;
% int: VarNode_StaticModule_end;
% int: VarNode_StaticFunction_start;
% int: VarNode_StaticFunction_end;
% int: VarNode_StaticOther_start;
% int: VarNode_StaticOther_end;
% int: VarNode_start;
% int: VarNode_end;

int: FunctionEntry_start;
int: FunctionEntry_end;


% Need to check that there isn't an issue with non-contiguious arg indicies
int: Param_FormalIn_start;
int: Param_FormalIn_end;
int: Param_FormalOut_start;
int: Param_FormalOut_end;
int: Param_ActualIn_start;
int: Param_ActualIn_end;
int: Param_ActualOut_start;
int: Param_ActualOut_end;
int: Param_start;
int: Param_end;

% int: Annotation_Var_start;
% int: Annotation_Var_end;
% int: Annotation_Global_start;
% int: Annotation_Global_end;
% int: Annotation_Other_start;
% int: Annotation_Other_end;
% int: Annotation_start;
% int: Annotation_end;

int: PDGNode_start;
int: PDGNode_end;

set of int: Inst = Inst_start .. Inst_end;
set of int: FunCall = Inst_FunCall_start .. Inst_FunCall_end;

% set of int: VarNode_StaticGlobal = VarNode_StaticGlobal_start .. VarNode_StaticGlobal_end;
% set of int: VarNode_StaticModule = VarNode_StaticModule_start .. VarNode_StaticModule_end;
% set of int: VarNode_StaticFunction = VarNode_StaticFunction_start .. VarNode_StaticFunction_end;
% set of int: VarNode_StaticOther = VarNode_StaticOther_start .. VarNode_StaticOther_end;
% set of int: VarNode = VarNode_start .. VarNode_end;

set of int: FunctionEntry = FunctionEntry_start .. FunctionEntry_end;

set of int: Param_FormalIn = Param_FormalIn_start .. Param_FormalIn_end;
set of int: Param_FormalOut = Param_FormalOut_start .. Param_FormalOut_end;
set of int: Param_ActualIn = Param_ActualIn_start .. Param_ActualIn_end;
set of int: Param_ActualOut = Param_ActualOut_start .. Param_ActualOut_end;
set of int: Param = Param_start .. Param_end;

% set of int: Annotation_Var = Annotation_Var_start .. Annotation_Var_end;
% set of int: Annotation_Global = Annotation_Global_start .. Annotation_Global_end;
% set of int: Annotation_Other = Annotation_Other_start .. Annotation_Other_end;
% set of int: Annotation  = Annotation_start .. Annotation_end;

set of int: PDGNodeIdx  = PDGNode_start .. PDGNode_end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDG Edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int: ControlDep_CallInv_start;
int: ControlDep_CallInv_end;
int: ControlDep_CallRet_start;
int: ControlDep_CallRet_end;
% int: ControlDep_Entry_start;
% int: ControlDep_Entry_end;
% int: ControlDep_Br_start;
% int: ControlDep_Br_end;
int: ControlDep_Other_start;
int: ControlDep_Other_end;
int: ControlDep_start;
int: ControlDep_end;

% int: DataDepEdge_DefUse_start;
% int: DataDepEdge_DefUse_end;
% int: DataDepEdge_RAW_start;
% int: DataDepEdge_RAW_end;
int: DataDepEdge_Ret_start;
int: DataDepEdge_Ret_end;
% Find example of alias in program
int: DataDepEdge_Alias_start;
int: DataDepEdge_Alias_end;

int: DataDepEdge_Other_start;
int: DataDepEdge_Other_end;
int: DataDepEdge_start;
int: DataDepEdge_end;

int: Parameter_In_start;
int: Parameter_In_end;
int: Parameter_Out_start;
int: Parameter_Out_end;
int: Parameter_Field_start;
int: Parameter_Field_end;
int: Parameter_start;
int: Parameter_end;

% int: Anno_Global_start;
% int: Anno_Global_end;
% int: Anno_Var_start;
% int: Anno_Var_end;
% int: Anno_Other_start;
% int: Anno_Other_end;
% int: Anno_start;
% int: Anno_end;

int: PDGEdge_start;
int: PDGEdge_end;

set of int: ControlDep_CallInv = ControlDep_CallInv_start .. ControlDep_CallInv_end;
set of int: ControlDep_CallRet = ControlDep_CallRet_start .. ControlDep_CallRet_end;
% set of int: ControlDep_Entry = ControlDep_Entry_start .. ControlDep_Entry_end;
% set of int: ControlDep_Br = ControlDep_Br_start .. ControlDep_Br_end;
set of int: ControlDep_Other = ControlDep_Other_start .. ControlDep_Other_end;
set of int: ControlDep = ControlDep_start .. ControlDep_end;

% set of int: DataDepEdge_DefUse = DataDepEdge_DefUse_start .. DataDepEdge_DefUse_end;

% set of int: DataDepEdge_RAW  = DataDepEdge_RAW_start .. DataDepEdge_RAW_end;
set of int: DataDepEdge_Ret  = DataDepEdge_Ret_start .. DataDepEdge_Ret_end;
set of int: DataDepEdge_Alias = DataDepEdge_Alias_start .. DataDepEdge_Alias_end;
set of int: DataDepEdge_Other = DataDepEdge_Other_start .. DataDepEdge_Other_end;
set of int: DataDepEdge = DataDepEdge_start .. DataDepEdge_end;

set of int: Parameter_In = Parameter_In_start .. Parameter_In_end;
set of int: Parameter_Out = Parameter_Out_start .. Parameter_Out_end;
set of int: Parameter_Field = Parameter_Field_start .. Parameter_Field_end;
set of int: Parameter = Parameter_start .. Parameter_end;

% set of int: Anno_Global = Anno_Global_start .. Anno_Global_end;
% set of int: Anno_Var = Anno_Var_start .. Anno_Var_end;
% set of int: Anno_Other = Anno_Other_start .. Anno_Other_end;
% set of int: Anno = Anno_start .. Anno_end;

set of int: PDGEdgeIdx = PDGEdge_start .. PDGEdge_end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Java OO Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Try slicing off last element of enum
% Drop enums for sets of ints

% enum AllClassNames;
% set of AllClassNames: classNames = { x | x in AllClassNames where x!=External_Class };


int: ClassNames_start;
int: ClassNames_end;
int: ExternalClass;

% int: ClassFields_start;
% int: ClassFields_end;

% int: ClassMethods_start;
% int: ClassMethods_end;

int: ClassFields_Instance_start;
int: ClassFields_Instance_end;
int: ClassFields_Static_start;
int: ClassFields_Static_end;
int: ClassMethods_Instance_start;
int: ClassMethods_Instance_end;
int: ClassMethods_Static_start;
int: ClassMethods_Static_end;

set of int: ClassNames = ClassNames_start .. ClassNames_end;
set of int: AllClassNames = ClassNames_start .. ClassNames_end union {ExternalClass};

set of int: ClassFields_Instance = ClassFields_Instance_start .. ClassFields_Instance_end;
set of int: ClassFields_Static = ClassFields_Static_start .. ClassFields_Static_end;
set of int: ClassFields = ClassFields_Instance_start .. ClassFields_Static_end;

set of int: ClassMethods_Instance = ClassMethods_Instance_start .. ClassMethods_Instance_end;
set of int: ClassMethods_Static = ClassMethods_Static_start .. ClassMethods_Static_end;
set of int: ClassMethods = ClassMethods_Instance_start .. ClassMethods_Static_end;

set of int: ClassElements = ClassFields_Instance_start .. ClassMethods_Static_end;

% set of int: ClassFields = ClassFields_start .. ClassFields_end;

% set of int: ClassMethods = ClassMethods_start .. ClassMethods_end;



% array[ClassNames]     of set of ClassFields:  classOfField;
% array[ClassNames]     of set of ClassMethods:  classOfMethod;


array[ClassFields]     of ClassNames:  fieldOfClass;

% array[ClassFields]     of bool:  fieldIsStatic;
% array[ClassMethods]     of bool:  methodIsStatic;

array[ClassMethods]     of ClassNames:  methodOfClass;


array[ClassNames]     of AllClassNames:  immediateParent;
array[ClassNames]     of set of AllClassNames:  allParents;
array[ClassNames]     of set of AllClassNames:  implementsInterface;


array[FunctionEntry]     of set of ClassFields:  methodsFieldAccess;
% array[FunctionEntry]     of set of ClassInstanceFields:  methodsFieldAccess;
% array[FunctionEntry]     of set of ClassStaticFields:  methodsFieldAccess;

% From the input model we need to know fields to class
% In the input model we must have:
    % Enumeration of classes
    % Enumeration of fields
    % Relationship of fields to classes
    % Whether a field is an instance or class field
    % Enumeration of methods
    % Relationship of methods to classes
    % Whether a method is an instance or a class method
    % Inheritance Relationship between classes
        % Is immediate parent-subclass relationship
        % Is ancestor successor relationship
        % Implementer to interface relationship

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Containing Class for PDG Nodes, Containing Function for PDG Nodes, Endpoints for PDG Edges, Indices of Fucntion Formal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

array[PDGNodeIdx]     of ClassNames:  hasClass;
array[PDGNodeIdx]     of FunctionEntry:  hasFunction;
array[PDGEdgeIdx]     of int:  hasSource;
array[PDGEdgeIdx]     of int:  hasDest;
array[Param]          of int:  hasParamIdx;
array[FunctionEntry]  of bool: userAnnotatedFunction;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convenience Aggregations of PDG Nodes and Edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set of int: Global              = VarNode_StaticGlobal union VarNode_StaticModule;
set of int: NonAnnotation       = Inst union FunctionEntry union Param;
set of int: ControlDep_Call     = ControlDep_CallInv union ControlDep_CallRet;
set of int: ControlDep_NonCall  = ControlDep_Other;
set of int: DataEdgeNoRet       = DataDepEdge_Other union DataDepEdge_Alias;
% set of int: DataEdgeNoRet       = DataDepEdge_Other;
set of int: DataEdgeNoRetParam  = DataEdgeNoRet union Parameter_Field;
set of int: DataEdgeParam       = DataDepEdge union Parameter;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Security Levels and Enclaves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


enum Level;
set of Level: nonNullLevel = { x | x in Level where x!=nullLevel };
enum Enclave;
set of Enclave: nonNullEnclave = { x | x in Enclave where x!=nullEnclave };

array[Enclave] of Level: hasEnclaveLevel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLE Input Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enum cleLabel;
enum cdf;
enum GuardOperation = {nullGuardOperation, allow, deny, redact};
enum Direction      = {nullDirection, bidirectional, egress, ingress};

int: MaxFuncParms;  % Max number of function parameters in the program (C<128, C++<256)
set of int: parmIdx = 1..MaxFuncParms;

array[cleLabel]                       of Level:          hasLabelLevel;
array[ClassNames]                     of bool:           isClassAnnotated;
array[cleLabel]                       of bool:           isFunctionAnnotation;

array[cdf]                            of cleLabel:       fromCleLabel;
array[cdf]                            of Level:          hasRemotelevel;
array[cdf]                            of GuardOperation: hasGuardOperation;
array[cdf]                            of Direction:      hasDirection;
array[cdf]                            of bool:           isOneway;
array[cleLabel, Level]                of cdf:            cdfForRemoteLevel;

set of cdf: functionCdf = { x | x in cdf where isFunctionAnnotation[fromCleLabel[x]]==true };
% set of cdf: functionCdf = {OrangeMain_cdf_0,PurpleOrangeCallable_cdf_0,PurpleOrangeConstructable_cdf_0 };

array[functionCdf, cleLabel]          of bool:           hasRettaints;
array[functionCdf, cleLabel]          of bool:           hasCodtaints;
array[functionCdf, parmIdx, cleLabel] of bool:           hasArgtaints;
array[functionCdf, cleLabel]          of bool:           hasARCtaints;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Debug flag and decision variables for the solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bool:                                                    debug;
debug = true;


% array[ClassNames]                     of var Enclave:    classEnclave;
% array[ClassNames,nonNullLevel]                of var Enclave:    classEnclave;

% array[ClassNames,nonNullEnclave]                     of var Enclave:    classEnclave;
array[PDGNodeIdx,nonNullEnclave]                     of var Enclave:    nodeEnclave;
array[PDGNodeIdx,nonNullEnclave]                     of var Level:      nodeLevel;
array[PDGNodeIdx,nonNullEnclave]                     of var cleLabel:   taint;
array[PDGNodeIdx,nonNullEnclave]                     of var cleLabel:   ftaint;
array[ClassNames,nonNullEnclave]                     of var cleLabel:   ctaint;

array[ClassFields,nonNullEnclave]                    of var cleLabel:   fieldTaint;


array[PDGEdgeIdx,nonNullEnclave]                     of var Enclave:    esEnclave;
array[PDGEdgeIdx,nonNullEnclave]                     of var Enclave:    edEnclave;

array[PDGEdgeIdx,nonNullEnclave]                     of var cleLabel:   esTaint;
array[PDGEdgeIdx,nonNullEnclave]                     of var cleLabel:   edTaint;

array[PDGEdgeIdx,nonNullEnclave]                     of var cleLabel:   esFunTaint;
array[PDGEdgeIdx,nonNullEnclave]                     of var cleLabel:   edFunTaint;


array[PDGEdgeIdx,nonNullEnclave]                     of var cdf:        esFunCdf;
array[PDGEdgeIdx,nonNullEnclave]                     of var cdf:        edFunCdf;

array[PDGEdgeIdx,nonNullEnclave]                     of var bool:       xdedge;
array[PDGEdgeIdx,nonNullEnclave]                     of var bool:       tcedge;

array[PDGEdgeIdx,nonNullEnclave]                     of var bool:       coerced;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% array[ClassFields]     of cleLabel:  fieldAnnotation;
% array[ClassMethods]     of cleLabel:  methodAnnotation;