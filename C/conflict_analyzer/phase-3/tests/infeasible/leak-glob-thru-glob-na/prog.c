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

#pragma cle ORANGE_NOSHARE
int x[3] = {1,2,3};

int* x_base = x;

// Blessed to coerce ORANGE_NOSHARE to ORANGE_SHARE
#pragma cle BAR
int** bar() {
  return &x_base;
}

int main() {
 
  // Unused, pins main() to ORANGE_SHARE
  // #pragma cle ORANGE_SHARE
  // int unused;

  // Access to ORANGE_NOSHARE data x
  int** y = bar();
  return 0;
}