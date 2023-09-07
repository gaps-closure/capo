# CAPO phase 3 pointer support: New CLE model constraints

The phase 3 conflict analyzer should correctly partition programs containing both data and function pointers, even when they are aliased, enclosed in struct fields, passed between different functions, or passed to an external function. We propose new constraints to the CLE model to accomplish this.

## Status

| Constraint | Status in capo/phase-3-develop |
| --- | --- |
| `Indirect_Same_Enclave` | Enforced | 
| `PointsTo_Same_Enclave` | Enforced |
| `Function_Ptr_Singly_Tainted` | Enforced |
| `Indirect_Callee_Singly_Tainted` | Enforced |
| `Indirect_Caller_Singly_Tainted_Or_Coerced` | Enforced |
| `PointsTo_Taints_Match` | Enforced |
| `GlobalDefUse_Taints_Match` | Enforced |
| `Struct_Arr_Field_Taints_Match` | * Missing, may not be necessary * |
| `Extern_Callback_Same_Enclave` | * Missing, need extern-subgraph edge * |

## Listing

In all of the below constraints, let `F` and `G` be any two distinct functions. Let `D` refer to program data: a global variable, function definition, or heap or stack-allocated data.

### Enclave separation constraints

1. **Indirect_Same_Enclave**: If `F` is called *indirectly* by `G` (i.e. via a function pointer), then `F` and `G` must be in the same enclave.
2. **PointsTo_Same_Enclave**: If any PDG node in `F` points to some program data `D` (a global variable, function definition, static variable, or heap or stack-allocated data), then `F` and `D` must be in the same enclave.

### Function annotation restriction

3. **Function_Ptr_Singly_Tainted**: If `F` has its address taken or is otherwise used as data, `F` must be un-annotated.
4. **Indirect_Callee_Singly_Tainted**: If `F` is called *indirectly* by `G`, `F` must be un-annotated.

(Note that in the case of points-to analysis being an over-approximation, the first constraint implies the second.)

### Intra-enclave taint coercion

5. **Indirect_Caller_Singly_Tainted_Or_Coerced**: If `F` is called *indirectly* by `G`, the same taint coercion constraints as with direct calls must apply.
6. **PointsTo_Taints_Match**: If a points-to edge connects two nodes, they must have the same taint.
7. **GlobalDefUse_Taints_Match**: If two global variables are connected by a def-use dependency, they must have the same taint.
8. **Struct_Arr_Field_Taints_Match**: A structure or array and all of its fields/elements must have the same taint.

### External functions

9. **Extern_Callback_Same_Enclave**: If a function is passed as a pointer to an external function, both the pointed-to function and the caller of the external function must be in the same enclave.

## Model relaxations

In CLE, an annotated function taint propagating to a data node is essentially a 'type error' - function taints and node taints are distinct entities.

Constraints **Function_Ptr_Singly_Tainted** and **Indirect_Callee_Singly_Tainted** require that a function used as data be un-annotated, so that its taint in conflict analysis is a data/node taint and not a function taint. Then the constraint **Function_Ptr_Taints_Inst**, which propagates the un-annotated function's taint to a data node, is not a 'type error'.

This is overly restrictive, however; there is no security reason to prevent intra-enclave taint coercion through indirect calls to annotated functions. We consider relaxing the restriction by dropping **Function_Ptr_Singly_Tainted** and **Indirect_Callee_Singly_Tainted** with the following adjustment to the above constraints (**This relaxation relies on indirect call and alias analysis being over-approximations**):
- When a function has its address taken or is used as data, the taint on the function does not propagate to the data node. *No taint is enforced on the data node*. Essentially, constraint **Function_Ptr_Taints_Inst** is also dropped.
- Similarly, no taint propagation is enforced for pointer aliases to functions (i.e. in constraints 7, 8, and 9, `D` no longer includes function definitions).

The rationale behind this change is that the existing constraint **Ptr_Alias_Same_Enclave** already pins every function aliasing a function pointer to have the same enclave as the pointed-to definition, preventing a function pointer from passing cross-domain. Therefore the initial level/enclave and the shareability of function pointers are already fully constrained, and like all data nodes they have no other relevant security requirements until they are called. We need only constrain enclave separation and taint coercion when the function pointer is invoked, and this is already covered by **Indirect_Same_Enclave** and **Indirect_Caller_Singly_Tainted_Or_Coerced** respectively.