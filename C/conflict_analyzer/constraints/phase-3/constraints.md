# CAPO phase 3 pointer support: New CLE model constraints

The phase 3 conflict analyzer should correctly partition programs containing both data and function pointers, even when they are aliased, enclosed in struct fields, passed between different functions, or passed to an external function. We propose new constraints to the CLE model to accomplish this.

## Status

In the current phase 3 constraint model (`capo/phase-3-develop`):
- **Enforced**: 1.
- **Not Enforced**: 2-10.

## Listing

In all of the below constraints, let `F` and `G` be any two distinct functions.

Let `D` refer to program data: a global variable, function definition, or heap or stack-allocated data.

Let `P` be either a pointer to `D`, and `S` be a struct or array containing `P`.

### Enclave separation constraints

1. **Indirect_Same_Enclave**: If `F` is called *indirectly* by `G` (i.e. via a function pointer), then `F` and `G` must be in the same enclave.
2. **Ptr_Alias_Same_Enclave**: If any PDG node in `F` has an alias to `S` or `P`, then `F` and the pointed-to data `D` must be in the same enclave.

### Function annotation restrictions

3. **Function_Ptr_Singly_Tainted**: If `F` has its address taken or is otherwise used as data, `F` must be un-annotated.
4. **Indirect_Callee_Singly_Tainted**: If `F` is called *indirectly* by `G`, `F` must be un-annotated.
5. **Indirect_Caller_Singly_Tainted_Or_Coerced**: If `F` is called *indirectly* by `G`, the same taint coercion constraints as with direct calls must apply.

(Note that in the case of alias analysis being an over-approximation, **Function_Ptr_Singly_Tainted** implies **Indirect_Callee_Singly_Tainted**.)

### Intra-enclave taint coercion

6. **Function_Ptr_Taints_Inst**: If `F` has its address taken or is otherwise used as data, the taint of `F` must propagate to the instruction using it.
7. **Inst_Ptr_Alias_Taints_Function**: If a parameter of `F` has an alias to `S` or `P`, the taint the pointed-to data `D` must be in the argument taints of `F`.
8. **Param_Ptr_Alias_Taints_Function**: If an instruction of `F` has an alias to `S` or `P`, the taint on the pointed-to data `D` must be in the ARCtaints of `F`.
9. **Ret_Ptr_Alias_Taints_Function**: If a return of `F` has an alias to `S` or `P`, the taint on the pointed-to data `D` must be in the ARCtaints of `F`.

### External functions

10. **Extern_Callback_Same_Enclave**: If a function is passed as a pointer to an external function, both the pointed-to function and the caller of the external function must be in the same enclave.

## Model relaxations

In CLE, an annotated function taint propagating to a data node is essentially a 'type error' - function taints and node taints are distinct entities.

Constraints **Function_Ptr_Singly_Tainted** and **Indirect_Callee_Singly_Tainted** require that a function used as data be un-annotated, so that its taint in conflict analysis is a data/node taint and not a function taint. Then the constraint **Function_Ptr_Taints_Inst**, which propagates the un-annotated function's taint to a data node, is not a 'type error'.

This is overly restrictive, however; there is no security reason to prevent intra-enclave taint coercion through indirect calls to annotated functions. We consider relaxing the restriction by dropping **Function_Ptr_Singly_Tainted** and **Indirect_Callee_Singly_Tainted** with the following adjustment to the above constraints (**This relaxation relies on indirect call and alias analysis being over-approximations**):
- When a function has its address taken or is used as data, the taint on the function does not propagate to the data node. *No taint is enforced on the data node*. Essentially, constraint **Function_Ptr_Taints_Inst** is also dropped.
- Similarly, no taint propagation is enforced for pointer aliases to functions (i.e. in constraints 7, 8, and 9, `D` no longer includes function definitions).

