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
#pragma cle def XD_ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints": ["ORANGE", "ORANGE_SHAREABLE", "TAG_RESPONSE_FOO"] \
    } \
 ] }

int baz() {
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHAREABLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin ORANGE_SHAREABLE
    static int x = 1;
#pragma cle end ORANGE_SHAREABLE
#pragma clang attribute pop
    x++;
    return x;
}


int foo() {
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE
#pragma clang attribute pop
    y++;
    int x = baz();
    return x + y;
}

#pragma clang attribute push (__attribute__((annotate("XD_ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin XD_ORANGE
int get_foo() {
#pragma cle end XD_ORANGE
#pragma clang attribute pop
    return foo();
}

int bar() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE
#pragma clang attribute pop
    x += x + get_foo();
    return x; 
}

int main(int argc, char **argv) {
  printf("%d\n", bar());
  return 0; 
}