#
# maps each key in sequence
# input : lemma, order, ppm
#
#   lists which 
#           '= letter order line'
#           '~ letter frequency% counter'
#
BEGIN {
    FS=" "
    }

{
# no comments
    
    if (/^#/) next

    c = $1
    p = $2

    sum[c] += 0 + p
}

END {
    for ( c in sum ) {
        printf (" %s %7.4f\n", c, sum[c]) 
        }

    }