The rationale behind this change is that the existing constraint **Ptr_Alias_Same_Enclave** already pins every function aliasing a function pointer to have the same enclave as the pointed-to definition, preventing a function pointer from passing cross-domain. Therefore the initial level/enclave and the shareability of function pointers are already fully constrained, and like all data nodes they have no other relevant security requirements until they are called. We need only constrain enclave separation and taint coercion when the function pointer is invoked, and this is already covered by **Indirect_Same_Enclave** and **Indirect_Caller_Singly_Tainted_Or_Coerced** respectively.

## Constraint details

### Indirect_Same_Enclave

*Explanation*: Indirect calls may not be a part of the cross domain cut.

*Required PDG Edges*:
- `ControlDep_Indirect`: A control edge between the call invocation node and the function entry node of an indirect call.

*Sample MZN Encoding*:
```
forall (e in ControlDep_Indirect)​ (xdedge(e) == false);​
```

### Ptr_Alias_Same_Enclave

*Explanation*: If a function `F` has access to a pointer to data `D` that was created outside the scope of `F`, be it a global variable, a function, data on the heap, or data on another function's stack, we must ensure that the pointer is valid in the function's enclave. So we constraint `D` and `F` to be in the same enclave.

*Required PDG Edges*:
- `DataDepEdge_Inst_PointsTo`: An edge from `F` to `D` iff an instruction in `F` has access locally to a pointer to `D` (i.e. an instruction in `F` has a flow-sensitive, field-sensitive alias to `D` determined by SVF points-to analysis).
- `DataDepEdge_Param_PointsTo`: An edge from `F` to `D` iff a parameter of `F` is a pointer to `D` or has a field which is a pointer to `D`.
- `DataDepEdge_Ret_PointsTo`:​ An edge from `F` to `D` iff a return value of `F` is a pointer to `D` or has a field which is a pointer to `D`.

*Sample MZN Encoding*:
```
set of int: DataDepEdge_PointsTo = DataDepEdge_Inst_PointsTo union DataDepEdge_Param_PointsTo union DataDepEdge_Ret_PointsTo;
forall (e in DataDepEdge_PointsTo)​ (xdedge(e) == false);
```

### Indirect_Callee_Singly_Tainted

*Explanation*: Indirect callees are function pointers, meaning they must not be annotated functions (to prevent an annotated function taint from propagating to a data node).

*Required PDG Edges*:
- `ControlDep_Indirect`: A control edge between the call invocation node and the function entry node of an indirect call.

*Sample MZN Encoding*:
```
forall (e in ControlDep_Indirect) (userAnnotatedFunction[hasDest[e]] == false);
```

### Indirect_Caller_Singly_Tainted_Or_Coerced

*Explanation*: Allowing the caller of an indirect call to be an annotated function requires that we analyze the taint coercion of the callee's parameter and return edges, which are not currently in the PDG. So in the absence of those edges, indirect callers should be un-annotated. If we have these edges, however, we can subject them to the same taint coercion constraints as for direct calls, and allow indirect callers to have function annotations.

*Required PDG Edges*:
- `ControlDep_Indirect`

*ALTERNATE Required PDG Edges*:
- `Parameter_Indirect_In`: Edges between indirect call parameter nodes and the definition of each of parameters.
- `Parameter_Indirect_Out`: Edges between indirect call parameter nodes and the arguments of the callee function.
- `Parameter_Indirect_Field`: TODO: What is this?
- `DataDepEdge_Indirect_Ret`: Edges from each of an indirect callee's return statements to the indirect call invocation.

