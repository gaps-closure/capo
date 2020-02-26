#include <stdio.h>

#define NULLABLE __attribute__((type_annotate("nullable")))
//#define NULLABLE

//char *x ="Hello World, Mars!\n";

typedef struct p1_coords {
  int *ptr;
} * P1Location;

typedef struct p2_coords {
  int * NULLABLE ptr;
} * P2Location;

typedef struct p3_coords {
  int *ptr;
} * NULLABLE P3Location;

typedef struct p4_coords {
  int * NULLABLE ptr;
} * NULLABLE P4Location;

int main()
{
  P1Location loc1;
  loc1 = NULL;                 // expected-warning {{may become null}}
  loc1->ptr = NULL;            // expected-warning {{may become null}}

  P2Location loc2;
  loc2 = NULL;                 // expected-warning {{may become null}}
  loc2->ptr = NULL;
  
  P3Location NULLABLE loc3;
  loc3 = NULL;
  loc3->ptr = NULL;

  P4Location loc4;
  loc4 = NULL;
  loc4->ptr = NULL;

  char * NULLABLE secretKey;
  secretKey = NULL;
  char * foo = secretKey;      // expected-warning {{may become null}}

  return 0;
}

