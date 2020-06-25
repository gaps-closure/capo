#include <stdio.h>
#include "../Purple/Purple.h"

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"==purple", \
     "direction": "egress", \
     "guardhint": { "oneway": "true"}}\
  ] }

double get_a() {
  #pragma cle begin ORANGE
  static double a = 1.0;
  #pragma cle end ORANGE
  a += a;
  return a;
}