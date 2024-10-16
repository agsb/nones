#!/usr/bin/awk
#
# from a ngsl file
# convert last count into percent relative
#   agsb@ 2024
#

BEGIN {

    }

{
    
        if ($1 == /^#/) next

        n = split ( $2, chars, "" )
        
        for (i=1; i <= n; i++) {
            
            c = chars[n]

            sums[c] = sums[c] + $3

            }
    
}

END {

    # n = asort (sums, olds)

    sum = 0.0

    for (j in sums) {
        
        #; j = olds[i]

        printf ("%c %7.4f\n", j, sums[j] ) 

        }
        
    }
