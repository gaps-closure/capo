#include <stdio.h>

// Partitioning intent:
// main() -> orange
// glob   -> orange
// foo()  -> purple

// Feasible:
// YES - foo cannot access glob through a pointer.

// Critical phase 3 edges:
// N/A

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
int glob = 5;

#pragma cle PURPLE_XD
void foo(int g) {
  g = g + 1;
}

#pragma cle ORANGE_XD
int main() {
  foo(glob);
  printf("glob = %d\n", glob);
  return 0;
}