#ifndef _GPS_LIB_H_
#define _GPS_LIB_H_

#include <time.h>

typedef struct _gps_data {
  double lon;
  double lat;
  int x;
  int y;
  time_t timestamp;
} gps_data_t;

gps_data_t * get_gps_data();

#endif /*_GPS_LIB_H_*/
