#include <stdio.h>

#pragma cle def ORANGE { "level": "orange" } 
#pragma cle def PURPLE { "level": "purple" }

// INFEASIBLE, because main() calls foo() through a pointer, when they are
// in different enclaves.

// Must be in purple
int foo(int mul) {

  #pragma cle PURPLE
  int a = 5;

  return a * mul;
}

int bar(int y, int z) {
  return y * z;
}

// Must be in orange - should not be able to call foo()
int main() {

  #pragma cle ORANGE
  int b = 1;

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