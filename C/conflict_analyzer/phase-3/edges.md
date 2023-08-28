# CAPO phase 3 pointer support: New PDG edges

The phase 3 conflict analyzer should correctly partition programs containing both data and function pointers, even when they are aliased, enclosed in struct fields, passed between different functions, or passed to an external function. The phase 3 PDG must include new edges to support the new constraints on the CLE model.

For example programs identifying where the new edges should appear, refer to `capo/C/conflict_analyzer/constraints/phase-3/new-edge-examples`.

## Listing

We introduce the following new edge types:
- `ControlDep_Indirect_CallInv` (indirect function calls via a function pointer)
- `ControlDep_ExternSubgraph`  (over-approximate control dep when a callback is passed to an extern function)
- `DataDepEdge_GlobalDefUse`   (connect def-use dependency between two global variables)
- `DataDepEdge_PointsTo`       (connect data to all of the instructions, variables, and parameters that point to it)
- `DataDepEdge_Indirect_Ret`   (connect a function return value to the call site of an indirect call)
- `Parameter_Indirect_In`      (connect data to its use as a parameter in an indirect call)
- `Parameter_Indirect_Out`     (connect the parameter of an indirect call to corresponding function argument)

## Status

The following edges are exported by `pdg2/phase-3-develop`:
- `ControlDep_Indirect`
- `DataDepEdge_PointsTo`

The following edges are exported by the `pdg2` but should instead be exported by SVF for better coverate:
- `ControlDep_Indirect`

The following edges are not exported nor known to be present in the raw PDG or SVF alias analysis:
- `DataDepEdge_GlobalDefUse`
- `Parameter_Indirect_In`
- `Parameter_Indirect_Out`
- `ControlDep_ExternSubgraph`

## Edge definitions

### ControlDep_Indirect

Let `F` be a function entry node, and let `X` be a call invocation node performing an indirect call. Then there is a `ControlDep_Indirect` edge from `X` to `F` iff:
- There exists some instruction node `Y` which takes the address of of `F`, and the signature of `F` matches the signature of the call invocation at `X`.
- *Stricter requirement*: In addition to the above, `X` is determined to alias any `Y` and make an indirect call to `F` according to a flow sensitive, field-sensitive alias analysis (SVF). Avoids more false positives.

### DataDepEdge_PointsTo

Let `F` be a function with corresponding function entry node, and let `X` be a PDG node which is either:​
- A function entry node​
- A global or module-static var node​
- A var node allocated on the heap or stack by a function `G`, with `G != F`.

Then there is a `DataDepEdge_PointsTo` edge from `F` to `X` iff an instruction in `F` may have access locally to a pointer to `X` (i.e. `F` may have a flow-sensitive, field-sensitive alias to `X` determined by SVF points-to analysis).​

### DataDepEdge_GlobalDefUse

Let `G1` and `G2` be two global variables.

Then there is a `DataDepEdge_GlobalDefUse` edge from `G1` to `G2` if the right hand side of `G2` is an expression which uses `G1`.

### Parameter_Indirect_In

Let `P` be a parameter node in an indirect call invocation. Then for each parameter passed to the call, there is a `Parameter_Indirect_In` edge from the definition of that parameter to `P`.

### Parameter_Indirect_Out

Let `P` be a parameter node in an indirect call invocation to a function `F`. Then for each parameter passed to the call, there is a `Parameter_Indirect_Out` edge from `P` to the corresponding argument of `F`.

### ControlDep_ExternSubgraph

Let `F` be a function which is passed as a pointer to an external function `G` (the definition of `G` is not in the uncompiled source files). Let `H` be the caller of `G`.​ Then there is a `ControlDep_ExternSubgraph` edge from the function entry node of `H` to the function entry node of `F`.​

Alternative definition: There is a `ControlDep_ExternSubgraph` edge from a new `root` node to the function entry node of `F`, and another `ControlDep_ExternSubgraph` edge from the `root` node to the function entry node of `main()`.​

*Concerns*: Which external subgraph edge definition is more correct?​ If the function is aliased before being passed to an external function, how will we insert an edge?​