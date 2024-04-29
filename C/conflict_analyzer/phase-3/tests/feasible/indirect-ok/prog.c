#include <stdio.h>

#pragma cle def ORANGE { "level": "orange" }

// singly tainted ORANGE
int foo() {

  #pragma cle ORANGE
  int a = 5;

  return a;
}

// singly tainted ORANGE
int main() {

  #pragma cle ORANGE
  int b = 1;
  int (*f)(void) = &foo;
  int c = (*f)();
  
  return 0;
}