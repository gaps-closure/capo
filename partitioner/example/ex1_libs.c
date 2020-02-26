#include <stdlib.h>
#include "gps_lib.h"

gps_data_t * get_gps_data() {
  gps_data_t * g;
  g = malloc(sizeof(gps_data_t));
  g->lat = 32.673169;
  g->lon = -117.644569;
  g->x = 1000;
  g->y = 1000;
  time(&(g->timestamp));
  if (0) {
    //if we want UTC time instead of local
    struct tm * ptm;
    ptm = gmtime(&(g->timestamp));
    g->timestamp = mktime(ptm);
  }
  return g;
}
