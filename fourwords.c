#include  <stdlib.h>
#include  <stdio.h>


int main ( int argc, char * argv[]) {


int i, j, k, n;

for (i=0; i< 26; i++) {
for (j=0; j< 26; j++) {
for (k=0; k< 26; k++) {
for (n=0; n< 26; n++) {

	printf (" %c%c%c%c\n", i+'A', j+'A', k+'A', n+'A');

} } } }

return (0);
}

