## Taxonomy of phase 3 infeasible programs

Cartesian product of the following is a good base set of examples:

- What is the constrained resource?
    - A global/module static variable (scalar, array or struct)
    - A function static variable
    - Non-static stack variable
    - Heap variable
    - Function pointer

- How is it being coerced/leaked?
    - Through containment in an array passed through one of:
        - a stack pointer
        - a heap pointer
        - a global/module static variable
        - a function static variable
    - Through containment in a struct field (or subfield) passed through one of:
        - ...

- What is tainted?
    - Something that has potential access to the constrained resource
    - Something that actually accesses the constrained resource
    - Something that invokes the constrained resource (if it is a function pointer)

Detection of coercion in these cases should work recursively; i.e. if the constrained resource is passed through multiple functions in multiple different ways, it should be detected at the endpoint.

Likewise, should work recursively on the structure of the constrained resource, i.e. struct in a struct in a struct.