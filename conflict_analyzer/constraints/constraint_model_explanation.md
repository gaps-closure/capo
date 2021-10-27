# Constraint model for CLE for PDG based on C/LLVM

## Preliminaries

### GAPS and CLOSURE
DARPA Guarantted Architecrture for Phsysical Systems (GAPS) is a research program 
that  addresses software and hardware for compartmentalized applications where
multiple parties with strong physical isolation of their computational
environment, have specific constraints on data sharing (possibly with redaction
requirements) with other parties, and any data exchange between the parties is
mediated through a guard that enforces the security requirements.

Peraton Labs' Cross-domain Language extensions for Optimal SecUre Refactoring
and Execution (CLOSURE) project is building a toolchain to support the
development, refactoring, and correct-by-construction partitioning of
applications and configuration of the guards. Using the CLOSURE approach and
toolchain, developers will express security intent through annotations applied
to the program, which drive the program analysis, partitioning, and code
autogeneration required by a GAPS application.

### CLOSURE Language Extensions and Program Dependency Graph

Developers annotate programs using CLOSURE Language Extensions (CLE) to specify
cross-domain security constraints. Each CLE annotation definition associates
a _CLE label_ (a symbol) with a _CLE JSON_ which provides detailed specification
of cross-domain data sharing and function invocation constraints.

In CLOSURE, _Levels_ are arbitrary symbols specifying sensitivity levels.
Levels in GAPS are not ordered (unlike, for example, CALIPSO Sensitivity
Levels). _Enclaves_ are isolated compartments with computation and memory
reources. Each enclave operates at a specified level. Enclaves at the same
level may be connected by a network, but enclaves at different levels must be
connected through a cross-domain guard (also known as SDH or TA-1 hardware
within the GAPS program).

The user can apply _node annotations_ to local or global variables; through the
associated CLE-JSON, the user can constrain which level the data can reside,
and with which (enclaves at) other levels, the data can be shared. The user 
will typically annotate only a subset of variables, and the entailed constraints 
will be propagated by the solver. (In future versions of CLE, the user can
specify enclave preferences as well, such as assign to an enclave which has
a GPU, but this is currently not supported.)

The user can apply _function annotations_ to selected functions; the user will
do so after auditing the function and explicity allow the function to be called
from enclaves at other levels, and also explicitly constrain the allowed taints
on the arguments, return value and code body through the CLE JSON of the
function annotation. Through the function annotation the user specifies that
data with the allowed taints (CLE labels they are explicitly tagged with or
propagated through the model) can be handled (coerced) by the function. The user
also constrains the level of the enclave to which the function must be assigned
to (this could be due to the sensitivity of the data touched by the function,
but in some cases the algorithm implemented by the code body itself may be 
sensitive). The user will typically annotate only a subset of functions, and 
the entailed constraints will be propagated by the solver.

The model uses the Program Dependency Graph (PDG) abstraction of the
CLE-annotated LLVM IR generated from the annotated C program. The PDG node
types are Inst (instructions), VarNode (global, static, or module static
variables), FunctionEntry (function entry points), Param (nodes denoting
actual and formal parameters for input and output), and Annotation (LLVM IR
annotation nodes, a subset of which will be CLE labels).  The PDG edge types
include ControlDep (control dependency edges), DataDep (data dependency edges),
Parameter (parameter edges relating to input params, output params, or
parameter field edges to encode parameter trees), and Annot (edges that connect
a non-annotation PDG node to an LLVM annotation node).  Each of these node and
edge types are further divided into subtypes. 

