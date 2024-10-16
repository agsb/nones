#include <stdio.h>
#include <stdlib.h>

/* letterfrequency.org */

/* the most used 'letter' is space, ever */

/*  

    two 8x2 boxes, fingers p, m, r, i, t

        p       m       r       i       i       r       m       p

	0	1	2	3	4	5	6	7
        3,      2,      1,      1,      1,      1,      2,      3,

	8	9	10	11	12	13	14	15
        2,      1,      0,      0,      0,      0,      1,      2,
        
	16	17	18	19	20	21	22	23
	4,      3,      2,      2,      2,      2,      3,      4,

	24	25	26	27	28	29	30	31
        3,      2,      1,      1,      1,      1,      2,      3,

	per order:

	13, 10, 12, 11, 
	14, 9, 5, 2, 4, 3, 
	29, 26, 28, 27,
       	6, 1, 15, 8,
	21, 18, 20, 19,
	30, 25,
	31, 24, 7, 0, 23, 16


*/

/* order to assign keys as layout above */


/* for a 4x2 dual keyboard */

int  indx[] = {
	13, 10, 12, 11, 
	14, 9, 5, 2, 4, 3, 
	29, 26, 28, 27,
       	6, 1, 15, 8,
	21, 18, 20, 19,
	30, 25,
	31, 24, 7, 0, 23, 16
	};

char keys[32];

/* note:

no dead keys SHF, CTR, ALT, GUI

usefull S space, M mood are thumb keys

usefful B backspace, E Enter, D delete, T tab are moods

wise C escape

*/

/* basic pretty print a keyboard */

void show(void) {

    int k;

    for (k = 0; k < 32; k++) {

        if ( !(k % 8) ) printf ("\n");
        if ( !(k % 16) ) printf ("\n");

        printf ("\t[ %c ]", keys[k]);

        keys[k] = 'X';

        }

    printf ("\n");

    }


int main(int argc, char * argv[]) {


    int  n, m, k;

    float v;

    char c, s[128];

    int xe=24, xb=25, xd=26, xt=27;

/* where insert specials ? */

  if (argc > 1) sscanf (argv[1], "%d %d %d %d", &xe, &xb, &xd, &xt);

    
  for (k=0; k < 32; k++) {
	  keys[k] = ' ';
  	}

/* read string of ordened chars and insert specials */

    k = 0;


    while ( (c = getchar()) != EOF ) {

/* insert specials */

        // if (k ==  0) s[k++] = 'S'; // is the first

        if (k == xe) s[k++] = 'E';
    
    	if (k == xb) s[k++] = 'B';

        if (k == xd) s[k++] = 'D';
    
    	if (k == xt) s[k++] = 'T';

        s[k++] = c;

        }

    s[k++] = 'C'; // is the last

    s[k] = '\0';

    k = 0;
    	
    n = 0;

    while (s[n]) {

        m = indx[k];

        keys[m] = s[n];

        k++;

        if (k == 32) {

            show();

            k = 0;

            }

        n++;

        }

    show();

    return (0);

    }



