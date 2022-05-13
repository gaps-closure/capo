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
int: InternalInstanceCall_start;
int: InternalInstanceCall_end;
int: InternalStaticCall_start;
int: InternalStaticCall_end;
int: ExternalInstanceCall_start;
int: ExternalInstanceCall_end;
int: ExternalStaticCall_start;
int: ExternalStaticCall_end;
int: InternalInstanceAccess_start;
int: InternalInstanceAccess_end;
int: InternalStaticAccess_start;
int: InternalStaticAccess_end;
int: ExternalInstanceAccess_start;
int: ExternalInstanceAccess_end;
int: ExternalStaticAccess_start;
int: ExternalStaticAccess_end;

set of int: Class            = AnnotatedInternalClass_start         .. UnannotatedExternalClass_end;
set of int: Element          = AnnotatedInternalInstanceField_start .. UnannotatedExternalStaticMethod_end;
set of int: Node             = AnnotatedInternalClass_start         .. UnannotatedExternalStaticMethod_end;
set of int: Call             = InternalInstanceCall_start           .. ExternalStaticCall_end;
set of int: Access           = InternalInstanceAccess_start         .. ExternalStaticAccess_end;
set of int: Edge             = InternalInstanceCall_start           .. ExternalStaticAccess_end;

set of int: AnnotatedElement = AnnotatedInternalInstanceField_start .. AnnotatedInternalStaticMethod_end;
set of Level: ValidLevel     = { x | x in Level where x != nullLevel };

array[Node]             of Class:    hasClass;
array[Edge]             of Node:     hasFrom;
array[Edge]             of Node:     hasTo;
array[AnnotatedElement] of cleLabel: hasAnnotation;

%array[Call]             of Node:     callFrom;
%array[Call]             of Node:     callTo;
%array[Access]           of Node:     accessFrom;
%array[Access]           of Node:     accessTo;

set of int: AnnotatedClass   = AnnotatedInternalClass_start         .. AnnotatedInternalClass_end;
set of int: UnannotatedClass = UnannotatedInternalClass_start       .. UnannotatedExternalClass_end;

predicate isAnnotatedClass(var Class: x)   = x >= AnnotatedInternalClass_start   /\ x <= AnnotatedInternalClass_end;
predicate isUnannotatedClass(var Class: x) = x >= UnannotatedInternalClass_start /\ x <= UnannotatedExternalClass_end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision and auxiliary variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

array[AnnotatedClass]              of var Level:    boundLevel;
array[UnannotatedClass,ValidLevel] of var cleLabel: labelAtLevel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
