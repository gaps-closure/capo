#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "imaging.h"
#include "gps_lib.h"
#include "targeting.h"

#define OK 0
#define NOTOK -1

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
int receive_image(image_t * i) {
  char * filename = "boats.jpg";
  *i = filename;
  char cmd[200];
  snprintf(cmd, 200, "display -resize 25%% %s", filename);
  system(cmd);
  return OK;
}
int combine_and_display_data(gps_data_t * g, targeting_data_t * t, image_t i) {
  //something to combine the data
  //and display image
  printf("Target '%s' at time %.24s, coordinates (%f %f), size is (%d, %d) image: '%s'\n",
	 t->name, ctime(&(g->timestamp)), g->lat, g->lon, t->width, t->height, i);
  char cmd[1024];
  char * final_img_name = "/tmp/gaps_img_target.jpg";
  snprintf(cmd, 1024, "convert %s -crop %dx%d+%d+%d -pointsize 20 -fill yellow "
 	   "-draw 'text %d,%d \"Target metadata: %s\"' -draw 'text %d,%d \"Local time: %.24s\"' -draw 'text %d,%d \"Coordinates: %f %f\"' %s",
 	   i, t->width, t->height, g->x, g->y,
 	   g->x + ((int) (t->width * 0.1)), g->y + ((int) (t->height * 0.8)), t->name,
 	   g->x + ((int) (t->width * 0.1)), g->y + ((int) (t->height * 0.85)), ctime(&(g->timestamp)),
 	   g->x + ((int) (t->width * 0.1)), g->y + ((int) (t->height * 0.9)), g->lat, g->lon,
	   final_img_name);
  //printf("%s\n", cmd);
  system(cmd);
  snprintf(cmd, 1024, "display %s", final_img_name);
  system(cmd);
  return OK;
}

int main(int argc, char * argv[]) {
  gps_data_t * g = NULL;
  targeting_data_t * t = NULL;
  image_t i;
  
  g = receive_gps();
  t = receive_targeting();
  receive_image(&i);
  combine_and_display_data(g, t, i);
}
