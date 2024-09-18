#include <stdio.h>
#include <stdlib.h>

int mem[10000];
int wk, ip, sp=100 rp=200;

int a, b, c;


while (1) {

    printf (" %4d %4d %4d %4d %4d\n", c, wk, ip, rp, sp );

    switch (c) {
            /* unnest */
            case  10 :
                rp++;
                c = 20;
                break;
            case  20 :
                ip = mem[rp];
                c = 100;
                break;
            /* next */
            case 100 :
                wk = mem[ip];
                c = 200;
                break;
            case 200 :
                ip++;
                c = 300;
                break;
            case 300 :
                if (w == 0) c = 1000
                else c = 400;
                break;
            /* nest */
            case 400 :
                mem[rp] = ip;
                c = 500;
                break;
            case 500 :
                rp--;
                c = 600;
                break;
            case 600 :
                ip = wk;
                c = 100;
                break;
            /* link */
            case 10000 :
                wk = ip
                c = 1100;
                break;
            case 1100 :
                rp++;
                c = 1200;
                break
            case 1200 :
                ip = mem[rp];
                c = 1300;
                break;
            case 1300 :    
                printf ("jump %d\n",wk);
                c = 1400;
                break;
            case 1400 :
                c = 100;
                break;
            default:
                printf (" error %d\n", c);
                break;
            }
    }

return (0);
}


            
