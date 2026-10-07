#include <stdio.h>
#include <stdlib.h>

/* from corpus NGSL http://www.newgeneralservicelist.org/ */

int keys[26][26];

int main(int argc, char * argv[]) {

    int  i, j, k, v;

    char c, d, s[64], *p;

/* wise clean up */

    for ( i = 0; i < 26; i++) {

        for ( j = 0; j < 26; j++) {

            keys[i][j] = 0;

            }
        }

/* input is "rank lemma sfi upm", integer word integer integer */

    while ( scanf ("%d %s %d %d\n", &v, s, &v, &v) == 4 ) {

        p = s;

        c = *p;

        i = c - 'a';

        while ((d = *(++p)) != 0) {

            j = d - 'a';

            keys[i][j] += v;

            c = d;

            i = j;

            }

        }

/* list letter frequencies upon bigrams */

    {

    int lets[26];

    int m;

    double v, a;

    for ( i = 0; i < 26; i++) {

        lets[i] = 0;

        }

    m = 0;

    for ( i = 0; i < 26; i++) {

        for ( j = 0; j < 26; j++) {

            m += keys[i][j];

            lets[i] += keys[i][j];

            lets[j] += keys[i][j];

            }

        }

    v = (double) m / (26*26);

    for ( i = 0; i < 26; i++) {

            a = (double) lets[i] / v;

            printf ("= %d %8.4lf %c\n", lets[i], a, i + 'a' );

            }
    }

/* output bigram frequencies "+ by_absolute by_average bigram" */

    {

    double a, m;

    int n, v;

    n = 0;

    v = 0;

    for ( i = 0; i < 26; i++) {

        for ( j = 0; j < 26; j++) {

            if (keys[i][j] == 0) continue;

            n = n + 1;

            v = v + keys[i][j];

            }

        }

    m = ((double) v / (double) (n + 1));

    for ( i = 0; i < 26; i++) {

        for ( j = 0; j < 26; j++) {

                a = (double) keys[i][j] / m;

                printf ("+ %d %8.4lf %c%c\n", keys[i][j], a, i + 'a', j + 'a');

            }
        }

    }

    return (0);

    }




