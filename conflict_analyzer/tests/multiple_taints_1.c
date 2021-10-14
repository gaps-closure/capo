#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}
#pragma cle def ORANGE_SHAREABLE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" } \
    } \
 ] }
#pragma cle def XD_GET_FOO {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_FOO"] \
    }, \
    {"remotelevel":"orange", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_FOO"] \
    } \
 ] }

int foo() {
#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE

#pragma cle begin ORANGE_SHAREABLE
    static int z = 1;
#pragma cle end ORANGE_SHAREABLE
    y++;
    z++;
    return y + z;
}

#pragma cle begin XD_GET_FOO
int get_foo() {
#pragma cle end XD_GET_FOO
    return foo();
}

int bar() {
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE
    x += x + get_foo();
    return x; 
}

int main(int argc, char **argv) {
  printf("%d\n", bar());
  return 0; 
}