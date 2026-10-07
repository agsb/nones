#include  <stdlib.h>
#include  <stdio.h>


// calculates the frequency variation of Sprott Chaos circuit, 
// for values of cte R an C

#define cte 2.0 * 3.14156592

// integer values already plus 10, kO * uF
#define fax 10E+2 * 10E-9

int main ( int argc, char * argv[]) {

// Values as E12 10%

int r[] = { 10, 12, 15, 18, 22, 27, 33, 39, 47, 56, 68, 82, 100 };

// Values as E6 20%

//int c[] = { 10, 15, 22, 33, 47, 68, 100 };

int c[] = { 10, 22, 33, 47, 100 };

int cc, i, j, k;

float f;
 
for (i=0; i < 5 ; i++) {

    cc = c[i];

	for (j=0; j < 12 ; j++) {

		k = cc * r[j];

		f = 0.792552 / (cte * (float) k * fax ) ;  // Hertz

		printf (" %3d nF %3d Ohm %6d %12f Hz [%12f %12f]\n", 
                c[i], r[j]*100, k, f, f * 0.81, f * 1.21 );
	
		}
	}

return (0);
}

