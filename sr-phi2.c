#include  <stdlib.h>
#include  <stdio.h>


int main ( int argc, char * argv[]) {

int i, j, k, n;
float f, t;

for (i=1; i< 256; i++) {

    // ns to ms
    t = (1.0850695 * i) / 1000.0;

    // Hz
    f = 1.0 / t * 1000.0;

	printf (" %4d %8.4f %8.4f\n", i, t, f);

} 

return (0);
}

