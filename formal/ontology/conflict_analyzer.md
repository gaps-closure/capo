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

## Addition Input Output Validations
These need to be done by the conflict analyzer, but may not be prudent to overload the constraint solver with these.

* The disposition of every line in the source (C) must be clear: either it goes
  to one enclave (with or without modification), or it is boilerplate
  replicated into all enclaves. The following are necessary but not sufficient:
  - Every node in the PDG is accounted for, i.e., except Annotations every node
    must be assigned to a single valid enclave
  - Every edge in the PDG must be accounted for, it is either in the cut or in
    one of the enclaves
* If multiple (semicolon-separated) C lines cause multiple PDG nodes that must
  go to different enclaves, either the conflict analyzer must keep extent
  information that allows the line to be broken up and disptacher, or provide
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

### Assignment 

* Each function and global variable must be assigned to a single valid enclave, 
  (initially the unlabeled ones will be null)

### Control Flow Partitioning

* Endpoints of a control edge must be assigned to the same enclave, unless if
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
    enclave assigned to the sink endpoint (entry) of the edge
  - the level of the source endpoint of the edge (functioncall) must match one
    the remotelevel of one of the cdfs for the function annotation
  - the corresponding cdf operation must be allow or redact
    (ignore CLE direction field for now)

* How to determine corresponding call return edge(s) for the call edge
  * this is determined from PDG axiomatization

There are additional data flow constraints on parameters on the associated
function which we consider next.

### Data Flow Partitioning

* Endpoints of a data flow edge must be assigned to the same enclave, unless it
  is a resolvable-data-edge-conflict

* To be a resolvable data flow edge conflict
  - The endpoints must be assigned to different enclaves
  - The edge must be be passing an argument to or a return value from the
    function associated with a resolvable-control-flow-edge-conflict
  - For each argument and return the taint of the variable involved must be
    compatible with at least one that is allowed by the corresponding argtaint
    or rettaint 
  - we say 'compatible' in order to account for auto-generated code that
    generates the TAG_ labels

* To be compatible, the arg/ret taints and the taint on the variable affected
  - match their respective level -- remotelevel settings e.g., variable
    annotation ssays okay to send from orange to green, and argtaint says okay
    to receive from orange into green
  - operation must be allow or redact in both cases

### Taint propagation

Whereas the previous constraints dealt with the cut, now we ensure that
information that transitively reaches the cut only share information as
authorized.

* The endpoins of every data flow edge must have the same label taint, unless 
  a taint coercion is performed using a blessed function
  * (this constraint causes taint propagation)

* An un-annotated function can have at most one taint within each invocation
  (i.e., this function can preserve a taint, but cannot coerce one taint into
   another)
  
* All taints propagated into an annotated function must match the allowed
  taints respectively coming through body, arguments, or return

* In taint propagation, resolution of a conflict (i.e., taint coercion) can
  only happen within an annotated function
