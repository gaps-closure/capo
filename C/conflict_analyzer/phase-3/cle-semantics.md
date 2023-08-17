# CAPO phase 3 pointer support: Desired CLE semantics with respect to pointers

When a variable is annotated, the value receives the taint, and its location in memory receives the taint.

Taints on values can be coerced, but taints on memory locations cannot be coerced. Values may include pointers. But when a pointer is coerced, the pointed-to data is not (because it is not allowed to be)

Examples can be constructed by finding cases where something we think is singly tainted is actually
multiply tainted due to a pointer alias. The phase 3 edges and constraints should prevent this!