#include <stdio.h>
#include <stdlib.h>

/*
enum for non cyclic solutions for nand connection matrices

model for one 74hc00

Alvaro Barcellos @2022

*/

#define MAX 200

// number of ports nand 4

int main (int argc, char * argv[]) {

// generic values

    int n, m, p, q, i, j, k;

    int z[200], d1, d2;

// hold the ports

    int in[8], ip[8], op[4];

// for one 74hc00, 4 ports NAND (A.B~C)
// all possible combinations of inputs, 0 not connect, 1 connect 
// is a 0000 to 1111 out ports to a input 0 to 15

    
    for (in[0] = 0; in[0]  < 15; in[0]++) {
    for (in[1] = 0; in[1]  < 15; in[1]++) {
    for (in[2] = 0; in[2]  < 15; in[2]++) {
    for (in[3] = 0; in[3]  < 15; in[3]++) {
    for (in[4] = 0; in[4]  < 15; in[4]++) {
    for (in[5] = 0; in[5]  < 15; in[5]++) {
    for (in[6] = 0; in[6]  < 15; in[6]++) {
    for (in[7] = 0; in[7]  < 15; in[7]++) {

// pull down all outputs

    for (k = 0; k < 4; k++ ) {
        op[k] = 0x0;
        } 

// run anime

    p = 0;

    for (n = m = 0; n < MAX; n++, m++) {

        ip[0] = 0x0 | (op[0] & in[0] & 0x0001) | (op[1] & in[0] & 0x0010) | (op[2] &
            in[0] & 0x0100) | (op[3] & in[0] & 0x1000);
        ip[1] = 0x0 | (op[0] & in[1] & 0x0001) | (op[1] & in[1] & 0x0010) | (op[2] &
            in[1] & 0x0100) | (op[3] & in[1] & 0x1000);
        ip[2] = 0x0 | (op[0] & in[2] & 0x0001) | (op[1] & in[2] & 0x0010) | (op[2] &
            in[2] & 0x0100) | (op[3] & in[2] & 0x1000);
        ip[3] = 0x0 | (op[0] & in[3] & 0x0001) | (op[1] & in[3] & 0x0010) | (op[2] &
            in[3] & 0x0100) | (op[3] & in[3] & 0x1000);
        ip[4] = 0x0 | (op[0] & in[4] & 0x0001) | (op[1] & in[4] & 0x0010) | (op[2] &
            in[4] & 0x0100) | (op[3] & in[4] & 0x1000);
        ip[5] = 0x0 | (op[0] & in[5] & 0x0001) | (op[1] & in[5] & 0x0010) | (op[2] &
            in[5] & 0x0100) | (op[3] & in[5] & 0x1000);
        ip[6] = 0x0 | (op[0] & in[6] & 0x0001) | (op[1] & in[6] & 0x0010) | (op[2] &
            in[6] & 0x0100) | (op[3] & in[6] & 0x1000);
        ip[7] = 0x0 | (op[0] & in[7] & 0x0001) | (op[1] & in[7] & 0x0010) | (op[2] &
            in[7] & 0x0100) | (op[3] & in[7] & 0x1000);

// do the nands

    q = 0x0;
    for (k = 0; k < 4; k++ ) {
        i = k * 2;
        j = i + 1;
        op[k] = (! (ip[i] & ip[j])) & 0x1;
        q = q << 1 | op[k];
        }

    z[n] = q;

    if (p == q) n = MAX;    
    else {
        d2 = q - p;
        if ( d2 + d1 == 0) n = MAX;
        else {
            p = q;
            d1 = d2;
            }
        }
    }


// output connections above trivial

    if (m > 2) {

        printf ("\n>>");

        for (k = 0; k < 8; k++) {
            printf ("%2d:",ip[k]);
            }

        printf ("(%2d)",m);

        for (k = 0; k < m; k++) {
            printf ("%2d*",z[k]);
            }

        }

    } } } } } } } }

    return (0);
    }

