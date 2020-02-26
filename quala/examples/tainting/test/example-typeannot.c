#include <stdio.h>

//#define type_annotate(X) annotate(X)
#define TAINTED __attribute__((type_annotate("tainted")))

char *x ="Hello World, Mars!\n";

typedef struct precise_coords {
  double lat;
  double lon;
  double alt;
} *PreciseLocation;

typedef struct coarse_coords {
  TAINTED double lat;
  double lon;
  double alt;
} * TAINTED CoarseLocation;

typedef struct coarse_coords2 {
  double lat;
  double lon;
  double alt;
} TAINTED CoarseLocation2;

typedef struct coarse_coords3 {
  double lat;
  double lon;
  double alt;
} CoarseLocation3;

int main()
{
  PreciseLocation loc1;
  CoarseLocation loc2;
  loc1 = loc2;
  loc1->lat = loc2->lat;

  CoarseLocation loc3;
  loc3->lon = loc2->lat;

  CoarseLocation2 loc4;
  loc4.lat = loc2->lat;  

  CoarseLocation3 loc5;
  CoarseLocation3 TAINTED loc6;
  loc6 = loc5;

  char * TAINTED secretKey;
  char * foo = secretKey;

  return 0;
}

