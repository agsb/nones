#include <stdio.h>
#include <stdlib.h>

/*
random or brute force search for non cyclic solutions 
for nand connection matrices

model for a bunch of 74hc00

Alvaro Barcellos @2022

*/

struct NAND {
    int next;
    int value;
    int port[2];
    };

typedef struct NAND nand;

// number of ports nand

#define MAXNANDS 64

// hold last cyclic

#define MAXCYCLES 200

// limit for random tries

#define MAXRANDOM 10000000


int main (int argc, char * argv[]) {

// generic values

    int n, p, q, i, j, k;


// hold last ports solution 

    long int m, m0, m1, val, last[MAXCYCLES];

// hold the ports

    nand nands[MAXNANDS];

    
   sscanf (argv[1],"%ld",&m0);
   
   sscanf (argv[2],"%ld",&m1);

   while (m0++ < m1) {

   m = m0;

// select a connection matriz

   srand(m);
    
// printf ("\n <%8d>", m);
//  printf ("%2d ",nands[k].next);

// define the connections

    for (k = 0; k < MAXNANDS; k++) {
        nands[k].next = rand() % MAXNANDS;
        }

    n = 0;

    p = 0;

    while (n++ < MAXCYCLES) {

// pull up or never goes gnd

    for (k = 0; k < MAXNANDS; k++) {
        nands[k].port[0] = 0;
        nands[k].port[1] = 0;
        }

// make the conections as nodes in a schematic

    for (k = 0; k < MAXNANDS; k++) {
        i = nands[k].next;
        j = i & 0x1;
        i = i >> 1;
        nands[i].port[j] |= nands[k].value;
        }

// compute the nand

    for (k = 0; k < MAXNANDS; k++) {
        nands[k].value = (! ( nands[k].port[0] & nands[k].port[1] )) & 0x01;
        }

// compute val

    val = 0;

    for (k = 0; k < MAXNANDS; k++) {
        val = (val << 1) | nands[k].value;
        }
    
    last[p] = val;

    for (k = 0; k < p ; k++) {
       if (last[k] == val) n = MAXCYCLES;
      }

    p++;

    if (p == MAXCYCLES) { 
            n = MAXCYCLES;
            }

    if (n == MAXCYCLES) printf ("\n %4d #%9ld  ", k+1, m);

    }

    }

    return (0);
    }

