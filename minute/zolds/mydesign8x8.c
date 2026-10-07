#include <stdio.h>
#include <stdlib.h>

/* letterfrequency.org */

/* the most used 'letter' is space, ever */

/*  

    two 8x2 boxes, fingers p, m, r, i, t

        p       m       r       i       i       r       m       p

        3,      2,      1,      1,      1,      1,      2,      3,
        2,      1,      0,      0,      0,      0,      1,      2,

    order in line:

        0,      1,       2,      3,      4,      5,      6,     7,
        8,      9,      10,     11,     12,     13,     14,     15


    order in reference:

	12, 	11, 	13, 	10, 	5, 	2, 	4, 	3, 
	14, 	9, 	6, 	1, 	15, 	8, 	7, 	0 

*/

/* order to assign keys as layout above */

int  indx[] = { 12, 11, 13, 10, 5, 2, 4, 3, 14, 9, 6, 1, 15, 8, 7, 0 };

char keys[16];

char lets[32];

/* note:

no dead keys SHF, CTR, ALT, GUI

usefull S space, M mood are thumb keys

usefful B backspace, E Enter, D delete, T tab are moods

wise C escape

*/

/* basic pretty print a keyboard */

void show(void) {

    int k;

    for (k = 0; k < 16; k++) {

        if ( !(k % 8) ) {
            printf ("\n");

            printf("\t+---+\t+---+\t+---+\t+---+\t+---+\t+---+\t+---+\t+---+\n");

            }

        printf ("\t| %c |", keys[k]);

        keys[k] = 'X';

        }

    printf ("\n");

    printf("\t+---+\t+---+\t+---+\t+---+\t+---+\t+---+\t+---+\t+---+\n");

    printf ("\n");

    }


int main(int argc, char * argv[]) {


    int  n, m, k;

    float v;

    char c;

    int  xe=16, xb=24, xd=26, xt=25;

/* clear layout keys */

    for (n=0; n < 16; n++) {

        keys[n] = 'X';

        }

/* where insert specials */

    if (argc > 1) sscanf (argv[1], "%d %d %d %d", &xe, &xb, &xd, &xt);

/* read ordened count */

    k = 0;


    while ( scanf (" %d %f %c\n", &n, &v, &c) == 3 ) {

/* insert specials */

        if (k ==  0) lets[k++] = 'S'; // is the first

        if (k == xe) lets[k++] = 'E';
        if (k == xb) lets[k++] = 'B';

        if (k == xd) lets[k++] = 'D';
        if (k == xt) lets[k++] = 'T';

        lets[k++] = c;

        }

    lets[k++] = 'C'; // is the last

    printf ("= ");

    for (n = 0; n < k; n++) {

        printf (" %c",lets[n]);

        }

    printf ("\n");

    lets[k++] = '\0';

    n = 0;

    k = 0;

    while ((c = lets[n])) {

        m = indx[k];

        keys[m] = c;

        k++;

        if (k == 16) {

            show();

            k = 0;

            }

        n++;

        }

    show();

    return (0);

    }



