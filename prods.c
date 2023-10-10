#include  <stdlib.h>
#include  <stdio.h>


int main ( int argc, char * argv[]) {


int i, j, k, n;

for (i=1; i< 255; i++) {
for (j=1; j< 255; j++) {

	printf (" %4d %4d x %4d\n", i*j, i, j);

} } 

return (0);
}

