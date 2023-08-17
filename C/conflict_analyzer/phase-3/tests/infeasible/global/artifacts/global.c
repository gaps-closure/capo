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
// can access ORANGE_NOSHARE through a pointer to global data.

#pragma cle ORANGE_NOSHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_NOSHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int x[3] = {1,2,3};
#pragma clang attribute pop

#pragma cle BAR
#pragma clang attribute push (__attribute__((annotate("BAR"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int** bar() {
#pragma clang attribute pop
  return &x;
}

int main() {
  #pragma cle ORANGE_SHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int z = 5;
#pragma clang attribute pop

  int** y = bar(); // Access to ORANGE_SHARE data y
                   // (because bar() coerced it)
  (*y)[0] = 2;     // Access to ORANGE_NOSHARE data pointed to by y
  return 0;
}

// EXPECTED PHASE 3 EDGES
// Edge from line 36 to line 32, where bar returns &x
// Edge from line 43 to line 32, because y[0] (a member of y) is x
// At least two edges from line 45 to line 32, because *y == x
// - One for *y to x
// - One for x[0] = 2
