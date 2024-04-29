#include <stdio.h>

#pragma cle def ORANGE { "level": "orange" }

#pragma cle def FOO { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel": "orange", \
            "direction": "bidirectional", \
            "guarddirective": { "operation": "allow" }, \
            "argtaints": [], \
            "codtaints": ["ORANGE"], \
            "rettaints": ["ORANGE"] \
        } \
    ] \
}

#pragma cle FOO
int foo() {
  return 0;
}

int main() {

  int (*f)(void) = &foo;
  return (*f)();
}