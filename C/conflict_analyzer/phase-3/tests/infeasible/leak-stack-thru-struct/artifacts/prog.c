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
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int unused = 1;
#pragma clang attribute pop
}

#pragma cle FOO
#pragma clang attribute push (__attribute__((annotate("FOO"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
void foo(S s) {
#pragma clang attribute pop

  #pragma cle ORANGE_NOSHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_NOSHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int x[3] = {1,2,3};
#pragma clang attribute pop
  s.a = x;
  bar(s);
}

int main() {

  #pragma cle ORANGE_SHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  S s;
#pragma clang attribute pop
  s.b = 5;
  foo(s);
  return 0;
}
