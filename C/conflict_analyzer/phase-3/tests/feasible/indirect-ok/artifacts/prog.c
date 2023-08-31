#include <stdio.h>

#pragma cle def ORANGE { "level": "orange" }

// singly tainted ORANGE
int foo() {

  #pragma cle ORANGE
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int a = 5;
#pragma clang attribute pop

  return a;
}

// singly tainted ORANGE
int main() {

  #pragma cle ORANGE
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int b = 1;
#pragma clang attribute pop
  int (*f)(void) = &foo;
  int c = (*f)();
  
  return 0;
}
