#include <stdio.h>
#include <stdlib.h>

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

// INFEASIBLE, because main() must be singly tainted ORANGE_SHARE,
// but can access ORANGE_NOSHARE through a heap pointer created in bar()

#pragma cle BAR
#pragma clang attribute push (__attribute__((annotate("BAR"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int* bar() {
#pragma clang attribute pop
  #pragma cle ORANGE_NOSHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_NOSHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int* x = malloc(sizeof(int));
#pragma clang attribute pop
  return x;
}

int main() {

  #pragma cle ORANGE_SHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int unused = 0;
#pragma clang attribute pop
  
  int* y = bar(); // Access to ORANGE_SHARE data y (because bar() coerced it)
  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_PointsTo from line 40 to line 35
// DataDepEdge_PointsTo from line 41 to line 35
