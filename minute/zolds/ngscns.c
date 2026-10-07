/* ngslist.c */

#include <stdio.h>
#include <stdlib.h>

/* analisys with ngsl list with counts, 2022 */

/* verify count analysis */

/* sums order of letter in words, using diferents sequence of letters */

/* valid ascii chars, all lowercase */

 #define LEN 16
 
 #define CHARS 26

/* keyboard layouts weights */

/*    
 *    lazzy pinky
 *
 *    layer 0
 *    ------------------------------------------
 *     4    1    1    1        1    1    1    4
 *     3    0    0    0        0    0    0    3
 *
 *     layer 1 (mod)
 *    ------------------------------------------
 *     5    2    2    2        2    2    2    5
 *     4    1    1    1        1    1    1    4
 *
 *	0, 0, 0, 0, 0, 0,
 *      1, 1, 1, 1, 1, 1,
 *      1, 1, 1, 1, 1, 1
 *      2, 2, 2, 2, 2, 2,
 *      3, 3, 4, 4, 4, 4,
 *      5, 5,'
 *
 *    lazzy pinky (layer 2)
 *
 *    layer 0
 *    ------------------------------------------
 *     4    1    1    2        2    1    1    4
 *     3    0    0    0        0    0    0    3
 *
 *     layer 1
 *    ------------------------------------------
 *     6    3    3    4        4    3    3    6
 *     5    2    2    2        2    2    2    5
 *
 *    ------------------------------------------
 *
 *
 *    eg. workman adapted	
 *
 *    layer 0
 *    ------------------------------------------
 *     4    1    1    3        3    1    1    4
 *     2    0    0    0        0    0    0    2
 *
 *     layer 1
 *    ------------------------------------------
 *     6    3    3    5        5    3    3    6
 *     4    2    2    2        2    2    2    4
 */

/*
 int svs[] = { // lazy I
	 0, 0, 0, 0, 0, 0, 
	 1, 1, 1, 1, 1, 1, 
	 2, 2, 2, 2, 2, 2,
	 3, 3, 3, 3, 3, 3,
	 3, 3, 4, 4, 4, 4,
	 5, 5 };
*/



int svs[] = { // lazy II
	0, 0, 0, 0, 0, 0,		     
	1, 1, 1, 1, 1, 1,		     
	1, 1, 1, 1, 2, 2,
	2, 2, 2, 2, 3, 3,		     
	3, 3, 4, 4, 4, 4,
	5, 5 
	};
	

int main(int argc, char * argv[]) {


	 // max length of lemma is 64

     char s[64];

     int i, j, k, n, m, h;

     int keys[LEN][CHARS];

     long v, sum[LEN];

     /* clean wise */

     for (i=0; i< LEN; i++) {

	 sum[i] = 0;

         for (j=0; j< CHARS; j++) {

             keys[i][j] = 0;

             }

         }

    /* read the sequences of ordened letters, each must start with a = */

    m = 0;

    while ( scanf ("%s\n", s) == 1 ) {

      	n = 0;

	if (s[n] == '=') {

      	n++;

	while (s[n]) {	
	        
		k = (int) s[n] - (int) 'a';

		if (0 <= k && k < CHARS) keys[m][k] = svs[n-1];
		
		n++;
		
		}

	m++;

	continue;
      }

      break;
    
    }


/* input is "rank lemma sfi upm", integer word integer integer */

    while ( scanf (" %d %s %d %d", &h, s, &h, &h) == 4 ) {

         i = 0;

         while (s[i]) {

             	j = (int) (s[i]) - (int) 'a';

		for (k = 0; k < m; k++) {
		
	     		sum[k] = sum[k] + keys[k][j];	
		
			}
    		
		i++;

		}
	
    	}


     {
 
	     double vm;
     v = 0;

     for (k = 0; k < m; k++) v += sum[k];

     vm = (double) v / (double) m;

     
	     
     for (k = 0; k < m; k++) {


             printf ("~ %d %8.4lf\n", k,  (double) sum[k] / vm );

             }

     }

     return (0);

     }


