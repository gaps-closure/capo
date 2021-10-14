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
     "codtaints": ["ORANGE"], \
     "rettaints": ["ORANGE", "TAG_RESPONSE_GET_FOO"] \
    }, \
    {"remotelevel":"orange", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["ORANGE", "TAG_RESPONSE_GET_FOO"] \
    } \
 ] }

int baz() {
#pragma cle begin ORANGE_SHAREABLE
    static int x = 1;
#pragma cle end ORANGE_SHAREABLE
    x++;
    return x;
}


int foo() {
#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE
    y++;
    return y;
}

#pragma cle begin XD_GET_FOO
int get_foo() {
#pragma cle end XD_GET_FOO
#pragma cle begin ORANGE_SHAREABLE
    int x = baz();
#pragma cle end ORANGE_SHAREABLE
    int y = foo();
    return x + y; 
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