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

// Acceptable resolutions:
// - Bar can be edited to make a copy of x (or a portion of it)
// - Main can be blessed to access ORANGE_NOSHARE with a function annotation

#pragma cle ORANGE_NOSHARE
int x[3] = {1,2,3};
int* x_base = x;

#pragma cle BAR
int** bar() {
  return &x_base;
}

int main() {
  #pragma cle ORANGE_SHARE
  int z = 5;

  int** y = bar(); // Access to ORANGE_SHARE data y
                   // (because bar() coerced it)
  (*y)[0] = 2;     // Access to ORANGE_NOSHARE data pointed to by y
  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_PointsTo from line 38 to line 34, where bar returns &x
// DataDepEdge_PointsTo from line 45 to line 34, because y[0] (a member of y) is x
// At least two edges from line 47 to line 34, because *y == x
// - DataDepEdge_PointsTo for *y to x
// - DataDepEdge_PointsTo for x[0] = 2