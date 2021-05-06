# Constraint model formulation

Conflict analyzer is the overall tool, which will prepare the inputs from
toolchain formats (LLVM IR, CLE-JSON), apply a constraint solver, and translate
its outputs to toolchain formats (e.g., topology.json).

## Constraint Solver Output

* enclave assignments for each function
* enclave assignments for each global-scoped variable
* function call edges in the cut (i.e., endpoints are assigned to different enclaves)

## Constraint Solver Objective

Initial objective for developing this model is:
* minimize the number of edges in the cut

In the future we may have other objectives such as fraction of or number of functions in one of the enclaves.

## Additional Input Output Validations
These need to be done by the conflict analyzer, but may not be prudent to overload the constraint solver with these.

* The disposition of every line in the source (C) must be clear: either it goes
  to one enclave (with or without modification), or it is boilerplate
  replicated into all enclaves. The following are necessary but not sufficient:
  - Every node in the PDG is accounted for, i.e., except Annotations every node
    must be assigned to a single valid enclave
  - Every edge in the PDG must be accounted for, it is either in the cut or in
    one of the enclaves
* If multiple (semicolon-separated) C lines cause multiple PDG nodes that must
  go to different enclaves, either the conflict analyzer must keep
  information that allows the line to be broken up and disptached, or provide
  diagnostics to request the developer to break the lines
* Must check for language features not yet supported by CLOSURE
  - functions with variadic arguments or arguments that are not primitives or
    arrays of primitives that must be wrapped cross-domain
  - function pointers involved in cross-domain
  - goto 

## Constraints:

The constraints fall into the following categories. 

Note that these constraints are not meant to prescribe the implementation of the 
constraints in a particular language (SMT-LIB2, MiniZinc, etc.); engineering for 
performance may require re-engineering. The goal here is clarity.

