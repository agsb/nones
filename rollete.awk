#!/usr/bin/awk
# ciclic enum using rollete numbers as indices of next rollete number
# agsb@ 2026
#
# reduces to 2 non trivial groups:
# 26 03 18 04 23 19 29 14 13
# 08 33 24 25
#


BEGIN {

# Pascal roullete sequence
nn= "00,32,15,19,04,21,02,25,17,34,06,27,13,36,11,30,08,23,10,05,24,16,33,01,20,14,31,09,22,18,29,07,28,12,35,03,26" ;

        n = split (nn, ns, ",")

        for (k = 2; k < 38; k++ ) {

                n = 0 + ns[k]
        
                printf ( "K %2d ( %2d ) ",k, ns[k] )

                for (m = 0; m < 40; m++) {
                        printf (" %2d", n)
                        n = ( n + ns[n] ) % 37;
                        }
                print
                }
        }
{
        }
END {
        }
