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
  int* y = bar(); // Access to ORANGE_SHARE data y (because bar() coerced it)
  *y = 2;         // Access to ORANGE_NOSHARE data pointed to by y
  free(y);
  return 0;
}
