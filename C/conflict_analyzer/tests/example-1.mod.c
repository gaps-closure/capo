#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle def XDLINKAGE_GET_A {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["TAG_RESPONSE_GET_A"] \
    } \
  ] }

double calc_ewma(double a, double b) {
  const  double alpha = 0.25;
  static double c = 0.0;
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

#pragma clang attribute push (__attribute__((annotate("XDLINKAGE_GET_A"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin XDLINKAGE_GET_A 
double get_a() {
#pragma cle end XDLINKAGE_GET_A 
#pragma clang attribute pop
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin ORANGE
  static double a = 0.0;
#pragma cle end ORANGE
#pragma clang attribute pop
  a += 1;
  return a;
}

double get_b() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin PURPLE
  static double b = 1.0;
#pragma cle end PURPLE
#pragma clang attribute pop
  b += b;
  return b;
}

int ewma_main() {
  double x;
  double y;
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin PURPLE
  double ewma;
#pragma cle end PURPLE
#pragma clang attribute pop
  for (int i=0; i < 10; i++) {
    x = get_a();
    y = get_b();
    ewma = calc_ewma(x,y);
    printf("%f\n", ewma);
  }
  return 0;
}

int main(int argc, char **argv) {
  return ewma_main(); 
}

