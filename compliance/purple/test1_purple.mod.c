#include <stdio.h>
#include "test1_purple_rpc.h"

#pragma cle def PURPLE {"level":"purple"}

double calc_ewma(double a, double b) {
  const  double alpha = 0.25;
  static double c = 0.0;
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

double get_b() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable,field))
#pragma cle begin PURPLE
  static double b = 1.0;
#pragma cle end PURPLE
#pragma clang attribute pop
  b += b;
  return b;
}

int ewma_main() {
#pragma clang attribute push (__attribute__((annotate("TAG_RESPONSE_GET_A"))), apply_to = any(function,type_alias,record,enum,variable,field))
#pragma cle begin TAG_RESPONSE_GET_A
  double x;
#pragma cle end TAG_RESPONSE_GET_A
#pragma clang attribute pop
  double y;
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable,field))
#pragma cle begin PURPLE
  double ewma;
#pragma cle end PURPLE
#pragma clang attribute pop
  for (int i=0; i < 10; i++) {
    x = _rpc_get_a();
    y = get_b();
    ewma = calc_ewma(x,y);
    printf("%f\n", ewma);
  }
  return 0;
}
 
int main(int argc, char **argv) {
  _master_rpc_init();
  return ewma_main();
}

