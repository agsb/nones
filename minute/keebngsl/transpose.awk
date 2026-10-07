
BEGIN {

    n = 0
    m = 0

    }

{
    
    if (NF == 0) next

    n++;

    if (m == 0) m = NF

    if (m != NF ) print " record error " NF " ? " m
    
    for (i = 1; i <= m; i++) {
        dots[i][n] = $i
        }
}

END {
    
    for (k = 0; k <= n; k += 6) {

        p = 1
    
    printf ("\n")
    for (j = 1; j <= 6; j++) printf ("| ")
    printf ("|\n")
    for (j = 1; j <= 6; j++) printf ("| --- ")
    printf ("|\n")

    for (i = 1; i <= m; i++) {
        
        if (!(p++ % 6)) break;

        for (j = k+1; j <= k + 6; j++) {

            printf ("| %s ", dots[i][j])

            }

        printf ("|\n")
        }
    }

}
 
