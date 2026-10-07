/* ngslist.c */

#include <stdio.h>
#include <stdlib.h>

/* analisys with ngsl list with counts, 2022 */

/* verify count analysis */

/* valid ascii chars, all lowercase */

 #define CHARS 26

 int main(int argc, char * argv[]) {

     char c;

     int i, j, k, n, h;

     float v;

     int keys[CHARS];

         for (j=0; j< CHARS; j++) {
             keys[j] = 0;
             }

     while ( scanf ("= %d %d %f %c\n", &i, &j, &v, &c) == 4 ) {


             i = (int) (c) - (int) 'a';

             /* any place */

             keys[i] += j;

             }

/* output letter frequencies "= place by_absolute by_average letter" */

     {

     double a, m;

         m = 0;

         for (j=0; j< CHARS; j++) {

             m = m + keys[j];

             }

         m = m / (26+1);

         for (j=0; j< CHARS; j++) {

             a = keys[j] / m;

             printf ("= 6 %d %8.4lf %c\n", keys[j], a, j + 'a');
	 }

     }
     
     return (0);

     }