See the PSU [PDG documentation](https://github.com/gaps-closure/pdg2/tree/develop/Edge_Specification) and 
CLOSURE [CLE documentation](https://github.com/gaps-closure/mules/tree/develop/cle-spec) 
for further details about them.

### Role of the Contraint Solver

In CLOSURE, we use a constraint solver to perform program analysis and 
determine a correct-by-construction partition that satifies the constraints
specified by the developer using CLE annotations. The constraint solver
takes three items as input: (i) the PDG constructed from the linked LLVM 
IR of the annotated C program, (ii) the CLE JSON corresponding to the CLE 
labels used in the annotated program, and (iii) the enclave topology including
the set of enclaves, and the level of each enclave (future versions of the
topology may include network and cross-domain-guard interconnections between
the enclaves and the computational resources available within each enclave).

The constraint solver must assign each function and global variable in the
program to an enclave subject to constraints entailed on the program by CLE
annotations as specified in the Minizinc model excerpt below. Additionally,
upon satisfaction, the solver will assign a CLE enclave and CLE label to every
PDG node that is not an LLVM annotation node. It will also identify the PDG
call invocation edges that are in the cross-domain cut, i.e., the caller
(callsite) and callee (function entry) belong to different enclaves.

In the model below, the `nodeEnclave` decision variable stores the enclave
assignment for each node, the `taint` decision variable stores the label
assignment for each node, and the `xdedge` decision variable stores whether a
given edge is in the enclave cut (i.e., the source and destination nodes of the
edge are in different enclaves. Several other auxiliary decision variables are
used in the constraint model to express the constraints or for efficient
compilation. They are described later in the model.

The solver will assign a node annotation label (rather than a function
annotation which only the user can assign) to functions not annotated by the
user. Such functions cannot be invoked cross-domain, and across all
invocations, they must be singly tainted. In other words, arguments, return,
and function body can contain or touch nodes that match the taint.  

Downstream tools in the CLOSURE toolchain will use the output of the solver to
physically partition the code, and after further analysis (for example, to
determine whether each parameter is an input, output, or both, and the size of
the parameter), the downstream tools will autogenerate code for marshalling and
serialization of input and output/return data for the cross-domain call, as
well as code for invocation and handling of cross-domain remote-procedure calls
that wrap the function invocations in the cross-domain cut. 

## Constraint Model in MiniZinc

We encode the constraint model for CLE for C/LLVM programs using the 
[MiniZinc](https://www.minizinc.org/doc-2.5.5/en/index.html) Domain 
Specific Language (version 2.5.5). MiniZinc provides a high level
language abstraction to express constraint solving problems clearly.
MiniZinc compiles a MiniZinc language specification of a problem for 
lower level solver such as Gecode. We use an Integer Logic Program (ILP) 
formulation with MiniZinc. MiniZinc also includes a tool that computes
the minimum unsatisfiable subset (MUS) of constraints if a problem
instance is unsatisfiable; the output of this tool can be used to
provide diagnostic feedbakc to the user to help refactor the program.

The constraint model below can be adapted to other solvers, for example,
the Z3 theorem prover, which is based on Sastisfiability-Modulo-Theories
(SMT).

### General Constraints on Output and Auxiliary Decision Variables

Every global variable and function entry must be assigned to a valid enclave.
Instructions and parameters are assigned the same enclave as their containing
functions.  Annotations can not assigned to a valid enclave and they must be
assigned to `nullEnclave`.

```
constraint :: "VarNodeHasEnclave"               forall (n in VarNode)            (nodeEnclave[n]!=nullEnclave);
constraint :: "FunctionHasEnclave"              forall (n in FunctionEntry)      (nodeEnclave[n]!=nullEnclave);
constraint :: "InstHasEnclave"                  forall (n in Inst)               (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "ParamHasEnclave"                 forall (n in Param)              (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "AnnotationHasNoEnclave"          forall (n in Annotation)         (nodeEnclave[n]==nullEnclave);
```

The level of every node that is not an annotation stored in the `nodeLevel`
decision variable must match:
 * the level of the label (taint) assigned to the node
 * the level of the enclave the node is assigned to 

```
constraint :: "NodeLevelAtTaintLevel"           forall (n in NonAnnotation)      (nodeLevel[n]==hasLabelLevel[taint[n]]);
constraint :: "NodeLevelAtEnclaveLevel"         forall (n in NonAnnotation)      (nodeLevel[n]==hasEnclaveLevel[nodeEnclave[n]]);
```

Only function entry nodes can be assigned a function annotation label.
Furthermore, only the user can bless a function with a function annotation 
(that gets be passed to the solver through the input).  

```
constraint :: "FnAnnotationForFnOnly"           forall (n in NonAnnotation)      (isFunctionAnnotation[taint[n]] -> isFunctionEntry(n));
constraint :: "FnAnnotationByUserOnly"          forall (n in FunctionEntry)      (isFunctionAnnotation[taint[n]] -> userAnnotatedFunction[n]);
```

Set up a number of auxiliary decision variables:
 * `ftaint[n]`: CLE label taint of the function containing node `n`
 * `esEnclave[e]`: enclave assigned to the source node of edge `e`
 * `edEnclave[e]`: enclave assigned to the destination node of edge `e`
 * `xdedge[e]`: source and destination nodes of `e` are in different enclaves
 * `esTaint[e]`: CLE label taint of the source node of edge `e`
 * `edTaint[e]`: CLE label taint of the destination node of edge `e`
 * `tcedge[e]`: source and destination nodes of `e` have different CLE label taints
 * `esFunTaint[e]`: CLE label taint of the function containing source node of edge `e`, `nullCleLabel` if not applicable
 * `edFunTaint[e]`: CLE label taint of the function containing destination node of edge `e`, `nullCleLabel` if not applicable
 * `esFunCdf[e]`: if the source node of the edge `e` is an annotated function, then this variable stores the CDF with the remotelevel equal to the level of the taint of the destination node; `nullCdf` if a valid CDF does not exist
 * `edFunCdf[e]`: if the destination node of the edge `e` is an annotated function, then this variable stores the CDF with the remotelevel equal to the level of the taint of the source node; `nullCdf` if a valid CDF does not exist

```
constraint :: "MyFunctionTaint"                 forall (n in PDGNodeIdx)         (ftaint[n] == (if hasFunction[n]!=0 then taint[hasFunction[n]] else nullCleLabel endif));
constraint :: "EdgeSourceEnclave"               forall (e in PDGEdgeIdx)         (esEnclave[e]==nodeEnclave[hasSource[e]]);
constraint :: "EdgeDestEnclave"                 forall (e in PDGEdgeIdx)         (edEnclave[e]==nodeEnclave[hasDest[e]]);
constraint :: "EdgeInEnclaveCut"                forall (e in PDGEdgeIdx)         (xdedge[e]==(esEnclave[e]!=edEnclave[e]));
constraint :: "EdgeSourceTaint"                 forall (e in PDGEdgeIdx)         (esTaint[e]==taint[hasSource[e]]);
constraint :: "EdgeDestTaint"                   forall (e in PDGEdgeIdx)         (edTaint[e]==taint[hasDest[e]]);
constraint :: "EdgeTaintMismatch"               forall (e in PDGEdgeIdx)         (tcedge[e]==(esTaint[e]!=edTaint[e]));
constraint :: "SourceFunctionAnnotation"        forall (e in PDGEdgeIdx)         (esFunTaint[e] == (if sourceAnnotFun(e) then taint[hasFunction[hasSource[e]]] else nullCleLabel endif));
constraint :: "DestFunctionAnnotation"          forall (e in PDGEdgeIdx)         (edFunTaint[e] == (if destAnnotFun(e) then taint[hasFunction[hasDest[e]]] else nullCleLabel endif));
constraint :: "SourceCdfForDestLevel"           forall (e in PDGEdgeIdx)         (esFunCdf[e] == (if sourceAnnotFun(e) then cdfForRemoteLevel[esFunTaint[e], hasLabelLevel[edTaint[e]]] else nullCdf endif));
constraint :: "DestCdfForSourceLevel"           forall (e in PDGEdgeIdx)         (edFunCdf[e] == (if destAnnotFun(e) then cdfForRemoteLevel[edFunTaint[e], hasLabelLevel[esTaint[e]]] else nullCdf endif));
```

If a node `n` is contained in an unannotated function then the CLE label taint
assigned to the node must match that of the containing function. In other
words, since unannotated functions must be singly tainted, all noded contained
within the function must have the same taint as the function.

```
constraint :: "UnannotatedFunContentTaintMatch" forall (n in NonAnnotation where hasFunction[n]!=0) (userAnnotatedFunction[hasFunction[n]]==false -> taint[n]==ftaint[n]);
```

If the node `n` is contained in an user annotated function, then the CLE label
taint assigned to the node must be allowed by the CLE JSON of the function
annotation in the argument taints, return taints, or code body taints. In other
words, any node contained within a function blessed with a function-annotation
by the user can only contain nodes with taints that are explicitly permitted
(to be coerced) by the function annotation.

```
constraint :: "AnnotatedFunContentCoercible"    forall (n in NonAnnotation where hasFunction[n]!=0 /\ isFunctionEntry(n)==false) (userAnnotatedFunction[hasFunction[n]] -> isInArctaint(ftaint[n], taint[n], hasLabelLevel[taint[n]]));
```

### Constraints on the Cross-Domain Control Flow

The control flow can never leave an enclave, unless it is done through an
approved cross-domain call, as expressed in the following three constraints.
The only control edges allowed in the cross-domain cut are either call
invocations or returns. For any call invocation edge in the cut, the function
annotation of the function entry being called must have a CDF that allows (with
or without redaction) the level of the label assigned to the callsite.  The
label assigned to the callsite must have a node annotation with a CDF that
allows the data to be shared with the level of the (taint of the) function
entry being called.

```
constraint :: "NonCallControlEnclaveSafe"      forall (e in ControlDep_NonCall where isAnnotation(hasDest[e])==false) (xdedge[e]==false);
constraint :: "XDCallBlest"                    forall (e in ControlDep_CallInv) (xdedge[e] -> userAnnotatedFunction[hasDest[e]]);
constraint :: "XDCallAllowed"                  forall (e in ControlDep_CallInv) (xdedge[e] -> allowOrRedact(cdfForRemoteLevel[edTaint[e], hasLabelLevel[esTaint[e]]]));
```

Notes: 
  1. No additional constraint is needed for control call return edges; checking
     the corresponding call invocation suffices, however, later on we will check the
     data return edge when checking label coercion.  
  2. The conflict analyzer is working with the annotated unpartitioned
     code and not the fully partitioned code which will includes autogenerated
     code. The actual cut in the partitioned code with autogenerated code to
     handle cross-domain communications will be between the cross-domain send 
     and receive functions that are several steps removed from the cut in the
     `xdedge` variable at this stage of analysis. The autogenerated code will 
     apply annotations to cross-domain data annotations that contain GAPS tags,
     and they will have a different label. So we cannot check whether the label 
     of the arguments passed from the caller matches the argument taints allowed by
     the called function, or if the return taints match the value to which the 
     return value is assigned. A downstream verification tool will check this.

### Constraints on the Cross-Domain Data Flow

Data can only leave an enclave through parameters or return of valid
cross-domain call invocations, as expressed in the following three constraints. 

Any data dependency edge that is not a data return cannot be in the
cross-domain cut.  For any data return edge in the cut, the taint of the source
node (the returned value in the callee) must have a CDF that allows the data to
be shared with the level of the taint of the destination node (the return site 
in the caller). For any parameter passing edge in the cut, the taint of the source
node (what is passed by the callee) must have a CDF that allows the data to be
shared with the level of the taint of the destination node (the corresponding
actual parameter node of the callee function).

```
constraint :: "NonRetNonParmDataEnclaveSafe"   forall (e in DataEdgeNoRet)      (xdedge[e]==false);
constraint :: "XDCDataReturnAllowed"           forall (e in DataDepEdge_Ret)    (xdedge[e] -> allowOrRedact(cdfForRemoteLevel[esTaint[e], hasLabelLevel[edTaint[e]]]));
constraint :: "XDCParmAllowed"                 forall (e in Parameter)          (xdedge[e] -> allowOrRedact(cdfForRemoteLevel[esTaint[e], hasLabelLevel[edTaint[e]]]));
```

### Taint coercion constraints within each enclave

Labels can be cooerced inside an enclave only through user annotated functions.
To track valid label coercion across a PDG edge `e`, the model uses an additional 
auxiliary decision variable called `coerced[e]`.

Any data dependency or parameter edge that is intra-enclave (not in the
cross-domain cut) and with different CLE label taints assigned to the source
and destination nodes must be coerced (through an annotated function).

Note: one may wonder whether a similar constraint must be added for control 
dependency edges at the entry block for completeness. Such a constraint is 
not necessary given our inclusion of the `UnannotatedFunContentTaintMatch` and
`AnnotatedFunContentCoercible` constraints discussed earlier. 
```
constraint :: "TaintsSafeOrCoerced"            forall (e in DataEdgeParam)      ((tcedge[e] /\ (xdedge[e]==false)) -> coerced[e]);

```

If the edge is a paremeter in or parameter out edege, then it can be coerced if
and only if the associated function annotation has the taint of the other node
in the argument taints for the corresponding parameter index. In other words,
what is passed in through this parameter has a taint allowed by the function
annotation.
```
constraint :: "ArgumentTaintCoerced"
 forall (e in Parameter_In union Parameter_Out)
  (if     destAnnotFun(e)   /\ isParam_ActualIn(hasDest[e])    /\ (hasParamIdx[hasDest[e]]>0)
   then coerced[e] == hasArgtaints[edFunCdf[e], hasParamIdx[hasDest[e]], esTaint[e]]
   elseif sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]]>0)
   then coerced[e] == hasArgtaints[esFunCdf[e], hasParamIdx[hasSource[e]], edTaint[e]]
   else true 
   endif);
```

If the edge is a data return edge, then it can be coerced if and only if the
associated function annotation has the taint of the other node in the return
taints.
```
constraint :: "ReturnTaintCoerced"            forall (e in DataDepEdge_Ret)     (coerced[e] == (if sourceAnnotFun(e) then hasRettaints[esFunCdf[e], edTaint[e]] else false endif));
```

If the edge is a data dependency edge (and not a return or parameter edge),
then it can be coerced if and only if the associated function annotation allows
the taint of the other node in the argument taints of any parameter, 

Note that this constraint might appear seem redundant given the
`AnnotatedFunContentCoercible` constraint discussed earlier. On closer
inspection we can see that the following constraint also includes edges 
between nodes in the function and global/static variables; the earlier 
constraint dows not. There is overlap between the constraints, so some
refinement is possible, which may make the model a little harder to understand.

```
constraint :: "DataTaintCoerced"
 forall (e in DataEdgeNoRetParam)
  (if (hasFunction[hasSource[e]]!=0 /\ hasFunction[hasDest[e]]!=0 /\ hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
   then coerced[e] == (isInArctaint(esFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]) /\
                       isInArctaint(esFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]))     % source and dest taints okay
   elseif (isVarNode(hasDest[e]) /\ hasFunction[hasSource[e]]!=0)
   then coerced[e] == (isInArctaint(esFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]) /\
                       isInArctaint(esFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]))
   elseif (isVarNode(hasSource[e]) /\ hasFunction[hasDest[e]]!=0)
   then coerced[e] == (isInArctaint(edFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]) /\
                       isInArctaint(edFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]))
   else coerced[e] == false
   endif);
```

### Solution objective

In this model, we require the solver to provide a satisfying assignment that
minimizes the total number of call invocation that are in the cross-domain cut.
Other objectives could be used instead.

```
var int: objective = sum(e in ControlDep_CallInv where xdedge[e])(1);
solve minimize objective;
```

