#!/usr/bin/awk
#
# from a ngsl file with 'lemma, rank, ppm'
# a csv file !
#
# convert ppm count into percent relative
#   agsb@ 2024
#

BEGIN {

    FS=","

    sum = 0

    cnt = 0

    file = ARGV[1]

    while ( (getline < file) > 0) {
        
        if (cnt++ > 0) 
            sum += $3

    }
    
    close (file)
}

{
    
    
}

END {

    tot = 0

    cnt = 0

    file = ARGV[1]

    while ( (getline < file) > 0) {

        if ( cnt++ == 0 ) print $0

        else {
            per = (0.0 + $3) / sum * 100.0
            tot = tot + per
            printf (" %s, %6d, %7.4f, %7.4f\n", $1, $3, per, tot)
            }
        }
        
    }
