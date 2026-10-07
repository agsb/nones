#include  <stdlib.h>
#include  <stdio.h>
#include  <math.h>

int main ( int argc, char * argv[]) {


int i, j, k, n;

double p, q, r, s, t, u, v;

s = .1880;

for (i=1; i<20; i++) {
    
    p = 100.0;

    k = 0;

    s = s + 0.0001;

    for (j = 0; j < 8; j++)  {

        q = p * (1 - s);

        r = p - q;

        p = q;

        if (j == 0) u = p;

        if (j == 7) v = p;

	    printf (" %2d %2d %8.4f %8.4f %8.4f\n", i, j, q, r, s );

        }

    printf (" ~ %8.4f %8.4f %8.4f %8.4f %8.4f\n", s, 100-u, v, (100 - u - v ), u/v); 

    }

return (0);
}

