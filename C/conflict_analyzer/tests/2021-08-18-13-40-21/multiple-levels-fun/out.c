#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}

int foo() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE
#pragma clang attribute pop

#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE
#pragma clang attribute pop

    int a = x + y;
    x++;
    y++;
    return a;
}

int main(int argc, char **argv) {
  printf("%d\n", foo());
  return 0; 
}