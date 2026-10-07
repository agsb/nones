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

     int i, j, k, n, h;

     int keys[LEN][CHARS];

     for (i=0; i< LEN; i++) {
         for (j=0; j< CHARS; j++) {
             keys[i][j] = 0;
             }
         }

/* input is "rank lemma sfi upm", integer word integer integer */

    while ( scanf ("%d %s %d %d\n", &h, s, &h, &n) == 4 ) {

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

     double a, m;

     for (i=0; i< LEN; i++) {

         k = 0;

         m = 0;

         for (j=0; j< CHARS; j++) {

             m = m + keys[i][j];

             }

         m = m / (26+1);

         for (j=0; j< CHARS; j++) {

             a = keys[i][j] / m;

             printf ("= %d %d %8.4lf %c\n", i, keys[i][j], a, j + 'a');

             }

         }

     }
     
     return (0);

     }


