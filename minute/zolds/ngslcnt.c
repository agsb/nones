/* ngslist.c */

#include <stdio.h>
#include <stdlib.h>

/* analisys with ngsl list with counts, 2022 */

/* verify count analysis */

/* 0 full, 1 first, 2 second, 3 third, 4 fourth, 5 last */

 #define LEN 6

/* valid ascii chars, all lowercase */

 #define CHARS 26

 int main(int argc, char * argv[]) {

     char s[64];

     int i, j, k;

     long int n, m, h, c;

     long int keys[LEN][CHARS];

     for (i=0; i< LEN; i++) {
         for (j=0; j< CHARS; j++) {
             keys[i][j] = 0;
             }
         }

/* input is "lemma rank sfi upm", string integer integer integer */

    c = 0;

    while ( scanf ("%s %ld %ld %ld\n", s, &h, &m, &n) == 4 ) {

        /* printf ("%s %ld %ld %ld\n", s, h, m, n); */

        /* counts words */

         c += n;

         i = 0;

         while (s[i]) {

             j = (int) (s[i]) - (int) 'a';

             /* any place */

             keys[0][j] += n;

             /* first, second, third, fourth place */

             if ( i < LEN - 1 ) keys[i+1][j] += n;

             k = j;

             i++;

             }

         /* last place */

         keys[LEN-1][k] += n;

         }

/* output letter frequencies "= place by_absolute by_average letter" */

     {

     double a, b, c, d, m;

     for (i=0; i< LEN; i++) {

         m = 0.0;

         for (j=0; j< CHARS; j++) {

             m = m + keys[i][j];

             }
        
        /* sum of all letters */

         b = m;

        /* mean for it */

         c = m / (26);

         for (j=0; j< CHARS; j++) {

             a = keys[i][j] / b * 100.0;

             d = (keys[i][j]) / c;

            /* position count percent proportion letter */

             printf ("= %d %ld %8.4lf %8.4lf %c\n", 
                i, keys[i][j], a, d, j + 'a');

             }

         }

     }
     
     return (0);

     }


