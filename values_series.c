#include  <stdlib.h>
#include  <stdio.h>


int main ( int argc, char * argv[]) {

int v[] = { 10, 12, 15, 18, 22, 27, 33, 39, 47, 56, 68, 82, 100 };

int i, j, k;

float r;
 
for (i=0; i< 13; i++) {

	for (j=0; j< 13; j++) {

		k = v[i] * v[j];

		r = 0.559 / ((float) k * 10E+3 * 10E-9);

		printf (" %3d %3d %6d %12f\n", v[i], v[j], k, r );
	
		}
	}

return (0);
}

