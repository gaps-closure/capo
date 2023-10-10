#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def PURPLE_SHAREABLE { "level": "purple", \
  "cdf": [ \
    {"remotelevel": "orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"} } \
    ]}

#pragma cle def XDLINKAGE_GET_EWMA {"level":"purple",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_GET_EWMA"]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_EWMA"] },\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_GET_EWMA"]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_EWMA"] }\
  ] }

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle def EWMA_MAIN {"level":"orange",\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["ORANGE", "TAG_REQUEST_GET_EWMA", "TAG_RESPONSE_GET_EWMA"], \
     "rettaints": ["ORANGE"] \
    } \
  ] }

double calc_ewma(double a, double b) {
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
#pragma cle begin PURPLE
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  static double b = 1.0;
#pragma clang attribute pop
#pragma cle end PURPLE
  b += b;
  return b;
}

#pragma cle begin XDLINKAGE_GET_EWMA
#pragma clang attribute push (__attribute__((annotate("XDLINKAGE_GET_EWMA"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
double get_ewma(double x) {
#pragma clang attribute pop
#pragma cle end XDLINKAGE_GET_EWMA
#pragma cle begin PURPLE_SHAREABLE
#pragma clang attribute push (__attribute__((annotate("PURPLE_SHAREABLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
  double x1, y1, z1;
#pragma clang attribute pop
#pragma cle end PURPLE_SHAREABLE
  x1 = x;
  y1 = get_b();
  z1 = calc_ewma(x1, y1);
  return z1;
}

#pragma cle begin EWMA_MAIN
#pragma clang attribute push (__attribute__((annotate("EWMA_MAIN"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int ewma_main() {
#pragma clang attribute pop
#pragma cle end EWMA_MAIN
  double x;
  double y;
  double ewma;
  for (int i=0; i < 10; i++) {
    x = get_a();
    y = x;
    ewma = get_ewma(y);
    printf("%f\n", ewma);
  }
  return 0;
}

int main() {
  return ewma_main();
}
