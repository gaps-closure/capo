#include <stdio.h>

int bar;
static int bar_static;

double calc_ewma(double a, double b) {
    bar = 10;
  const  double alpha = 0.25;
  static double c = 0.0;
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

__attribute__((cle_annotate("ORANGE")))
double get_a() {
  static double a = 0.0;
  a += 1;
  return a;
}

double get_b() {
  static double b = 1.0;
  b += b;
  return b;
}

int ewma_main() {
  double x;
  double y;
  double ewma;
  for (int i=0; i < 10; i++) {
    x = get_a();
    y = get_b();
    ewma = calc_ewma(x,y);
    printf("%f\n", ewma);
  }
  return 0;
}

int main() {
  return ewma_main(); 
}

