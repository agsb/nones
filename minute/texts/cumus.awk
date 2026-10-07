#
# maps characters
# input  clean.sh ascii text
# agsb@ 2024
#
BEGIN {

    sum = 0

    }

{
# full file
    sum += 0.0 + $4
    printf ("%s %d %5.2f %5.2f %5.2f\n", $1, $2, $3, $4, sum) 
    }

END {

    }

