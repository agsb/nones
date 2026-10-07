#
# maps each key in sequence
# input (no csv) : lemma order ppm
#
#   ocrs lists which 
#           '= letter order line'
#   then 
#           '~ letter frequency% counter'
#
BEGIN {
    
    sum = 0

    file = ARGV[1]

    while ((getline < file) > 0) {
    
    if ($1 == "#") {   
       
       }

    else {
        sum += $3;
       }
    }

    close (file)
}

{

}


END {
    file = ARGV[1]

    cum = 0

    while ((getline < file) > 0) {
    
        ths =  $3/sum*100.0 
        cum += ths
        printf ("%s %7.4f %7.4f\n", $1, ths, cum) 
        }

    close (file)
}
