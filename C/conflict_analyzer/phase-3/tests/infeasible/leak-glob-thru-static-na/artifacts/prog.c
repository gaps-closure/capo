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
#pragma clang attribute push (__attribute__((annotate("ORANGE_NOSHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int x[3] = {1,2,3};
#pragma clang attribute pop

// Blessed to coerce ORANGE_NOSHARE to ORANGE_SHARE
#pragma cle BAR
#pragma clang attribute push (__attribute__((annotate("BAR"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int** bar() {
#pragma clang attribute pop
  static int* y = x;
  return &y;
}

int main() {
 
  // Unused, pins main() to ORANGE_SHARE
  #pragma cle ORANGE_SHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int unused;
#pragma clang attribute pop

  // Access to ORANGE_NOSHARE data x
  int** y = bar();
  return 0;
}
