# CAPO phase 3 pointer support: New CLE model constraints

The phase 3 conflict analyzer should correctly partition programs containing both data and function pointers, even when they are aliased, enclosed in struct fields, passed between different functions, or passed to an external function. We propose new constraints to the CLE model to accomplish this.

## Listing

1. The caller and callee of an indirect call (via a function pointer) must be in the same enclave.
2. If a function is passed as a pointer to an external function, both the pointed-to function and the caller of the external function must be in the same enclave.
3. If any instruction in a function `F` has a pointer alias to some data `D`, then `D` must be in the same enclave as `F`, with a taint in the ARCtaints of `F`. `D` may be any of:
    - A pointer to a global variable.
    - A function pointer.
    - A pointer to a heap or stack allocation made in a different function
    - A struct containing any of the above.
4. With respect to indirect calls:
    - **Restrictive**: The caller and callee must be un-annotated functions.
    - **Expanded**: The parameters and return are subject to the same taint coercion requirements as direct calls, and may not be cross-domain.
5. With respect to functions used as data:
    - **Restrictive**: A function used as data must not have a function annotation, and its taint should propagate to the instruction using it.
    - **Expanded**: A function used as data should propagate a taint to the instruction using it:
        - If the function is un-annotated, the taint on the instruction should be the function taint.
        - If the function is annotated, the taint on the instruction should be a synthetic, non-shareable data taint with the same level as the function annotation.

For constraints 4 and 5, either the restrictive or expanded constraint may be used (not both). The restrictive constraints overly constrain the CLE model but are easier to reason about and require less invasive changes. In particular, the expanded constraint 5 defines a semantics for function taints propagating to data nodes which currently does not exist in the CLE model.

## Status

In the current phase 3 constraint model (`capo/phase-3-develop`):
- **Enforced**: 1.
- **Not Enforced**: 2, 3, 4, 5.

## Constraint details

### 1. The caller and callee of an indirect call (via a function pointer) must be in the same enclave.

*Explanation*: Indirect calls may not be a part of the cross domain cut.

*Required PDG Edges*:
- `ControlDep_Indirect`: A control edge between the call invocation node and the function entry node of an indirect call.

*Sample MZN Encoding*:
```
1-a. forall (e in ControlDep_Indirect)​ (xdedge(e) == false);​
```

### 2. If a function is passed as a pointer to an external function, both the pointed-to function and the caller of the external function must be in the same enclave.

*Explanation*: If a function pointer is ever passed to an external function, we must conservatively assume that the external function will invoke that pointer as a callback. Therefore, the caller of the external function and the pointed-to function should be in the same enclave.

*Required PDG Edges*:
- `ControlDep_ExternSubgraph`: A control edge between the call invocation node node of an external function and the function entry node of every function which is passed to the external function as a parameter.

*Sample MZN Encoding*:
```
2-a. forall (e in ControlDep_ExternSubgraph)​ (xdedge(e) == false);
```

### 3. If any instruction in a function `F` has a pointer alias to some data `D`, then `D` must be in the same enclave as `F`, with a taint in the ARCtaints of `F`.

*Explanation*: If a function `F` has access to a pointer to data `D` which was created outside outside the scope of `F`, be it a global variable, a function, data on the heap, or data on another function's stack, we must ensure that the pointer is valid in the function's enclave and that the taint of `D` propagates to `F`. So we constrain `D` and `F` to be in the same enclave, and for the taint of `D` to be allowed by the function taint of `F`. **Note**: If `5E` is implemented, an alias edge representing a pointer to an annotated function must receive special treatment. See the details of `5E`.

*Required PDG Edges*:
- `DataDepEdge_PtrAlias`: An edge from `D` to `F` iff an instruction in `F` has access locally to a pointer to `X`, regardless of whether the pointer value is used (i.e. an instruction in `F` has a flow-sensitive, field-sensitive alias to `X` determined by SVF points-to analysis).​

*Sample MZN Encoding*:
```
3-a. forall (e in DataDepEdge_PtrAlias)​ (xdedge(e) == false) && (coerced[e] == false);
```

### 4R. The caller and callee of an indirect call must be un-annotated functions with the same taint.

*Explanation*: Allowing the callee or caller of an indirect call to be annotated requires that we analyze the taint coercion of the callee's parameter and return edges, which are not currently in the PDG. This restriction forces indirect callers and callees to be singly tainted and propagates taints between them, so that parameter analysis and the associated edges ares not necessary.

