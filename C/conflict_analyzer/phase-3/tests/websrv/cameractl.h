#ifndef CAMERACTL_H
#define CAMERACTL_H

#include <stdint.h>
#include <pthread.h>

#define MAX_FRAME_BUF   64000

struct llat_st {
  pthread_mutex_t flk;
  double          lat;
  double          lon;
  double          alt;
  double          ts;
  char            newf;
};

struct framebuf_st {
  pthread_mutex_t flk;
  char            newf;
  size_t          size;
  char            data[MAX_FRAME_BUF];
};

int run_videoproc(void);
int get_frame(char buf[static MAX_FRAME_BUF]);
int get_metadata(double *lat, double *lon, double *alt, double *ts);
int send_camcmd(double pan, double tilt, double imptime, char mode, char stab);

#endif // CAMERACTL_H

