#include <stdio.h>

#pragma cle def ORANGE_1 { "level": "orange" }
#pragma cle def ORANGE_2 { "level": "orange" }

// INFEASIBLE, because main() calls foo() through a pointer,
// and foo() returns a value tainted ORANGE_2, but main()
// must be singly tainted ORANGE_1

// singly tainted ORANGE_2
int foo() {

  #pragma cle ORANGE_2
  int a = 5;

  return a;
}

// singly tainted ORANGE_1
int main() {

  #pragma cle ORANGE_1
  int b = 1;
  int (*f)(void) = &foo;
  int c = (*f)();
  
  return 0;
}

// EXPECTED PHASE 3 EDGES
// DataDepEdge_FunctionDefUse from function entry on line 11 to var on line 24
// ControlDep_Indirect_CallInv from call on line 25 to function entry on line 11
// DataDepEdge_Indirect_Ret from return on line 16 to call on line 25