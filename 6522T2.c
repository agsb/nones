#include  <stdlib.h>
#include  <stdio.h>

/*
for 6522
does preset CH and CL
for frequencies as
T2 timer is at 921600Hz (phi2)
and shift register as 01010101
*/

int main ( int argc, char * argv[]) {

int i, j, k, n;
float f, t, v;

f = (1.8432 / 2.0) * 1000;

for (i=1; i < 256; i++) {

    t = f / ( i );

    for (j=0; j < 256; j++) {

        // kHz
        if ( j ) v = t / ( j );
        else v = t;

        if ( v > 8.000) continue;
        if ( v < 0.056) continue;

	    printf (" %4d %4d %8.4f\n", i, j, v);

        }
    } 

return (0);
}

