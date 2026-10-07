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

# count event of letters

    word = $0

    n = split (word, chars, "");

    for (i=1; i <= n; i++) {
        dig = chars[i]
        suma[dig] += i
        }

    }

END {

#   cd key count sfi percent

    for ( c in suma ) {
        a = suma[c]
        printf ("= %s %d\n", c, a) 
        }

    }

