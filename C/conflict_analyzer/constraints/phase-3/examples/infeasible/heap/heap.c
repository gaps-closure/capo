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

// DESCRIPTION:

// when int* x gets the annotation ORANGE_NOSHARE:
// - The address value x is ORANGE_NOSHARE
// - The memory location which is pointed to by x is ORANGE_NOSHARE

// bar() coerces the address x. But x still 
// points to the memory location, so main has access to ORANGE_NOSHARE.
// Then main() is multiply tainted with no function annotation, contradiction

// Therefore, this example is infeasible and should fail phase-3 conflict analysis

// CRITICAL EDGES:

// todo

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