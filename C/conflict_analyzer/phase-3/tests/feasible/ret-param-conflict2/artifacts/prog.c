#include <stdio.h>

#pragma cle def A { "level": "orange" }
#pragma cle def B { "level": "orange" }

#pragma cle def FOO { "level":"orange",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["A"]], \
     "codtaints": ["A", "B"], \
     "rettaints": ["B"] \
    } \
  ]\
}

#pragma cle def MAIN { "level":"orange",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["A", "B"], \
     "rettaints": ["B"] \
    } \
  ]\
}

int* glob;

#pragma cle FOO
#pragma clang attribute push (__attribute__((annotate("FOO"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int foo(int* x) {
#pragma clang attribute pop
    printf("%d\n", *x);
    return 0;
}

#pragma cle MAIN
#pragma clang attribute push (__attribute__((annotate("MAIN"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int main() {
#pragma clang attribute pop
    static int a = 1;
    glob = &a;
    foo(glob);
    return 0;
}
