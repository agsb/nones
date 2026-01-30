#!/usr/bin/awk
# agsb@ 2026/02
# cumulatives of a numeric 12 keyboard
# input: - letter count

BEGIN {

        
        # sum of counts
        s = 0.0
         
        # counts
        m = 0
        }

{
        # skip comments
        if ($1 == "#") next;

        m++

        w[m] = $2
        v[m] = $3

        s += 0 + $3

        }

END {

# brute force

        n = 1

        for ( i = 1; i < 9; i++ ) {
                k[i] = k[i] w[n]
                c[i] = c[i] + v[n]
                n++;
                }

        for ( i = 8; i > 0; i-- ) {
                k[i] = k[i] w[n]
                c[i] = c[i] + v[n]
                n++;
                }
                
        for ( i = 8; i > 0; i-- ) {
                k[i] = k[i] w[n]
                c[i] = c[i] + v[n]
                n++;
                }

        for ( i = 1; i < 9; i++ ) {
               print "- " i " " k[i] " " c[i]
               }
                
# then with some limits

        for ( i = 1; i < 9; i++ ) {
                k[i] = ""
                c[i] = 0
                }

        n = 1

        for ( i = 1; i < 9; i++ ) {
                k[i] = k[i] w[n]
                c[i] = c[i] + v[n]
                n++;
                }

# chosse the lowest probability digrapy

        }
        
