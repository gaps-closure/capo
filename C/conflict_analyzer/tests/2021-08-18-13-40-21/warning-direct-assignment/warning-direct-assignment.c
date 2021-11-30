#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}
#pragma cle def XD_FOO {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["ORANGE", "TAG_RESPONSE_FOO"] \
    } \
 ] }

#pragma cle begin XD_FOO
int foo() {
#pragma cle end XD_FOO

#pragma cle begin ORANGE
    static int x = 0;
#pragma cle end ORANGE
    return x; // TODO: write typescript def for warnings
}

int bar() {
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE
    x += x + foo();
    return x; 
}

int main(int argc, char **argv) {
  printf("%d\n", bar());
  return 0; 
}