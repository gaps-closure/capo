#include <stdio.h>

#pragma cle def A { "level": "orange" }
#pragma cle def B { "level": "orange" }
#pragma cle def C { "level": "orange" }

#pragma cle def FOO { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [], \
            "codtaints": ["A", "B"], \
            "rettaints": ["A"] \
        } \
    ] \
}

// singly tainted C
int foo() {

  #pragma cle C
  int a = 5;

  return a;
}

#pragma cle FOO
int main() {

  int (*f)(void) = &foo;
  int c = (*f)();
  return 0;
}