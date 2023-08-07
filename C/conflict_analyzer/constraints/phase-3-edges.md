# CAPO function pointer support: PDG edges and constraints on CLE model

As part of CLOSURE Phase 3, CAPO will include support for partitioning programs containing function pointers, as well as other pointer aliases. To accomplish this, CAPO's PDG and CLE constraint model will incorporate the below-listed new edges and constraints, respectively.

For example programs demonstrating the new edges, refer to the `constraints/phase-3-edge-examples` directory.

## New PDG edges

We introduce the following new edge types:
- `ControlDep_Indirect`        (indirect function calls via a function pointer)
- `ControlDep_ExternSubgraph`  (approximate control flow when a callback is passed to an external function)
- `DataDepEdge_FunctionDefUse` (connect a function definition to its use as data)
- `DataDepEdge_PtrAlias`       (connect data to a function that may alias a pointer to it)
- `DataDepEdge_Indirect_Ret`   (connect a function return value to the call site of an indirect call)
- `Parameter_Indirect_In`      (connect data to its use as a parameter in an indirect call)
- `Parameter_Indirect_Out`     (connect the parameter of an indirect call to corresponding function argument)
- `Parameter_Indirect_Field`   (parameter of an indirect function which is a struct field)

### ControlDep_Indirect

Let `F` be a function entry node, and let `X` be a call invocation node performing an indirect call. Then there is a `ControlDep_Indirect` edge from `X` to `F` iff:
- There exists some instruction node `Y` which takes the address of of `F`, and the signature of `F` matches the signature of the call invocation at `X`.
- *Stricter requirement*: In addition to the above, `X` is determined to alias any `Y` and make an indirect call to `F` according to a flow sensitive, field-sensitive alias analysis (SVF). Avoids false positives.

### ControlDep_ExternSubgraph

Let `F` be a function which is passed as a pointer to an external function `G` (the definition of `G` is not in the uncompiled source files). Let `H` be the caller of `G`.​ Then there is a `ControlDep_ExternSubgraph` edge from the function entry node of `H` to the function entry node of `F`.​

Alternative definition: There is a `ControlDep_ExternSubgraph` edge from a new `root` node to the function entry node of `F`, and another `ControlDep_ExternSubgraph` edge from the `root` node to the function entry node of `main()`.​

*Concern*: Which external subgraph edge definition is more correct?​

*Concern*: What if the function is aliased before being passed to an external function, how will we insert an edge?​

### DataDepEdge_FunctionDefUse

Let `F` be a function with corresponding function entry node, and let `X` be an instruction node which takes the address of `F` or otherwise uses `F` as data (i.e. using `F` without invoking it). Then there is a `DataDepEdge_FunctionDefUse` edge from `F` to `X`.

### DataDepEdge_PtrAlias

Let `F` be a function with corresponding function entry node, and let `X` be a PDG node which is either:​
- A function entry node​
- A global or module-static var node​
- A var node allocated on the heap or stack by a function `G`, with `G != F`.

Then there is a `DataDepEdge_PtrAlias` edge from `X` to `F` iff an instruction in `F` has access locally to a pointer to `X`, regardless of whether the pointer value is used (i.e. `F` has a flow-sensitive, field-sensitive alias to `X` determined by SVF points-to analysis).​

### DataDepEdge_Indirect_Ret

Let `X` be a call invocation node which represents an indirect call to a function `F`. Then there is a `DataDepEdge_Indirect_Ret` edge from each return node of `F` to the callsite `X`.

### Parameter_Indirect_In

Let `X` be a call invocation node which represents an indirect call. Then for each parameter passed to the call, there is a `Parameter_Indirect_In` edge from the definition of that parameter to `X`.

### Parameter_Indirect_Out

Let `X` be a call invocation node which represents an indirect call to a function `F`. Then for each parameter passed to the call, there is a `Parameter_Indirect_Out` edge from `X` to the corresponding argument of `F`.

### Parameter_Indirect_Field

TBD

*Concern*: What is `Parameter_Field`?

## New constraints

### The source and destination (caller and callee) of an indirect call invocation edge must be in the same enclave.

`forall (e in ControlDep_Indirect)​ (xdedge(e) == false);​`

*Explanation*: Indirect calls cannot be a part of the cross domain cut.

### The destination node (callee) of an indirect call invocation edge, as well as the function containing the source node, must be un-annotated functions.

```
forall (e in ControlDep_Indirect)
   (userAnnotatedFunction[hasFunction[hasSource[e]]] == false) &&
   (userAnnotatedFunction[hasDest[e]] == false);
```

