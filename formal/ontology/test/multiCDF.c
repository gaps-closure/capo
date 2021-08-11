#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle def GREEN {"level":"green"}

#pragma cle def XDLINKAGE_GET_A {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"} \
    }, \
    { \
    "remotelevel":"green", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"} \
    } \
  ] }

double calc_ewma(double a, double b) {
  const  double alpha = 0.25;
  #pragma cle begin PURPLE
  static  double c = 0.0;
  #pragma cle end PURPLE
  
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

#pragma cle begin XDLINKAGE_GET_A 
double get_a() {
#pragma cle end XDLINKAGE_GET_A 
#pragma cle begin ORANGE
  static double a = 0.0;
#pragma cle end ORANGE
  a += 1;
  return a;
}

double get_b() {
#pragma cle begin GREEN
  static double b = 1.0;
#pragma cle end GREEN
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

