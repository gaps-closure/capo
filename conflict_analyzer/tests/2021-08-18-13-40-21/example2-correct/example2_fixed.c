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

double calc_ewma(double a, double b) {
  const  double alpha = 0.25;
  static double c = 0.0;
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

double get_a() {
#pragma cle begin ORANGE
  static double a = 0.0;
#pragma cle end ORANGE
  a += 1;
  return a;
}

double get_b() {
#pragma cle begin PURPLE
  static double b = 1.0;
#pragma cle end PURPLE
  b += b;
  return b;
}

#pragma cle begin XDLINKAGE_GET_EWMA
double get_ewma(double x) {
#pragma cle end XDLINKAGE_GET_EWMA
#pragma cle begin PURPLE_SHAREABLE
  double x1, y1, z1;
#pragma cle end PURPLE_SHAREABLE
  x1 = x;
  y1 = get_b();
  z1 = calc_ewma(x1, y1);
  return z1;
}

int ewma_main() {
  double x;
  double y;
#pragma cle begin ORANGE
  double ewma;
#pragma cle end ORANGE
  for (int i=0; i < 10; i++) {
    x = get_a();
    ewma = get_ewma(x);
    printf("%f\n", ewma);
  }
  return 0;
}

int main() {
  return ewma_main();
}
