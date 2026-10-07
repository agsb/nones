#!/usr/bin/awk
#
# from a ngsl file with 'lemma fpm'
#
# convert last count into percent relative
#   agsb@ 2024
#

BEGIN {

    sum = 0

    file = ARGV[1]

    while ( (getline < file) > 0) {
        
        sum += 0.0 + $2

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

        per = (0.0 + $2) / sum * 100.0
        cum = cum + per

        printf (" %s %7.4f %7.4f\n", $1, per, cum)
            }
        }
        
    }
