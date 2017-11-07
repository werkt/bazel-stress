#include <sys/types.h>
#include <sys/time.h>
#include <stdlib.h>
#include <fcntl.h>

int
main( int argc, char *argv[] )
{
  int busy_wait_usecs = atoi(argv[1]);
  char *output = argv[2];
  struct timeval start, now;

  gettimeofday(&start, NULL);
  for(;;) {
    gettimeofday(&now, NULL);
    if( (now.tv_sec - start.tv_sec) * 1000000 +
        (now.tv_usec - start.tv_usec) >= busy_wait_usecs )
      break;
  }

  open(output, O_TRUNC|O_CREAT, 0666);

  return EXIT_SUCCESS;
}
