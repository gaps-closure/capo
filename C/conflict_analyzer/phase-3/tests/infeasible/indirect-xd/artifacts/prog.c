#include <stdio.h>

#pragma cle def ORANGE { "level": "orange" } 
#pragma cle def PURPLE { "level": "purple" }

// INFEASIBLE, because main() calls foo() through a pointer, when they are
// in different enclaves.

// Must be in purple
int foo(int mul) {

  #pragma cle PURPLE
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int a = 5;
#pragma clang attribute pop

  return a * mul;
}

int bar(int y, int z) {
  return y * z;
}

// Must be in orange - should not be able to call foo()
int main() {

  #pragma cle ORANGE
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  int b = 1;
#pragma clang attribute pop

  int mul = 3;
  int (*f)(int) = &foo;
  int c = (*f)(mul);
  
  int d = bar(b, mul);

  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_FunctionDefUse from function entry on line 10 to var on line 25
// ControlDep_Indirect_CallInv from call on line 26 to function entry on line 10
// Parameter_Indirect edges from call on line 26 to arguments on line 10
// DataDepEdge_Indirect_Ret from return on line 15 to call on line 26
