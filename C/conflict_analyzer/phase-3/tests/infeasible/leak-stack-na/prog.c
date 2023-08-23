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

#pragma cle def FOO { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [["ORANGE_NOSHARE"]], \
            "codtaints": ["ORANGE_SHARE", "ORANGE_NOSHARE"], \
            "rettaints": ["ORANGE_SHARE", "ORANGE_NOSHARE"] \
        } \
    ] \
}

// INFEASIBLE, because bar() must be singly tainted ORANGE_SHARE,
// but can access ORANGE_NOSHARE through a stack pointer

// bar() has no annotation, singly tainted, must be ORANGE_SHARE
void bar(int* x) {

  // Unused, pins bar() to ORANGE_SHARE
  #pragma cle ORANGE_SHARE
  int unused = 1;

  // Note that bar() never dereferences x
}

// foo() is blessed to coerce its ORANGE_NOSHARE argument to ORANGE_SHARE
#pragma cle FOO
void foo(int* x) {
  bar(x);
}

// main() has no annotation, singly tainted, must be ORANGE_NOSHARE
int main() {

  #pragma cle ORANGE_NOSHARE
  int x[3] = {1,2,3};
  foo(x);
  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_PointsTo from the argument x in line 43 to line 51.
// DataDepEdge_PointsTo from the argument x in line 32 to line 51.
// DataDepEdge_PointsTo from line 38 to line 51.