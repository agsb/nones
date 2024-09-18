#
# maps characters
# input  clean.sh ascii text
# agsb@ 2024
#
BEGIN {

    }

{
# full file
# all input in lowercase

# count position of letters in a frequency line

    word = $0

    n = split (word, chars, "");

    for (i=1; i <= n; i++) {
        dig = chars[i]
        suma[dig] += i
        }

    }

END {

# list letter and sums, lower is better

    for ( c in suma ) {
        a = suma[c]
        printf ("= %s %d\n", c, a) 
        }

    }

