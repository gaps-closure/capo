#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}
#pragma cle def ORANGE_SHAREABLE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }
#pragma cle def EWMA_SHAREABLE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["ORANGE"], ["ORANGE"]], \
     "codtaints": ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints": ["ORANGE_SHAREABLE"] } \
 ] }

#pragma cle def XDLINKAGE_GET_EWMA {"level":"orange",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_EWMA"] },\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_EWMA"] }\
  ] }

#pragma cle def EWMA_MAIN {"level":"purple",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["PURPLE", "TAG_REQUEST_GET_EWMA", "TAG_RESPONSE_GET_EWMA"], \
     "rettaints": ["PURPLE"] \
    } \
  ] }

#pragma cle begin EWMA_SHAREABLE
#pragma clang attribute push (__attribute__((annotate("EWMA_SHAREABLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
double calc_ewma(double a, double b) {
#pragma clang attribute pop
#pragma cle end EWMA_SHAREABLE
  const  double alpha = 0.25;
  static double c = 0.0;
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

double get_a() {
#pragma cle begin ORANGE
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  static double a = 0.0;
#pragma clang attribute pop
#pragma cle end ORANGE
  a += 1;
  return a;
}

double get_b() {
#pragma cle begin ORANGE
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  static double b = 1.0;
#pragma clang attribute pop
#pragma cle end ORANGE
  b += b;
  return b;
}

#pragma cle begin XDLINKAGE_GET_EWMA
#pragma clang attribute push (__attribute__((annotate("XDLINKAGE_GET_EWMA"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
double get_ewma() {
#pragma clang attribute pop
#pragma cle end XDLINKAGE_GET_EWMA
  double x = get_a(); 
  double y = get_b();
  return calc_ewma(x, y);
}

#pragma cle begin EWMA_MAIN
#pragma clang attribute push (__attribute__((annotate("EWMA_MAIN"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int ewma_main() {
#pragma clang attribute pop
#pragma cle end EWMA_MAIN
  double ewma;
  for (int i=0; i < 10; i++) {
    ewma = get_ewma(); // conflict resolveable by wraping in RPC
    printf("%f\n", ewma);
  }
  return 0;
}

int main() {
  return ewma_main();
}

// purple master: main, ewma_main
