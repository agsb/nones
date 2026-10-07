#include <stdio.h>
#include <stdlib.h>

/* letterfrequency.org */

/* the most used 'letter' is space, ever */

/*  

    two 6x2 boxes, fingers p, (m), (r), (i), t

    pinky and thumb reserved for controls

         m       r       i   |    i       r       m

         C3u    C2u     C1u  |   C1u     C2u     C3u  

	R2   7      8       9    |   10      11      12     R4

         C3d    C2d     C1d  |   C1d     C2d     C3d  

    R1   1      2       3    |   4       5       6      R3

    
    vide japanese-duplex-matrix for keyboards 
        3 C x 4 R same processor

    ( must have same for thumb and pinky )

    many layers accessed by usin QMK, hit, hold, tap combos

    */

    /* to evaluate performace


    in array:

        7  8  9 10 11 12
        1  2  3  4  5  6 

    costs:

        6 4 5 x 5 4 6        
        3 1 2 x 2 1 3 

	per order, right to left, bellow to upper:

    preferences:
    
         12  8 10  9  7 11
          6  2  4  3  1  5

    inverting for linear:

        { 5, 2, 4, 3, 6, 1, 11, 8, 10, 9, 12, 7 } 
        
        { 3, 1, 2, 2, 1, 3, 6, 4, 5, 5, 4, 6 }


*/

/* order to assign keys as layout above */


/* for a 3x2 dual keyboard */

int  indx[] = {
    5, 2, 4, 3, 6, 1, 11, 8, 10, 9, 12, 7 
	};

char keys[48];

/* note:

no dead keys SHF, CTR, ALT, GUI

usefull S space, M mood are thumb keys

usefful B backspace, E Enter, D delete, T tab are moods

wise C escape

*/

/* basic pretty print a keyboard */

int layer = 0;

void show(void) {

    int k;

    printf (" Layer: %3d\n", layer++);

    for (k = 6; k < 12; k++) {

        if ( !(k % 6) ) printf ("\n");

        if ( !(k % 12) ) printf ("\n");

        printf ("\t[ %c ]", keys[k]);

        keys[k] = 'X';

        }

    for (k = 0; k < 6; k++) {

        if ( !(k % 6) ) printf ("\n");

        if ( !(k % 12) ) printf ("\n");

        printf ("\t[ %c ]", keys[k]);

        keys[k] = 'X';

        }

    printf ("\n\n");

    }


int main(int argc, char * argv[]) {


    int  n, m, k;

    float v;

    char c, s[128];

  for (k=0; k < 48; k++) {
	  keys[k] = ' ';
  	}

/* read string of ordened chars and insert specials */

    k = 0;

    while ( (c = getchar()) != EOF ) {

        if (c == ' ') continue; 

        s[k++] = c;

        }

    s[k] = '\0';

    k = 0;
    	
    n = 0;

    while (s[n]) {

        m = indx[k] - 1;

        k++; 

        keys[m] = s[n];

        if (k == 12) {

            show();

            k = 0;

            }

        n++;

        }

    show();

    return (0);

    }



