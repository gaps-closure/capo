#include <stdio.h>

#pragma cle def ORANGE_NOSHARE { "level": "orange"}

#pragma cle def ORANGE_SHARE { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel":"purple", \
            "direction": "egress", \
            "guarddirective": { "operation": "allow" } \
        } \
    ] \
}

#pragma cle def BAR { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [], \
            "codtaints": ["ORANGE_SHARE", "ORANGE_NOSHARE"], \
            "rettaints": ["ORANGE_SHARE"] \
        } \
    ] \
}

// INFEASIBLE, because main() must be singly tainted ORANGE_SHARE, but
// can access ORANGE_NOSHARE through a pointer to global data
// (even though it does not attempt to access it)

#pragma cle ORANGE_NOSHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_NOSHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int x[3] = {1,2,3};
#pragma clang attribute pop
int* x_base = x;

#pragma cle BAR
#pragma clang attribute push (__attribute__((annotate("BAR"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int** bar() {
#pragma clang attribute pop
  return &x_base;
}

int main() {
  int** y = bar(); // Access to ORANGE_SHARE data y
                   // (because bar() coerced it)
                   // Alias is avaialble through y to ORANGE_NOSHARE
  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_PointsTo from line 37 to line 33, where bar returns &x
// DataDepEdge_PointsTo from line 41 to line 33, because y[0] (a member of y) is x
