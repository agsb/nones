#!/usr/bin/awk
#
#   agsb@ 2024
#

#  /* count percent relative letter */
BEGIN {

    sum = 0.0
    }

{

        if ($1 == /^#/)  next
    
        sum += $2

        printf (" %6d %8.4f %8.4f %8.4f %c\n", $1, $2, sum, $3, $4) 

    }

    

END {

        
    }
