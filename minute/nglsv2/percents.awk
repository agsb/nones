#!/usr/bin/awk
#
# from a ngsl file with 'lemma, rank, ppm'
# a csv file !
#
# convert ppm count into letter percent relative
#   agsb@ 2024
#

BEGIN {

    FS=","

}

{

    if (/^#/) next;

    if (m == 0) m = NF

    if ( m != NF) print " error " NR " " $0 

    n = split ($1,chars,"")
            
    for (i = 1; i <= n; i++) {
        j = chars[i]
        sumc[j] += $3;
        }
    
}


END {

    tot = 0

    sum = 0

    for (j in sumc) {
        
        sum += (sumc[j])

        }

        
    for (j in sumc) {
        
        val = sumc[j]

        per = (val) / sum * 100.0
        
        sfi = 10 * (log (val) / log (10) + 4) 

        printf (" %s, %6d, %7.4f, %7.4f\n", j, val, per, sfi)
        
        }
        
    }
