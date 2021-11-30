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

#pragma clang attribute push (__attribute__((annotate("XD_FOO"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin XD_FOO
int foo() {
#pragma cle end XD_FOO
#pragma clang attribute pop

#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin ORANGE
    static int x = 0;
#pragma cle end ORANGE
#pragma clang attribute pop
    return x; // TODO: write typescript def for warnings
}

int bar() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE
#pragma clang attribute pop
    x += x + foo();
    return x; 
}

int main(int argc, char **argv) {
  printf("%d\n", bar());
  return 0; 
}