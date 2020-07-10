#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guardhint": { "operation": "allow"}}\
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

int ewma_main() {
  double x;
  double y;
#pragma cle begin PURPLE
  double ewma;
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

