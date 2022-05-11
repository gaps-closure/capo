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

int: Annotated_start;
int: Annotated_end;
int: Unannotated_start;
int: Unannotated_end;
int: External_start;
int: External_end;
int: AnnotatedInstanceField_start;
int: AnnotatedInstanceField_end;
int: UnannotatedInstanceField_start;
int: UnannotatedInstanceField_end;
int: ExternalInstanceField_start;
int: ExternalInstanceField_end;
int: AnnotatedClassField_start;
int: AnnotatedClassField_end;
int: UnannotatedClassField_start;
int: UnannotatedClassField_end;
int: ExternalClassField_start;
int: ExternalClassField_end;
int: AnnotatedInstanceMethod_start;
int: AnnotatedInstanceMethod_end;
int: UnannotatedInstanceMethod_start;
int: UnannotatedInstanceMethod_end;
int: ExternalInstanceMethod_start;
int: ExternalInstanceMethod_end;
int: AnnotatedClassMethod_start;
int: AnnotatedClassMethod_end;
int: UnannotatedClassMethod_start;
int: UnannotatedClassMethod_end;
int: ExternalClassMethod_start;
int: ExternalClassMethod_end;
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
int: Class_start;
int: Class_end;
int: InstanceField_start;
int: InstanceField_end;
int: ClassField_start;
int: ClassField_end;
int: Field_start;
int: Field_end;
int: InstanceMethod_start;
int: InstanceMethod_end;
int: ClassMethod_start;
int: ClassMethod_end;
int: Method_start;
int: Method_end;
int: Element_start;
int: Element_end;
int: Node_start;
int: Node_end;
int: Call_start;
int: Call_end;
int: Access_start;
int: Access_end;
int: Edge_start;
int: Edge_end;

set of int: Class   = Class_start   .. Class_end;
set of int: Field   = Field_start   .. Field_end;
set of int: Method  = Method_start  .. Method_end;
set of int: Element = Element_start .. Element_end;
set of int: Call    = Call_start    ..  Call_end;
set of int: Access  = Access_start  .. Access_end;

array[Element] of Class:  hasClass;
array[Call]    of Method: hasCaller;
array[Call]    of Method: hasCallee;
array[Access]  of Method: fromMethod;
array[Access]  of Field:  toField;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision and auxiliary variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%array[Class,Enclave] of var bool: classEnclave;
%array[Class,Level]   of var bool: classTouchesLevel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
