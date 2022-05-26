%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Security Levels and Enclaves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enum Level;
enum Enclave;
array[Enclave] of Level: hasEnclaveLevel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLE Input Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enum cleLabel;
enum GuardOperation = {nullGuardOperation, allow, deny, redact};
enum Direction = {nullDirection, bidirectional, egress, ingress};

enum cdf;  % function cdfs must be kept contiguous
set of cdf: functionCdf = { x | x in cdf where isFunctionAnnotation[fromCleLabel[x]]==true };

int: MaxFuncParms;  % Max number of parameters in any method or constructor in the program
set of int: parmIdx = 1..MaxFuncParms;

array[cleLabel]                       of Level:          hasLabelLevel;
array[cleLabel]                       of bool:           isFunctionAnnotation;

array[cdf]                            of cleLabel:       fromCleLabel;
array[cdf]                            of Level:          hasRemotelevel;
array[cdf]                            of GuardOperation: hasGuardOperation;
array[cdf]                            of Direction:      hasDirection;
array[cdf]                            of bool:           isOneway;
array[cleLabel, Level]                of cdf:            cdfForRemoteLevel;

array[functionCdf, cleLabel]          of bool:           hasRettaints;
array[functionCdf, cleLabel]          of bool:           hasCodtaints;
array[functionCdf, parmIdx, cleLabel] of bool:           hasArgtaints;
array[functionCdf, cleLabel]          of bool:           hasARCtaints;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Java Program Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int: AnnotatedInternalClass_start;
int: AnnotatedInternalClass_end;
int: UnannotatedInternalClass_start;
int: UnannotatedInternalClass_end;
int: UnannotatedExternalClass_start;
int: UnannotatedExternalClass_end;
int: AnnotatedInternalInstanceField_start;
int: AnnotatedInternalInstanceField_end;
int: AnnotatedInternalStaticField_start;
int: AnnotatedInternalStaticField_end;
int: AnnotatedInternalInstanceMethod_start;
int: AnnotatedInternalInstanceMethod_end;
int: AnnotatedInternalStaticMethod_start;
int: AnnotatedInternalStaticMethod_end;
int: UnannotatedInternalInstanceField_start;
int: UnannotatedInternalInstanceField_end;
int: UnannotatedInternalStaticField_start;
int: UnannotatedInternalStaticField_end;
int: UnannotatedInternalInstanceMethod_start;
int: UnannotatedInternalInstanceMethod_end;
int: UnannotatedInternalStaticMethod_start;
int: UnannotatedInternalStaticMethod_end;
int: UnannotatedExternalInstanceField_start;
int: UnannotatedExternalInstanceField_end;
int: UnannotatedExternalStaticField_start;
int: UnannotatedExternalStaticField_end;
int: UnannotatedExternalInstanceMethod_start;
int: UnannotatedExternalInstanceMethod_end;
int: UnannotatedExternalStaticMethod_start;
int: UnannotatedExternalStaticMethod_end;
int: AnnotatedInternalInstanceCall_start;
int: AnnotatedInternalInstanceCall_end;
int: AnnotatedInternalStaticCall_start;
int: AnnotatedInternalStaticCall_end;
int: UnannotatedInternalInstanceCall_start;
int: UnannotatedInternalInstanceCall_end;
int: UnannotatedInternalStaticCall_start;
int: UnannotatedInternalStaticCall_end;
int: UnannotatedExternalInstanceCall_start;
int: UnannotatedExternalInstanceCall_end;
int: UnannotatedExternalStaticCall_start;
int: UnannotatedExternalStaticCall_end;
int: AnnotatedInternalInstanceAccess_start;
int: AnnotatedInternalInstanceAccess_end;
int: AnnotatedInternalStaticAccess_start;
int: AnnotatedInternalStaticAccess_end;
int: UnannotatedInternalInstanceAccess_start;
int: UnannotatedInternalInstanceAccess_end;
int: UnannotatedInternalStaticAccess_start;
int: UnannotatedInternalStaticAccess_end;
int: UnannotatedExternalInstanceAccess_start;
int: UnannotatedExternalInstanceAccess_end;
int: UnannotatedExternalStaticAccess_start;
int: UnannotatedExternalStaticAccess_end;

set of int: Class            = AnnotatedInternalClass_start          .. UnannotatedExternalClass_end;
set of int: Element          = AnnotatedInternalInstanceField_start  .. UnannotatedExternalStaticMethod_end;
set of int: Node             = AnnotatedInternalClass_start          .. UnannotatedExternalStaticMethod_end;
set of int: Call             = AnnotatedInternalInstanceCall_start   .. UnannotatedExternalStaticCall_end;
set of int: Access           = AnnotatedInternalInstanceAccess_start .. UnannotatedExternalStaticAccess_end;
set of int: Edge             = AnnotatedInternalInstanceCall_start   .. UnannotatedExternalStaticAccess_end;

set of int: AnnotatedClass   = AnnotatedInternalClass_start         .. AnnotatedInternalClass_end;
set of int: UnannotatedClass = UnannotatedInternalClass_start       .. UnannotatedExternalClass_end;
set of int: AnnotatedElement = AnnotatedInternalInstanceField_start .. AnnotatedInternalStaticMethod_end;
set of int: AnnotatedCall    = AnnotatedInternalInstanceCall_start  .. AnnotatedInternalStaticCall_end;

array[Node]             of Class:    hasClass;
array[Edge]             of Node:     hasFrom;
array[Edge]             of Node:     hasTo;
array[AnnotatedElement] of cleLabel: hasAnnotation;

set of Level:   ValidLevel   = { x | x in Level   where x != nullLevel };
set of Enclave: ValidEnclave = { x | x in Enclave where x != nullEnclave };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustered Java Program Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int: ClusterNodes_start;
int: ClusterNodes_end;
int: ClusterEdges_start;
int: ClusterEdges_end;

set of int: ClusterNode = ClusterNodes_start .. ClusterNodes_end;
set of int: ClusterEdge = ClusterEdges_start .. ClusterEdges_end;

array[ClusterEdge] of ClusterNode: hasClusterFrom;
array[ClusterEdge] of ClusterNode: hasClusterTo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
