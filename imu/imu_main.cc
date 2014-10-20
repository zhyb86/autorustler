#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include "./imu.h"

volatile bool done = false;

void handle_sigint(int signo) { done = true; }

int main() {
  int i2cfd = open("/dev/i2c-1", O_RDWR);
  if (i2cfd == -1) {
    perror("/dev/i2c-1");
    return 1;
  }

  signal(SIGINT, handle_sigint);

  IMU imu(i2cfd);
  printf("# t gx gy gz mx my mz ax ay az\n");

  while (!done) {
    timeval tv0;
    gettimeofday(&tv0, NULL);
    IMURawState s;
    imu.ReadRaw(&s);
#if 0
    fprintf(stderr, "gyro [%+4d %+4d %+4d] mag [%+4d %+4d %+4d] "
            "acc [%+4d %+4d %+4d]\e[K\r",
            s.gyro_x, s.gyro_y, s.gyro_z,
            s.mag_x, s.mag_y, s.mag_z,
            s.accel_x, s.accel_y, s.accel_z);
    fflush(stderr);
#endif
    printf("%d.%06d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n",
           tv0.tv_sec, tv0.tv_usec,
           s.gyro_x, s.gyro_y, s.gyro_z,
           s.mag_x, s.mag_y, s.mag_z,
           s.accel_x, s.accel_y, s.accel_z);
    fflush(stdout);
    timeval tv;
    gettimeofday(&tv, NULL);
    int delay = 20000 - (tv.tv_usec % 20000);
    if (delay > 0)
      usleep(delay);
  }

  return 0;
}
