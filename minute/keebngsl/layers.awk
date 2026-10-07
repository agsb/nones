
BEGIN {

    n = 0
    m = 0
    
    FS = " "

    }

{
    
    for (i = 1; i <= NF; i++) {
        dots[i] = $i
        }

    m = NF

    }

END {
    

    printf ("\n")
    
    for (j = 1; j <= 7; j++) { printf ("| ") }
    
    printf ("|\n")
    
    for (j = 1; j <= 7; j++) { printf ("| --- ") }
    
    printf ("|\n")
    
    for (j = 1; j <= 7; j++) { printf ("| ") }
    
    printf ("|\n")
    
    for (k = 0; k <= m; k += 12) {

        printf ("|")
        for (i = k + 10; i <= k + 12; i++) { printf ("| %s ", dots[i]) }
        printf ("|")
        for (i = k +  7; i <= k + 9; i++) { printf ("| %s ", dots[i]) }
        printf ("|\n")
        
        printf ("|")
        for (i = k + 4; i <= k + 6; i++) { printf ("| %s ", dots[i]) }
        printf ("|")
        for (i = k + 1; i <= k + 3; i++) { printf ("| %s ", dots[i]) }
        printf ("|\n")

        printf ("|")
        for (j = 1; j <= 6; j++) { printf ("| ") }
        printf ("|")
        for (j = 1; j <= 6; j++) { printf ("| ") }
        printf ("|\n")
        }

}

