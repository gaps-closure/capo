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
#pragma clang attribute push (__attribute__((annotate("C"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int a = 5;
#pragma clang attribute pop

  return a;
}

#pragma cle FOO
#pragma clang attribute push (__attribute__((annotate("FOO"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int main() {
#pragma clang attribute pop

  int (*f)(void) = &foo;
  int c = (*f)();
  return 0;
}
