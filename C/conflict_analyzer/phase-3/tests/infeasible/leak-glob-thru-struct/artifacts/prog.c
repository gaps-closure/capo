#include <stdio.h>

#pragma cle def A { "level": "orange" }
#pragma cle def B { "level": "orange" }

#pragma cle def MAIN { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [], \
            "codtaints": ["A", "B"], \
            "rettaints": ["A", "B"] \
        } \
    ] \
}

#pragma cle B
#pragma clang attribute push (__attribute__((annotate("B"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int glob = 1;
#pragma clang attribute pop

typedef struct {
  int* a;
  int b;
} S;

void foo(S s) {

  // pin foo to label A
  #pragma cle A
#pragma clang attribute push (__attribute__((annotate("A"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int unused = 0;
#pragma clang attribute pop

  // foo() access data with label B, bad!
  printf("glob: %d\n", *(s.a));
}

#pragma cle MAIN
#pragma clang attribute push (__attribute__((annotate("MAIN"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int main() {
#pragma clang attribute pop

  #pragma cle A
#pragma clang attribute push (__attribute__((annotate("A"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  S s;
#pragma clang attribute pop

  s.a = &glob;
  s.b = 6;

  foo(s);
  return 0;
}
