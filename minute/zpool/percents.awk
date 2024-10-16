#!/usr/bin/awk
#
# from a ngsl file with 'lemma order ppm'
# a csv file !
#
# convert ppm count into percent relative
#   agsb@ 2024
#

BEGIN {

    FS=","

    sum = 0

    file = ARGV[1]

    while ( (getline < file) > 0) {
        
        sum += 0.0 + $3

    }
    
    close (file)
}

{
    
    
}

END {

    cum = 0

    file = ARGV[1]

    while ( (getline < file) > 0) {

        if ( /^#/ ) print $0
        else {
            per = (0.0 + $3) / sum * 100.0
            cum = cum + per
            printf (" %s, %6d, %7.4f, %7.4f\n", $1, $2, per, cum)
            }
        }
        
    }
