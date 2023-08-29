#include <stdio.h>
#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }
#pragma cle def EWMA_MAIN {"level":"purple",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["PURPLE", "TAG_RESPONSE_GET_A"], \
     "rettaints": ["PURPLE"] \
    } \
  ] }
#pragma cle def XDLINKAGE_GET_A {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["TAG_RESPONSE_GET_A"], \
     "idempotent": true, \
     "num_tries": 30, \
     "timeout": 1000 \
    }, \
    {"remotelevel":"orange", \
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
#pragma cle begin XDLINKAGE_GET_A 
#pragma clang attribute push (__attribute__((annotate("XDLINKAGE_GET_A"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
double get_a() {
#pragma clang attribute pop
#pragma cle end XDLINKAGE_GET_A 
#pragma cle begin ORANGE
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  static double a = 0.0;
#pragma clang attribute pop
#pragma cle end ORANGE
  a += 1;
  return a;
}
double get_b() {
#pragma cle begin PURPLE
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  static double b = 1.0;
#pragma clang attribute pop
#pragma cle end PURPLE
  b += b;
  return b;
}
#pragma cle begin EWMA_MAIN 
#pragma clang attribute push (__attribute__((annotate("EWMA_MAIN"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int ewma_main() {
#pragma clang attribute pop
#pragma cle end EWMA_MAIN 
  double x;
  double y;
#pragma cle begin PURPLE
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  double ewma;
#pragma clang attribute pop
#pragma cle end PURPLE
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
