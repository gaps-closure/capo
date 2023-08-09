# CAPO phase 3 pointer support: New PDG edges

The phase 3 conflict analyzer should correctly partition programs containing both data and function pointers, even when they are aliased, enclosed in struct fields, passed between different functions, or passed to an external function. The phase 3 PDG must include new edges to support the new constraints on the CLE model.

For example programs identifying where the new edges should appear, refer to `capo/C/conflict_analyzer/constraints/phase-3/new-edge-examples`.

## Listing

We introduce the following new edge types:
- `ControlDep_Indirect`        (indirect function calls via a function pointer)
- `ControlDep_ExternSubgraph`  (over-approximate control dep when a callback is passed to an extern function)
- `DataDepEdge_FunctionDefUse` (connect a function definition to its use as data)
- `DataDepEdge_Inst_PtrAlias`  (connect data to a function whose instructions may alias a pointer to it)
- `DataDepEdge_Param_PtrAlias` (connect data to a function whose parameters may alias a pointer to it)
- `DataDepEdge_Ret_PtrAlias`   (connect data to a function whose return values may alias a pointer to it)
- `DataDepEdge_Indirect_Ret`   (connect a function return value to the call site of an indirect call)
- `Parameter_Indirect_In`      (connect data to its use as a parameter in an indirect call)
- `Parameter_Indirect_Out`     (connect the parameter of an indirect call to corresponding function argument)
- `Parameter_Indirect_Field`

## Status

The following edges are exported by `pdg2/phase-3-develop`:
- `ControlDep_Indirect`

The following edges are not exported but known to be present in the raw PDG or SVF's flow-sensitive, field-sensitive alias analysis:
- N/A

The following edges are not exported nor known to be present in the raw PDG or SVF alias analysis:
- `DataDepEdge_FunctionDefUse`
- `DataDepEdge_Inst_PtrAlias`
- `DataDepEdge_Param_PtrAlias`
- `DataDepEdge_Ret_PtrAlias`
- `DataDepEdge_Indirect_Ret`
- `Parameter_Indirect_In`
- `Parameter_Indirect_Out`
- `Parameter_Indirect_Field`
- `ControlDep_ExternSubgraph`

## Edge definitions

### ControlDep_Indirect

Let `F` be a function entry node, and let `X` be a call invocation node performing an indirect call. Then there is a `ControlDep_Indirect` edge from `X` to `F` iff:
- There exists some instruction node `Y` which takes the address of of `F`, and the signature of `F` matches the signature of the call invocation at `X`.
- *Stricter requirement*: In addition to the above, `X` is determined to alias any `Y` and make an indirect call to `F` according to a flow sensitive, field-sensitive alias analysis (SVF). Avoids more false positives.

### ControlDep_ExternSubgraph

Let `F` be a function which is passed as a pointer to an external function `G` (the definition of `G` is not in the uncompiled source files). Let `H` be the caller of `G`.​ Then there is a `ControlDep_ExternSubgraph` edge from the function entry node of `H` to the function entry node of `F`.​

Alternative definition: There is a `ControlDep_ExternSubgraph` edge from a new `root` node to the function entry node of `F`, and another `ControlDep_ExternSubgraph` edge from the `root` node to the function entry node of `main()`.​

*Concerns*: Which external subgraph edge definition is more correct?​ If the function is aliased before being passed to an external function, how will we insert an edge?​

### DataDepEdge_FunctionDefUse

Let `F` be a function with corresponding function entry node, and let `X` be an instruction node which takes the address of `F` or otherwise uses `F` as data (i.e. referencing `F` without invoking it). Then there is a `DataDepEdge_FunctionDefUse` edge from `F` to `X`.

### DataDepEdge_Inst_PtrAlias

Let `F` be a function with corresponding function entry node, and let `X` be a PDG node which is either:​
- A function entry node​
- A global or module-static var node​
- A var node allocated on the heap or stack by a function `G`, with `G != F`.

Then there is a `DataDepEdge_Inst_PtrAlias` edge from `X` to `F` iff an instruction in `F` may have access locally to a pointer to `X` (i.e. `F` may have a flow-sensitive, field-sensitive alias to `X` determined by SVF points-to analysis).​

### DataDepEdge_Param_PtrAlias

Let `F` be a function with corresponding function entry node, and let `X` be a PDG node which is either:​
- A function entry node​
- A global or module-static var node​
- A var node allocated on the heap or stack by a function `G`, with `G != F`.

Then there is a `DataDepEdge_Param_PtrAlias` edge from `X` to `F` iff a parameter of `F` may alias a pointer to `X` or has a field which points to `X`.

### DataDepEdge_Ret_PtrAlias

Let `F` be a function with corresponding function entry node, and let `X` be a PDG node which is either:​
- A function entry node​
- A global or module-static var node​
- A var node allocated on the heap or stack by a function `G`, with `G != F`.

Then there is a `DataDepEdge_Ret_PtrAlias` edge from `X` to `F` iff a return value of `F` may alias a pointer to `X` or has a field which points to `X`.

### DataDepEdge_Indirect_Ret

Let `X` be a call invocation node which represents an indirect call to a function `F`. Then there is a `DataDepEdge_Indirect_Ret` edge from each return node of `F` to the callsite `X`.

### Parameter_Indirect_In

Let `P` be a parameter node in an indirect call invocation. Then for each parameter passed to the call, there is a `Parameter_Indirect_In` edge from the definition of that parameter to `P`.

### Parameter_Indirect_Out

Let `P` be a parameter node in an indirect call invocation to a function `F`. Then for each parameter passed to the call, there is a `Parameter_Indirect_Out` edge from `P` to the corresponding argument of `F`.

### Parameter_Indirect_Field

TODO: What is `Parameter_Field`?