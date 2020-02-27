#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "imaging.h"
#include "gps_lib.h"
#include "targeting.h"

#include "partitioner.h"

#define OK 0
#define NOTOK -1

#pragma cle def PURPLE_1 {"level":"purple"}

#pragma cle def ORANGE_1 {"level":"orange",\
  "cdf": [\
    {"remotelevel":"==purple", \
     "direction": "egress", \
     "guardhint": { "oneway": "true"}}\
  ] }

gps_data_t * receive_gps() {
  return get_gps_data();
}

targeting_data_t * receive_targeting() {
  targeting_data_t * t = (targeting_data_t *)malloc(sizeof(targeting_data_t));
  t->range = 10;
  t->heading = 20;
  t->width = 800;
  t->height = 600;
  strcpy(t->name, "Speedboat Alpha");
  return t;
}


int main(int argc, char * argv[]) {
#pragma clang attribute push (__attribute__((annotate("ORANGE_1"))), apply_to = any(function,type_alias,record,enum,variable,field))
  #pragma cle begin ORANGE_1
  gps_data_t * g = NULL;
  targeting_data_t * t = NULL;
  #pragma cle end ORANGE_1
#pragma clang attribute pop

  initialize_partitioner("orange");
  
  g = receive_gps();
  t = receive_targeting();
  guarded_send("purple", "g", sizeof(*g), g);
  guarded_send("purple", "t", sizeof(*t), t);

  cleanup_partitioner();
}

