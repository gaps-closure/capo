#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}
#pragma cle def EWMA_SHAREABLE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["ORANGE"], ["ORANGE"]], \
     "codtaints": [], \
     "rettaints": ["EWMA_SHAREABLE"] } \
  ] }

#pragma cle begin EWMA_SHAREABLE
double calc_ewma(double a, double b) {
#pragma cle end EWMA_SHAREABLE
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
#pragma cle begin ORANGE
  static double b = 1.0;
#pragma cle end ORANGE
  b += b;
  return b;
}

#pragma cle begin PURPLE
int ewma_main() {
#pragma cle end PURPLE
  double x;
  double y;
  double ewma;
  for (int i=0; i < 10; i++) {
    x = get_a();           // conflict with orange 
    y = get_b();           // conflict with orange
    ewma = calc_ewma(x,y); // calc_ewma blessed, but x,y conflicts propagate
    printf("%f\n", ewma);
  }
  return 0;
}

int main(int argc, char **argv) {
  return ewma_main();
}

