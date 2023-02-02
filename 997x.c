#include <stdio.h>
#include <stdlib.h>


int main (int ac, char * av[]) {

	long int seed, range, many, n;

	if (ac < 4) {
		printf ("Use: 997X seed range many\n all in [1 to 217483648]\nUsed for random resample indices, old easy random formulae: seed = (seed * 997 + 1)  \%% range, values could repeat. for a better than 95\%% confidence and 5\%% error, just use many at least 385\nDo not use for crypto, never.\n");

		return (1);
		}

	sscanf (av[1],"%ld",&seed);

	sscanf (av[2],"%ld",&range);

	sscanf (av[3],"%ld",&many);

	for (n = 0; n < many; n++) {

		seed = (seed * 997 + 1) % range;
		
		printf ("%ld,\t%ld\n", n, seed);

		}

	return (0);
	
	}
	
	

	
