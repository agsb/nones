#include  <stdlib.h>
#include  <stdio.h>


int main ( int argc, char * argv[]) {

char m[] = { 'A','B','C','D','E','F' };

int i, j, k, n;

for (i=0; i< 6; i++) {
for (j=0; j< 6; j++) {
for (k=0; k< 6; k++) {
for (n=0; n< 6; n++) {

	printf (" %c%c%c%c\n", m[i], m[j], m[k], m[n]);

} } } }

return (0);
}

