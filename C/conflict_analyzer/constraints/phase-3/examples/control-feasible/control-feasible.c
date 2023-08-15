#include <stdio.h>

// Partitioning intent:
// main() -> orange
// glob   -> orange
// foo()  -> orange
// bar()  -> orange
// baz()  -> purple

// Feasible:
// YES - baz is only passed the value to glob and cannot access it.

// Critical phase 3 edge:
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
            "argtaints": [["ORANGE_SHAREABLE"]], \
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

typedef struct {
  int* a;
  int b;
} S;

#pragma cle ORANGE_SHAREABLE
int glob = 5;

#pragma cle PURPLE_XD
void baz(int k) {
  k = k + 1;
}

#pragma cle ORANGE_XD
void bar(int* h) {
  int* k = h;
  S s;
  s.a = k;
  s.b = 3;
  baz(*(s.a));
}

void foo(int* g) {
  int* h = g;
  bar(h);
}

int main() {
  foo(&glob);
  printf("glob = %d\n", glob);
  return 0;
}