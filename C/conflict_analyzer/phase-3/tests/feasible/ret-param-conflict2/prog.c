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
int foo(int* x) {
    printf("%d\n", *x);
    return 0;
}

#pragma cle MAIN
int main() {
    static int a = 1;
    glob = &a;
    foo(glob);
    return 0;
}