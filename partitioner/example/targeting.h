#ifndef _TARGETING_H_
#define _TARGETING_H_

typedef struct _targeting_data {
  double range;
  double heading;
  int width;
  int height;
  char name[128]; // XXX: keep structs within 256 for mercury
} targeting_data_t;

#endif /*_TARGETING_H_*/
