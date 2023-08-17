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
int* bar() {
  #pragma cle ORANGE_NOSHARE
  int* x = malloc(sizeof(int));
  return x;
}

int main() {
  int* y = bar(); // Access to ORANGE_SHARE data y (because bar() coerced it)
  *y = 2;         // Access to ORANGE_NOSHARE data pointed to by y
  free(y);
  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_PointsTo from line 40 to line 35
// DataDepEdge_PointsTo from line 41 to line 35