***
In the following constraints, we consider the PDG nodes, PDG edges, and CLE entries/annotations defined in this [axiomatization](https://github.com/gaps-closure/capo/blob/develop/formal/ontology/axioms.vocab)  as inputs.
For example, we use FUNCTIONENTRY to denote a type. The notation fun ∈ FUNCTIONENTRY denotes fun has type FUNCTIONENTRY and ∀ fun ∈ FUNCTIONENTRY denotes for all things that have type FUNCTIONENTRY.

For clarity, when defining a predicate or constraint, an incoming term value is given a type for clarity. For example, the predicate checkEndpointsEq(CONTROLDEP e) takes 1 value as input with name e and type CONTROLDEP.
Each new definition is preceeded by either PREDICATE or CONSTRAINT. A PREDICATE will be evaluated to true or false but may not hold for all valid programs. For a valid program, an expression marked as CONSTRAINT will be true for a valid program.
Enclave<sub>i</sub> denotes an arbitrary enclave (specified in the CLEJson annotation). 

* Let GLOBAL indicate the union of VAR_STATICALLOCGLOBALSCOPE and VAR_STATICALLOCMODULESCOPE.
* Let assignFunctionEnclave[FUNCTIONENTRY] and assignGlobalEnclave[GLOBAL] be as output variables and represent maps from function entries to enclaves and global variables to encalve respectively.
* Let resolvableConflicts[CONTROLDEP] be an output variable indicating a map from each CONTROLDEP edge and to a boolean indicating whether or not the CONTROLDEP is a resolvable conflict.
***

### Assignment 

* Each function and global variable must be assigned to a single valid enclave, 
  (initially the unlabeled ones will be null)
***
* **CONSTRAINT CheckAssignmentFunc**:   ∀ fun ∈ FUNCTIONENTRY, ∃ Enclave<sub>i</sub> ∈ Enclave, assignFunctionEnclave[fun] == Enclave<sub>i</sub>
* **CONSTRAINT CheckAssignmentGlobal**: ∀ global ∈ GLOBAL, ∃Enclave<sub>i</sub> ∈ Enclave, assignGlobalEnclave[global] == Enclave<sub>i</sub>
***

### Control Flow Partitioning

* Endpoints of a control edge must be assigned to the same enclave, unless
  it is a resolvable-control-edge-conflict (in other words, only control edges
  allowed in the cut are resolvable-control-edge-conflicts)

* To be a resolveable-control-edge-conflict
  - the two endpoints of a resolvable-control-flow-edge-conflict must be
    assigned to different valid enclaves
  - the resolvable-control-flow-edge-conflict can only be on a function call
    edge or on its corresponding call return edge(s); and
  - the function associated with a resolvable-control-flow-edge must be one
    that can be validly wrapped in XD RPC

* For a function to be validly wrapped in XD RPC from the control perspective
  - the function has a function annotation
  - the level in the function annotation must be identical to the level of the 
    enclave assigned to the sink endpoint (CONTROLDEP_CALLINV.hasDestinationNode) of the edge
  - the level of the source endpoint of the edge (CONTROLDEP_CALLINV.hasSourceNode) must match one
    the remotelevel of one of the cdfs for the function annotation
  - the corresponding cdf operation must be allow or redact
    (ignore CLE direction field for now)

* How to determine corresponding call return edge(s) for the call edge
  * this is determined from PDG axiomatization

***
* Valid Function:
   * **PREDICATE checkSinkFunc(CONTROLDEP_CALLINV e)**: ∃i, e.hasDestinationNode.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasDestinationNode.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ e.hasDestinationNode.hasEnclave == e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasLevel
   * **PREDICATE checkSourceFunc(CONTROLDEP_CALLINV e)**: ∃i, ∃j, e.hasSourceNode.hasFunction.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasSourceNode.hasFunction.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ e.hasSourceNode.hasFunction.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasLevel == e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasCDF[j].hasRemoteLevel /\ (e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasCDF[j].hasDirective == Allow \\/ e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasCDF[j].hasDirective == Redact) 
   * **PREDICATE validFunction(CONTROLDEP_CALLINV e)**: ∃i, e.hasDestinationNode.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\ checkSinkFunc(e) /\ checkSourceFunc(e) 
  
   * **PREDICATE checkSourceRet(CONTROLDEP_RET e)**: ∃i, e.hasDestinationNode.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasDestinationNode.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ e.hasDestinationNode.hasEnclave == e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasLevel
   * **PREDICATE checkSinkRet(CONTROLDEP_RET e)**: ∃i, ∃j, e.hasSourceNode.hasFunction.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasSourceNode.hasFunction.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ e.hasSourceNode.hasFunction.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasLevel == e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasCDF[j].hasRemoteLevel /\ (e.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasCDF[j].hasDirective == Allow \\/ f.hasDestinationNode.hasOutgoingEdges[i].hasDestinationNode.hasCLEAnnotation.hasCDF[j].hasDirective == Redact)
   * **PREDICATE validReturn(CONTROLDEP_RET e)**: ∃i, e.hasSourceNode.hasFunction.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\ checkSourceRet(e) /\ checkSinkRet(e) 

* Resolvable Conflict:
   * **PREDICATE checkEndpointsDif(CONTROLDEP e)**: e.hasDestinationNode.hasEnclave != e.hasSourceNode.hasEnclave
   * **PREDICATE isResolvableConflict(CONTROLDEP e)**: checkEndpointsDif(e) /\ (e ∈ CONTROLDEP_CALLINV /\ validFunction(e) \\/ e ∈ CONTROLDEP_CALLRET /\ validReturn(e))
* Valid Control Flow Partition
   * **PREDICATE checkEndpointsEq(CONTROLDEP e)**: e.hasDestinationNode.hasEnclave == e.hasSourceNode.hasEnclave 
   * **CONSTRAINT checkControlFlowPart**: ∀ e ∈ CONTROLDEP, checkEndpointsEq(e) \\/ isResolvableConflict(e) /\ resolvableConflicts[e] == isResolvableConflict(e) 
***


There are additional data flow constraints on parameters on the associated
function which we consider next.

### Data Flow Partitioning

* Endpoints of a data flow edge must be assigned to the same enclave, unless it
  is a resolvable-data-edge-conflict

* To be a resolvable data flow edge conflict
  - The endpoints must be assigned to different enclaves
  - The edge must be be passing an argument to or be a return value from the
    function associated with a resolvable-control-flow-edge-conflict
  - For each argument and return, the taint of the variable involved must be
    compatible with at least one that is allowed by the corresponding argtaint
    or rettaint 
  - we say 'compatible' in order to account for auto-generated code that
    generates the TAG_ labels

* To be compatible, the arg/ret taints and the taint on the variable affected
  - match their respective level -- remotelevel settings e.g., variable
    annotation says okay to send from orange to green, and argtaint says okay
    to receive from orange into green
  - operation must be allow or redact in both cases
  - 
***
* Compatibility:
   * **PREDICATE paramCompatibility(PARAMETER e)**: (e ∈ PARAMETER_IN /\ e.hasDestNode ∈ FUNCTIONENTRY /\ ∃i, ∃j e.hasDestNode.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasDestNode.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\  e.hasSourceNode.hasTaint ∈ e.hasDestNode.hasOutgoingEdges[i].hasDestNode.hasCDF[j].hasFunctTaints.hasArgTaint[e.hasSourceNode.hasParamIdx]) \\/  ( e ∈ PARAMETER_OUT /\ e.hasSourceNode ∈ FUNCTIONENTRY /\ e.hasDestinationNode.hasTaint  /\ ∃i, e.hasSourceNode.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasSourceNode.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ e.hasDestNode.hasTaint ∈ e.hasSourceNode.hasOutgoingEdges[i].hasDestNode.hasCDF[j].hasFunctTaints.hasArgTaint[e.hasDestNode.hasParamIdx]) /\  \\/ e ∈ PARAMETER_FIELD
   * **PREDICATE retCompatibility(DATADEP_RET e)**: ∃i, ∃j, e.hasSourceNode.hasOutgoingEdges[i] ∈ ANNO_GLOBAL /\  e.hasSourceNode.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ e.hasDestNode.hasTaint ∈ e.hasSourceNode.hasOutgoingEdges[i].hasDestNode.hasCDF[j].hasFunctTaints.hasRetTaint)
   * **PREDICATE checkCompatibility(Edge e)**: (e ∈ DATADEP_RET /\ retCompatibility(e)) \\/ (e ∈ PARAMETER /\  paramCompatibility(e))
