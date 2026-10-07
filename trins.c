#include <stdio.h>
#include <stdlib.h>


int main (void) {

int i, j, k, m;

for (i=1; i<16; i = i+i) {
for (j=1; j<16; j = j+j) {
for (k=1; k<16; k = k+k) {

        m = i + j + k;

        printf (" %2d %2d %2d %2d\n", m,i,j,k);
        }
        }
        }

return (0);
}