*Sample MZN Encoding*:
```
% Can be omitted if `Parameter_Indirect` edges are included in the `Parameter` edge set unions.
forall (e in Parameter_Indirect_In union Parameter_Indirect_Out)
    (if    destAnnotFun(e)   /\ isParam_ActualIn(hasDest[e])    /\ (hasParamIdx[hasDest[e]]   > 0)
        then coerced[e] == hasArgtaints[edFunCdf(e), hasParamIdx[hasDest[e]],   esTaint(e)]
    elseif sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]] > 0)
        then coerced[e] == hasArgtaints[esFunCdf(e), hasParamIdx[hasSource[e]], edTaint(e)]
    else true endif);

% Can be omitted if the `DataDepEdge_Indirect_Ret` edges are included in the `DataDepEdge_Ret` edge set.
forall (e in DataDepEdge_Indirect_Ret) 
    (coerced[e] == (if sourceAnnotFun(e) then hasRettaints[esFunCdf(e), edTaint(e)] else false endif));
```

### Function_Ptr_Singly_Tainted

*Explanation*: In the phase 2 CLE model, an annotated function taint propagating to a data node is essentially a 'type error' - function labels and data labels are distinct entities. We require that a function used as data be un-annotated, so that its taint in the CLE model is a data/node taint and not an annotated function taint.

*Required PDG Edges*:
- `DataDepEdge_FunctionDefUse`: An edge between an instruction which takes the address of a function or otherwise uses it as data (i.e. referencing it without invoking it).

*Sample MZN Encoding*:
```
forall (e in DataDepEdge_FunctionDefUse) 
    (userAnnotatedFunction[hasFunction[hasSource[e]]] == false);
```

### Function_Ptr_Taints_Inst

*Explanation*: An instruction which addresses a function or otherwise uses it as data should inherit the taint on the function, which is necessarily a node taint by **Function_Ptr_Singly_Tainted**.

*Required PDG Edges*:
- `DataDepEdge_FunctionDefUse`

*Sample MZN Encoding*:
```
forall (e in DataDepEdge_FunctionDefUse) (coerced[e] == false);
```

### Inst_Ptr_Alias_Taints_Function

*Explanation*: If an instruction in a function `F` has access to a pointer to data `D` that was created outside the scope of `F`, be it a global variable, a function, data on the heap, or data on another function's stack, we must ensure that the taint of `D` propagates to `F`. So we the taint of `D` to be allowed by the function taint of `F`.

*Required PDG Edges*:
- `DataDepEdge_Inst_PointsTo`

*Sample MZN Encoding*:
```
forall (e in DataDepEdge_Inst_PointsTo)​ (coerced[e] == false);
```

### Param_Ptr_Alias_Taints_Function

*Explanation*: If a parameter of a function `F` is a pointer to data `D` or has a field pointing to data `D` that was created outside the scope of `F`, be it a global variable, a function, data on the heap, or data on another function's stack, we must ensure that the taint of `D` propagates to `F`. So we the taint of `D` to be allowed by the function taint of `F`.

*Required PDG Edges*:
- `DataDepEdge_Param_PointsTo`

*Sample MZN Encoding*:
```
forall (e in DataDepEdge_Param_PointsTo)​ (coerced[e] == false);
```

### Ret_Ptr_Alias_Taints_Function

*Explanation*: If a return value of a function `F` is a pointer to data `D` or has a field pointing to data `D` that was created outside outside the scope of `F`, be it a global variable, a function, data on the heap, or data on another function's stack, we must ensure that the taint of `D` propagates to `F`. So we the taint of `D` to be allowed by the function taint of `F`.

*Required PDG Edges*:
- `DataDepEdge_Ret_PointsTo`

*Sample MZN Encoding*:
```
forall (e in DataDepEdge_Ret_PointsTo)​ (coerced[e] == false);
```

### Extern_Callback_Same_Enclave

*Explanation*: If a function pointer is ever passed to an external function, we must conservatively assume that the external function will invoke that pointer as a callback. Therefore, the caller of the external function and the pointed-to function should be in the same enclave.

*Required PDG Edges*:
- `ControlDep_ExternSubgraph`: A control edge between the call invocation node node of an external function and the function entry node of every function which is passed to the external function as a parameter.

*Sample MZN Encoding*:
```
forall (e in ControlDep_ExternSubgraph)​ (xdedge(e) == false);
```