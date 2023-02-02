#include <stdio.h>
#include <stdlib.h>

/*

prototype for local hash of a stream of values

for easy a stream of bytes

Alvaro Barcellos @2023

*/

#define MAX 256
#define NUM 8
#define STP 32

// buckets

int bk[4][8];

// stream runs in blocks of 256 values, processing signatures for each 4 blocks,
// with 8 buckets of 32 ranged values

int main (int argc, char * argv[]) {

// generic values

    int n, m, p, q, i, j, k;

    m = 0;
    
    p = 0;

    while ( (q = getc(stdin)) != EOF)  {

    // get the value

    // define bucket 0-7 in 256 by 32

    n = ( (q % 256) / 32 );

    // put it in :)

    bk[m][n] += 1;

//    printf ("%4d %4d %4d %4d|\n", m, q, n, bk[m][n] );

    if (++p > 255) {

        for (i = 0; i < 8; i ++) { 
        
//            printf ("> %4d %4d ", i , bk[m][i]);

            if (bk[m][i] < 8) { 
                bk[m][i] = 0;
                }
            else {
                bk[m][i] = 1;
                }

//            printf (" %4d> \n",  bk[m][i]);

            }

        p = 0;

        if (++m > 3) {

            // signature()            

            q = 0;
            for (i = 0; i < 8; i++) { 
                k = 0;
                for (j = 0; j < 4; j++) {
                    if (bk[j][i] > 0) {
                        k = j;
                        break;
                    }
                
                printf (" > %4d %4d %4d ", i, k, q);

                q = q | k;
                
                q = q << 2;

                printf (" > %4d %4d ", k, q);
                
                }

            printf (" signature %6d\n", q);

            m = 0;
            }

        }
    }

    }

    return (0);
    }