*Explanation*: The current PDG is missing `Parameter_Indirect` edges for indirect calls, so we cannot analyze taint coercion for indirect calls. We include this band-aid restriction to force indirect callers and callees to be singly tainted, so that parameter analysis is not necessary. The requisite `Parameter_Indirect` edges are included in this document; if they are also added to the PDG, we may be able to constrain them similarly to standard `Parameter` edges and then drop this constraint.

### The source and destination of an external subgraph edge must be in the same enclave.​

`forall (e in ControlDep_ExternSubgraph)​ (xdedge(e) == false);​`

*Explanation*: If a function pointer is ever passed to an external function, we should assume that the external function will invoke that pointer as a callback. Therefore, the caller of the external function and the pointed-to function should be in the same enclave.

### Functions which are used as data must not have a function annotation

`forall (e in DataDepEdge_FunctionDefUse) (userAnnotatedFunction[hasFunction[hasSource[e]]] == false);`

*Explanation*: A def-use edge to a function indicates that a function is being used as data (i.e. it is referenced but not called). When this happens, we restrict the function to be un-annotated.

In the current CLE model, a function taint propagating to a data node is essentially a 'type error' - function labels and data labels are distinct entities. Nevertheless, a function which is used as data must have some taint information propagate to the node using it. **The exact semantics of this has not been decided**, so for now we sidestep the issue by requiring that a function used as data be un-annotated, so that its taint in the CLE model is a data/node taint and not a function taint.

One solution which would allow indirect callees and functions-as-data to be annotated: function labels should be associated with a synthetic data label which has the same level as the function label and is not shareable. This data label should be used instead of the function label for function pointers. This would still pin the function pointer to a level and prevent it from being shared. If the function pointer is ever called, the indirect call edge will re-connect it with a function label, and we can include a special constraint on the indirect call edge to handle it.

### The source and destination of an alias edge must be in the same enclave, with the same taint.​

`forall (e in DataDepEdge_PtrAlias)​ (xdedge(e) == false) && (coerced[e] == false);​`

*Explanation*: The presence of a pointer alias edge indicates that a function has access to some pointed-to data which was not created within the function itself. In order for that pointer to be usable, the function and the pointed-to data must be in the same enclave. In addition, there should be no taint coercion along these edges.

If there is an alias edge to a function pointer, then the above Function_DefUse edge will already constrain the pointed-to function to be un-annotated, so we don't need to duplicate that requirement here.

*Concern*: Do the source and destination taint need to match for these edges? For example, if a multiply tainted function coerces a pointer and passes it to a singly tainted function to use. There will be an edge from the original data to the new function, but the taints may be different. And then, what happens to annotated functions if we drop the "must be un-annotated" constraint from indirect callees and function DefUses?

*Concern*: Are there extra edges associated with struct fields? Or can we follow information in struct fields through field-sensitive alias analysis?

### Indirect parameter edges are coercible via argtaints

```
forall (e in Parameter_Indirect_In union Parameter_Indirect_Out)
    (if      destAnnotFun(e) /\ isParam_ActualIn(hasDest[e])    /\ (hasParamIdx[hasDest[e]]   > 0)
       then coerced[e] == hasArgtaints[edFunCdf(e), hasParamIdx[hasDest[e]],   esTaint(e)]
    elseif sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]] > 0)
       then coerced[e] == hasArgtaints[esFunCdf(e), hasParamIdx[hasSource[e]], edTaint(e)]
    else true endif);
```

*Explanation*: We constrain indirect parameter edges to only allow taint coercion blessed by the argtaints, as with direct parameter edges. The inclusion of this constraint, together with the following three constraints and the associated `Parameter_Indirect` and `DataDepEdge_Indirect_Ret` edges, would allow us to remove the no-annotation constraint on indirect calls.

This constraint can be omitted if `Parameter_Indirect` edges are included in the `Parameter` edge set unions.

### Indirect parameter edges may not be cross-domain

`forall (e in Parameter_Indirect)​ (xdedge(e) == false);​`

*Explanation*: In addition to the above constraint on all parameters, indirect parameters should not ever be cross-domain, since indirect calls are not allowed to be cross-domain.

### Indirect return edges are coercible via rettaints

```
forall (e in DataDepEdge_Indirect_Ret) 
    (coerced[e] == (if sourceAnnotFun(e) then hasRettaints[esFunCdf(e), edTaint(e)] else false endif));
```

*Explanation*: We constrain return edges from indirect calls to only allow taint coercion blessed by the rettaints, as with return data edges from direct calls.

This constraint can be omitted if the `DataDepEdge_Indirect_Ret` edges are included in the `DataDepEdge_Ret` edge set.

### Indirect return edges may not be cross-domain

`forall (e in DataDepEdge_Indirect_Ret)​ (xdedge(e) == false);​`

*Explanation*: In addition to the above constraint on all return edges, indirect returns should not ever be cross-domain, since indirect calls are not allowed to be cross-domain.