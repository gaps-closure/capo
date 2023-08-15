#include <stdio.h>

// Partitioning intent:
// main() -> orange
// glob   -> orange
// foo()  -> purple

// Feasible:
// NO - foo has a pointer to glob, glob is pinned to orange.

// Critical phase 3 edge:
// points-to edge from g in foo() to glob

#pragma cle def ORANGE_SHAREABLE { "level": "orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }
#pragma cle def PURPLE_SHAREABLE { "level": "purple",\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }
#pragma cle def ORANGE_XD { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [], \
            "codtaints": ["ORANGE_SHAREABLE", "TAG_RESPONSE_FOO"], \
            "rettaints": ["ORANGE_SHAREABLE"] \
        } \
    ] \
}

#pragma cle def PURPLE_XD { "level": "purple", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [["TAG_REQUEST_FOO"]], \
            "codtaints": ["PURPLE_SHAREABLE"], \
            "rettaints": ["TAG_RESPONSE_FOO"] \
        }, \
        { \
            "remotelevel": "purple", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [["TAG_REQUEST_FOO"]], \
            "codtaints": ["PURPLE_SHAREABLE"], \
            "rettaints": ["TAG_RESPONSE_FOO"] \
        } \
    ] \
}

#pragma cle ORANGE_SHAREABLE
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHAREABLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int glob = 5;
#pragma clang attribute pop

#pragma cle PURPLE_XD
#pragma clang attribute push (__attribute__((annotate("PURPLE_XD"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
void foo(int* g) {
#pragma clang attribute pop
  *g = *g + 1;
}

#pragma cle ORANGE_XD
#pragma clang attribute push (__attribute__((annotate("ORANGE_XD"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int main() {
#pragma clang attribute pop
  foo(&glob);
  printf("glob = %d\n", glob);
  return 0;
}
