# CAPO phase 3 pointer support: New PDG edges

The phase 3 conflict analyzer should correctly partition programs containing both data and function pointers, even when they are aliased, enclosed in struct fields, passed between different functions, or passed to an external function. The phase 3 PDG must include new edges to support the new constraints on the CLE model. For example programs in which the new edges appear, refer to `capo/C/conflict_analyzer/constraints/phase-3/tests`.

## Quick Status Summary

| Edge | Status in pdg2/phase-3-develop |
| --- | --- |
| `ControlDep_CallInv`  | Legacy PDG export | 
| `DataDepEdge_Ret` | Legay PDG export |
| `Parameter_In` | Legacy PDG export, no longer constrained (see `Argpass_In`) |
| `Parameter_Out` | Legacy PDG export, no longer constrained (see `Argpass_Out`) |
| `DataDepEdge_DefUse` | Legacy PDG export, we care about edges leaving function |
| `DataDepEdge_DefUseGlobal` | *MISSING*: New PDG export for data dependencies between globals |
| `DataDepEdge_PointsTo` | New SVF export, using Andersen, we care about edges leaving function, subtype by heap, stack, function-static, global (includes global-to-global edges) |
| `ControlDep_Indirect_CallInv` | New PDG export which over-approximates set of candidate indirect callees for each indirect callsite |
| `DataDepEdge_Indirect_Ret` | New PDG export, mimics `DataDepEdge_Ret` for indirect calls |
| `Argpass_In` | New PDG export which replaces `Parameter_In` edges with the relevant inter-function subset |
| `Argpass_Out` | New PDG export which replaces `Parameter_Out` edges with the relevant inter-function subset |
| `Argpass_Indirect_In` | New PDG export which mimics `Argpass_In` edges for indirect calls |
| `Argpass_Indirect_Out` | New PDG export which mimics `Argpass_Out` edges for indirect calls |
| `ControlDep_ExternSubgraph` | *MISSING* |
| Other | Varargs, Struct literal args, long jumps, etc. are TBD |

Note: All nodes are legacy export from PDG, and nodes in SVF model are aligned to the PDG nodes. Export from PDG includes additional information such as maximum number of parameters functions in the LLVM IR, CLE annotations, constraints, parameter index, source-level debug references, etc.

## Phase 3 new edge definitions

### ControlDep_Indirect_CallInv

Let `F` be a function entry node, and let `X` be a call invocation node performing an indirect call. Then there is a `ControlDep_Indirect` edge from `X` to `F` iff:
- There exists some instruction node `Y` which takes the address of of `F`, and the signature of `F` matches the signature of the call invocation at `X`.
- *Stricter requirement*: In addition to the above, `X` is determined to alias any `Y` and make an indirect call to `F` according to a flow sensitive, field-sensitive alias analysis (SVF). Avoids more false positives.

### DataDepEdge_PointsTo

Let `F` be a function with corresponding function entry node, and let `X` be a PDG node which is either:​
- A function entry node​
- A global or module-static var node​
- A var node allocated on the heap or stack by a function `G`, with `G != F`.

Then there is a `DataDepEdge_PointsTo` edge from `F` to `X` iff an instruction in `F` may have access locally to a pointer to `X` (i.e. `F` may have a alias to `X` determined by SVF points-to analysis).​

### DataDepEdge_GlobalDefUse

Let `G1` and `G2` be two global variables.

Then there is a `DataDepEdge_GlobalDefUse` edge from `G1` to `G2` if the right hand side of `G2` is an expression which uses `G1`.

### Argpass_In

Let `P` be a `Param_ActualIn` node associated with a function `F`. Then for each direct callsite of `F`, there is an `Argpass_In` edge from the corresponding argument passed to the call of `F` to `P`.

### Argpass_Out

Let `P` be a `Param_ActualOut` node associated with a function `F`. Then for each direct callsite of `F`, there is an `Argpass_Out` edge from `P` to the corresponding argument passed to the call of `F`.

### Argpass_Indirect_In

Let `P` be a `Param_ActualIn` node associated with a function `F`. Then for each candidate indirect callsite of `F`, there is an `Argpass_Indirect_In` edge from the corresponding argument passed to the call of `F` to `P`.

### Argpass_Indirect_Out

Let `P` be a `Param_ActualOut` node associated with a function `F`. Then for each candidate indirect callsite of `F`, there is an `Argpass_Indirect_Out` edge from `P` to the corresponding argument passed to the call of `F`.

### DataDepEdge_Indirect_Ret

Edge from return node of an indirect callee to the indirect callsite.

### ControlDep_ExternSubgraph

Let `F` be a function which is passed as a pointer to an external function `G` (the definition of `G` is not in the uncompiled source files). Let `H` be the caller of `G`.​ Then there is a `ControlDep_ExternSubgraph` edge from the function entry node of `H` to the function entry node of `F`.​

Alternative definition: There is a `ControlDep_ExternSubgraph` edge from a new `root` node to the function entry node of `F`, and another `ControlDep_ExternSubgraph` edge from the `root` node to the function entry node of `main()`.​

*Concerns*: Which external subgraph edge definition is more correct?​ If the function is aliased before being passed to an external function, how will we insert an edge?​