*Required PDG Edges*:
- `ControlDep_Indirect`: A control edge between the call invocation node and the function entry node of an indirect call.

*Sample MZN Encoding*:
```
4R-a. forall (e in ControlDep_Indirect)
        (userAnnotatedFunction[hasFunction[hasSource[e]]] == false) &&
        (userAnnotatedFunction[hasDest[e]] == false) &&
        (coerced[e] == false);
```

### 4E. The parameters and return of an indirect call are subject to the same taint coercion requirements as direct calls, and may not be cross-domain.

*Explanation*: If we have parameter and return edges for indirect calls, we can subject those edges to the same taint coercion constraints as for direct calls, and allow indirect callers and callees to have function annotations. Indirect parameter and return edges must also not be cross domain, since the indirect calls themselves are not cross domain.

*Required PDG Edges*:
- `Parameter_Indirect_In`: Edges between indirect call parameter nodes and the definition of each of parameters.
- `Parameter_Indirect_Out`: Edges between indirect call parameter nodes and the arguments of the callee function.
- `Parameter_Indirect_Field`: TODO
- `DataDepEdge_Indirect_Ret`: Edges from each of an indirect callee's return statements to the indirect call invocation.

*Sample MZN Encoding*:
```
4E-a. forall (e in Parameter_Indirect)​ (xdedge(e) == false);​

4E-b. forall (e in DataDepEdge_Indirect_Ret)​ (xdedge(e) == false);

% Can be omitted if `Parameter_Indirect` edges are included in the `Parameter` edge set unions.
4E-c. forall (e in Parameter_Indirect_In union Parameter_Indirect_Out)
        (if      destAnnotFun(e) /\ isParam_ActualIn(hasDest[e])    /\ (hasParamIdx[hasDest[e]]   > 0)
          then coerced[e] == hasArgtaints[edFunCdf(e), hasParamIdx[hasDest[e]],   esTaint(e)]
        elseif sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]] > 0)
          then coerced[e] == hasArgtaints[esFunCdf(e), hasParamIdx[hasSource[e]], edTaint(e)]
        else true endif);

% Can be omitted if the `DataDepEdge_Indirect_Ret` edges are included in the `DataDepEdge_Ret` edge set.
4E-d. forall (e in DataDepEdge_Indirect_Ret) 
        (coerced[e] == (if sourceAnnotFun(e) then hasRettaints[esFunCdf(e), edTaint(e)] else false endif));
```

### 5R. A function used as data must not have a function annotation, and its taint should propagate to the instruction using it.

*Explanation*: In the phase 2 CLE model, a function taint propagating to a data node is essentially a 'type error' - function labels and data labels are distinct entities. Nevertheless, a function which is used as data must have some taint information propagate to the node using it. An overly restrictive solution is to require that a function used as data be un-annotated, so that its taint in the CLE model is a data/node taint and not a function taint.

*Required PDG Edges*:
- `DataDepEdge_FunctionDefUse`: An edge between an instruction which takes the address of a function or otherwise uses it as data (i.e. referencing it without invoking it).

*Sample MZN Encoding*:
```
5R-a. forall (e in DataDepEdge_FunctionDefUse) 
        (userAnnotatedFunction[hasFunction[hasSource[e]]] == false) &&
        (coerced[e] == false);
```

### 5E. A function used as data should propagate a taint to the instruction using it. If the function is un-annotated, the taint on the instruction should be the function taint. If the function is annotated, the taint on the instruction should be a synthetic, non-shareable data taint with the same level as the function annotation.

*Explanation*: Function annotations should be associated with a synthetic data label which has the same level as the function annotation and is not shareable. This data label should propagate instead of the function label to annotated functions used as data. This would still pin the function pointer to a level and prevent it from being shared. The full function annotation, with CDFs, is only relevant if the function pointer is ever called, in which case indirect call edge will re-connect it with the function entry node that has the function annotation. We include a special constraint on the indirect call edge to coerce back to the function annotation.

*Required PDG Edges*:
- `DataDepEdge_FunctionDefUse`: An edge between an instruction which takes the address of a function or otherwise uses it as data (i.e. referencing it without invoking it).

*Sample MZN Encoding*:
```
5E-a. TODO

5E-b. TODO
```