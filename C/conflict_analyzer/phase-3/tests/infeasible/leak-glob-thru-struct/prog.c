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
int glob = 1;

typedef struct {
  int* a;
  int b;
} S;

void foo(S s) {

  // pin foo to label A
  #pragma cle A
  int unused = 0;

  // foo() access data with label B, bad!
  printf("glob: %d\n", *(s.a));
}

#pragma cle MAIN
int main() {

  #pragma cle A
  S s;

  s.a = &glob;
  s.b = 6;

  foo(s);
  return 0;
}