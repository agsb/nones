#include  <stdlib.h>
#include  <stdio.h>


int main ( int argc, char * argv[]) {

char *s = "01ABCDEF";

int i, j, k, n;

for (i=0; i< 7; i++) {
for (j=0; j< 7; j++) {
for (k=0; k< 7; k++) {
for (n=0; n< 7; n++) {

	printf (" %c%c%c%c\n", s[i], s[j], s[k], s[n]);

} } } }

return (0);
}

