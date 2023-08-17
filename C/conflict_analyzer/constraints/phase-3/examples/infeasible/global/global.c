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

#pragma cle ORANGE_NOSHARE
int x[3] = {1,2,3};

#pragma cle BAR
int** bar() {
  return &x;
}

int main() {
  #pragma cle ORANGE_SHARE
  int z = 5;

  int** y = bar(); // Access to ORANGE_SHARE data y
                   // (because bar() coerced it)
  (*y)[0] = 2;     // Access to ORANGE_NOSHARE data pointed to by y
  return 0;
}
// Line 45

// EXPECTED NEW EDGES

// Edge from line 33 to line 29, where bar returns &x
// Edge from line 40 to line 29, because y[0] (a member of y) is x
// At least two edges from line 42 to line 29, because *y == x
// - One for *y to x
// - One for x[0] = 2

// EXAMPLE DESCRIPTION

// when int z[3] gets the annotation ORANGE_NOSHARE:
// - The address value z is ORANGE_NOSHARE
// - The memory location which is pointed to by z is ORANGE_NOSHARE

// bar() coerces the address z. But z still 
// points to the memory location, so main has access to ORANGE_NOSHARE.
// Then main() is multiply tainted with no function annotation, contradiction

// Therefore, this example is infeasible and should fail phase-3 conflict analysis