* Resolvable Conflict:
   * **PREDICATE checkEndpointsDif(Edge e)**: e.hasDestinationNode.hasEnclave != e.hasSourceNode.hasEnclave
   * **PREDICATE isResolvableConflict(Edge e)**: checkEndpointsDif(e) /\ checkCompatibility(e)
* Valid Data Flow Partition
   * **PREDICATE checkEndpointsEq(EDGE e)**: e.hasDestinationNode.hasEnclave == e.hasSourceNode.hasEnclave
   * **CONSTRAINT checkControlFlowPart**: ∀ e ∈ EDGE, checkEndpointsEq(e) \\/ isResolvableConflict(e) /\ resolvableConflicts[e] == isResolvableConflict(e) 
***

### Taint propagation

Whereas the previous constraints dealt with the cut, now we ensure that
information that transitively reaches the cut only share information as
authorized.

* The endpoints of every data flow edge must have the same label taint, unless 
  a taint coercion is performed using a blessed function
  * (this constraint causes taint propagation)

* An un-annotated function can have at most one taint within each invocation
  (i.e., this function can preserve a taint, but cannot coerce one taint into
   another)
  
* All taints propagated into an annotated function must match the allowed
  taints respectively coming through body, arguments, or return

* In taint propagation, resolution of a conflict (i.e., taint coercion) can
  only happen within an annotated function

***
* Propogation:
   * **CONSTRAINT checkUnAnnoFunc**: ∀ f ∈ FUNCTIONENTRY,  ∄ i, e.hasDestNode.hasOutgoingEdges[i].hasDestNode.hasCLEJSON /\ |{ c ∈ f.hasChildren |  c.hasTaint  }| <= 1
   * **PREDICATE checkEndpoints(EDGE e)**:  e ∈ DATADEP /\ e.hasDestinationNode.hasTaint == e.hasSourceNode.hasTaint) \\/ (e ∈ PARAMETER /\ e.hasDestinationNode.hasTaint == e.hasSourceNode.hasTaint
   * **PREDICATE CanCoerce(EDGE e)**: ∃i, ∃j, e.hasDestinationNode.hasTaint ∈ e.hasDestinationNode.hasFunction.hasCDF[i].hasFunctTaints.hasBodyTaint /\ e.hasDestinationNode.hasSourceNode.hasTaint ∈ e.hasFunction.hasCDF[j].hasFunctTaints.hasBodyTaint
   * **CONSTRAINT checkPropogation**: ∀ e ∈ DATADEP, checkEndpoints(e) \\/ CanCoerce(e)
***

### Putting it all Together
***
* **CONSTRAINT checkProgram**:  checkControlFlowPart /\ checkPropogation /\ checkUnAnnoFunc /\ CheckAssignmentFunc /\ CheckAssignmentGlobal /\  ∀ fun ∈ FUNCTIONENTRY, assignFunctionEnclave[fun] == fun.hasEnclave /\ ∀ fun ∈ FUNCTIONENTRY, assignFunctionEnclave[fun] == fun.hasEnclave /\ ∀ global ∈ GLOBAL, assignGlobalEnclave[global] == global.hasEnclave
* **OBJECTIVE  minimizeCut**:  min(sum(resolvableConflicts))
***
