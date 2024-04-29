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
#pragma clang attribute push (__attribute__((annotate("FOO"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int foo() {
#pragma clang attribute pop
  return 0;
}

int main() {

  int (*f)(void) = &foo;
  return (*f)();
}
