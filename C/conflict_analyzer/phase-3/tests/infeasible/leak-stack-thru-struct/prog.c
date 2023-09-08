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
            "argtaints": [["ORANGE_SHARE"]], \
            "codtaints": ["ORANGE_SHARE", "ORANGE_NOSHARE"], \
            "rettaints": ["ORANGE_SHARE"] \
        } \
    ] \
}

typedef struct {
  int* a;
  int b;
} S;

void bar(S s) {

  // Unused, pins bar() to ORANGE_SHARE
  #pragma cle ORANGE_SHARE
  int unused = 1;
}

#pragma cle FOO
void foo(S s) {

  #pragma cle ORANGE_NOSHARE
  int x[3] = {1,2,3};
  s.a = x;
  bar(s);
}

int main() {

  #pragma cle ORANGE_SHARE
  S s;
  s.b = 5;
  foo(s);
  return 0;
}