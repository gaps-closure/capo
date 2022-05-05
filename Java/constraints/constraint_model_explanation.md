# Constraint model for CLE for JOANA SDG based on Java/JVM
# SDG Graph
## SDG Nodes
A node in the SDG represents an abstraction of IR components used by JOANA. This results in the following node types on the left and are translated to our own abstraction on the right: (TODO: likely need to create a static node for static fields and maybe staic methods)

    - "NORM" : "Inst_Other"
    - "PRED" : "Inst_Br"
    - "EXPR" : "Inst_Other"
    - "SYNC" : "Inst_Other"
    - "FOLD" : "Inst_Other"
    - "CALL" : "Inst_FunCall"
    - "ENTR" : "FunctionEntry"
    - "EXIT" : "Inst_Ret"
    - "ACTI" : "Param_ActualIn"
    - "ACTO" : "Param_ActualOut"
    - "FRMI" : "Param_FormalIn"
    - "FRMO" : "Param_FormalOut"
## SDG Edges
An edge in the SDG connects two nodes together and has a type. Note that in the SDG model, exceptions are modeled as parameter edges. The following shows the edge types in the SDG on the left and our abstraction on the left: (TODO: define set of source and dest node types.) 

    - "CD" : "ControlDep_Other"
    - "CE" : "ControlDep_Other"
    - "UN" : "ControlDep_Other"
    - "CF" : "ControlDep_Other"
    - "NF" : "ControlDep_Other"
    - "RF" : "ControlDep_CallRet"
    - "CC" : "ControlDep_CallInv"
    - "CL" : "ControlDep_CallInv"
    - "SD" : "ControlDep_Other"
    - "JOIN" : "ControlDep_Other"
    - "FORK" : "ControlDep_Other"
    - "DD" : "DataDepEdge_Other"
    - "DH" : "DataDepEdge_Other"
    - "DA" : "DataDepEdge_Alias"
    - "SU" : "DataDepEdge_Other"
    - "SH" : "DataDepEdge_Other"
    - "SF" : "DataDepEdge_Other"
    - "FD" : "DataDepEdge_Other"
    - "FI" : "DataDepEdge_Other"
    - "PI" : "Parameter_In"
    - "PO" : "Parameter_Out"
    - "PS" : "Parameter_Field"
    - "PE" : "DataDepEdge_Alias"
    - "FORK_IN" : "DataDepEdge_Other"
    - "FORK_OUT" : "DataDepEdge_Other"
    - "ID" : "DataDepEdge_Other"
    - "IW" : "DataDepEdge_Other"


## Constraint Model in MiniZinc

### Remarks and Limitations

* A limitation of the current model is that it supports at most one enclave per level.
 
* Class annotations are currently not used by CLE, but this can change in the future.

### General Constraints:

* Instance and class fields can be annotated by the user with node annotations.

* Instance and class methods can be annotated by the user with method annotations.

* Constructors can be annotated by the user with constructor annotations.

* Only node annotations can be assigned by the solver to unannotated fields, methods or constructors.

* Method or constructor annotations cannot be assigned by the solver (these can only be assigned by the user). 

* ~~Every class must be assigned to at least one valid enclave.~~

* Each class containing one or more annotated elements (constructor, method, or field) must be assigned to exactly one enclave. 

* Each class containing no annotated elements must be assigned to at least one enclave and at most every enclave.

* Across all accesses/invocations of an unannotated element, it may touch at most one label at each level.

* All elements (constructor, method, or field) of a class instance must be assigned the same enclave as the instance itself. This entails separate constraints for constructors, instance methods, instance fields, static methods and static fields.

* Contained nodes and parameters are assigned the same enclave(s) as their containing
methods.  

* Annotations can not be assigned to a valid enclave and they must be
assigned to `nullEnclave`.

* ~~Each (node,level) pair is assigned at most one valid enclave at that level.~~

* Each (node,level) pair is assigned at most one valid label with that level.

* Only method entry nodes can be assigned a method annotation label.
* Only constructor entry nodes can be assigned a constructor annotation label.

### 2.2 Constraints on the Cross-Domain Control Flow

The control flow can never leave an enclave, unless it is done through an
approved cross-domain call, as expressed in the following constraints.

1) The only control edges allowed in the cross-domain cut are either call
invocations or returns. 

2) For any call invocation edge in the cut, the method annotation of the method entry being called must have a CDF that allows (with or without redaction) the level of the label assigned to the callsite (caller).  


### 2.3 Constraints on the Cross-Domain Data Flow

Data can only leave an enclave through parameters or return of valid
cross-domain call invocations, as expressed in the following three constraints. 

1) Any data dependency edge that is not a parameter or data return cannot be in the
cross-domain cut.  

2) For any data return edge in the cut, the taint of the source
node (the returned value in the callee) must have a CDF that allows the data to
be shared with the level of the taint of the destination node (the return site 
in the caller). 

3) For any parameter passing edge in the cut, the taint of the source
node must have a CDF that allows the data to be shared with the level of the taint of the destination node. This applies to the input parameters going from caller to callee and output parameters going from callee back to the caller.

Note: For cross domain calls, the callee is assigned to a fixed enclave level. The caller may be unannotated and the label to be considered (e.g. for argument passing checks) would corrsepond to the label applicable at the level of the caller (instance).


### 2.4 Constraints on Taint Coercion Within Each Enclave

For each level, each node in an unannotated method or constructor must have the same taint as the containing unannotated method or constructor itself.

For each level, for each parameter or data dependency (including returns) edges with at least one end point in an unannotated method or constructor, both end points must have the same taint.

Unannotated methods can be assigned to multiple enclaves as long as they touch only one taint within that enclave. Annotated methods, on the other hand, can only be assigned to a single enclave/level.

Each node in an annotated method or constructor must have a taint that is allowed by the argument taints (argtaints), code taints (codtaints), or the return taints (rettaints) of the corresponding method/constructor annotation.

For each parameter-in or parameter-out edge connected to an argument of an annotated method or constructor, the taint of the remote (caller side) endpoint must be allowed by the argument taints (argtaints) for that argument in the annotation applied to the method or constructor.

For each data return edge of an annotated method or constructor, the taint of remote (caller side) endpoint must be allowed by the return taints (rettaints) of the annotation applied to the method or constructor.

For each data dependency edge (that is not a return or parameter edge) of an annotated method or constructor, the taint of both endpoints must be allowed by at least one of the following: argument taints (argtaints), code taints (codtaints), or return taints (rettaints) of the annotation applied to the method or constructor.

### 2.5 Class Constraints


* For each level, all elements of a class that contains no annotated elements must have the same taint.

* All taints on a static field must be at the same level. Unfortunately this means that a class with a static field can only be assigned to a single enclave. This can be relaxed for final static variables because they will not change.


* A class that contains no unannotated elements is assigned only to the enclaves/levels in which it is singly tainted. If no taint is touched at a level by any element, then the class is not assigned to that enclave/level.

* The taint(s) of the object reference (this) must be allowed by the code taints (codtaints) of annotated methods. (If the object reference can take multiple labels, then unannotated methods are not possible within that class.)

* The taints of all elements of a class that contains an annotated element must have the same level, and the class is assigned to that enclave/level.

### Future Work
* Can we relax this in cases where this is not actually touched.
* How to support multiple enclaves per level
* How can we allow unannotated classes with static fields to be assigned to multiple enclaves.





