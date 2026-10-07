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

    int s0, s1, s2, s3, a, b, bi, o1, o2, o3, o4, o5;

    int op, ip, no1, no2;


    // 74181 basic circuit one, top left, 1 inverter, 5 ands, 2 nor 

    for (op=0; op < 16; op++) {

        s0 = (op & 0x01);
        s1 = (op & 0x02) >> 1;
        s2 = (op & 0x04) >> 2;
        s3 = (op & 0x08) >> 3;
    
    for (a = 0; a < 2; a++) {

    for (b = 0; b < 2; b++) {

        bi = ! (b) & 0x01;

        o1 = b & s3 & a;
        o2 = bi & s2 & a;
        o3 = bi & s1;
        o4 = b & s0;
        o5 = a & a;

        no1 = ! (o1 | o2);

        no2 = ! ( o3 | o4 | o5 );

        printf ("%2d %2d %2d %2d %2d %2d = %2d %2d \n",a,b,s0,s1,s2,s3,no1,no2);
    }
    }
    }

    return (0);
    }

