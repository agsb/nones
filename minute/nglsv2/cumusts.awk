#
# agsb@ 2024
#
BEGIN {

    FS=","

    sum = 0

    }

{
# full file
    sum += 0.0 + $3
    printf ("%s, %5.2f\n", $0, sum) 
    }

END {

    }

