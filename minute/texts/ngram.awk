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

# allow comments
# if (/^#/) next

# count lines

# counts ' ' as S

    gsub (/\t/,"S");
    gsub (/ /,"S");

# appends \n  as A

    word = $0 "A"

# count event of letters

    n = split (word, chars, "");

    for (i=1; i <= n; i++) {
        dig = chars[i]
        suma[dig] += 1
        }

# and count digraphs        

    for (i=1; i < n; i++) {
        dig = chars[i] chars[i+1]
        sumd[dig] += 1
        }

# and count trigraphs        

    for (i=1; i < (n - 1); i++) {
        dig = chars[i] chars[i+1] chars[i+2]
        sumt[dig] += 1
        }

}

END {

#   cd key count sfi percent

    f = log (10)

    s = 0.0

    for ( c in suma ) {
        s += suma[c]
        }
    
    for ( c in suma ) {
        a = suma[c]
        b = a / s * 100.0 
        d = 10.0 * (log ( a / 1000000.0 ) / f + 4) 
        printf ("n %s %d %6.2f %6.2f\n", c, a, d, b) 
        }

    s = 0.0
    
    for ( c in sumd ) {
        s += sumd[c]
        }
    
    for ( c in sumd ) {
        a = sumd[c]
        b = a / s * 100.0 
        d = 10.0 * (log ( a / 1000000.0 ) / f + 4) 
        printf ("d %s %d %6.2f %6.2f\n", c, a, d, b) 
        }

    s = 0.0
    
    for ( c in sumt ) {
        s += sumt[c]
        }
    
    for ( c in sumt ) {
        a = sumt[c]
        b = a / s * 100.0 
        e = 10.0 * (log ( a / 1000000.0 ) / f + 4) 
        printf ("t %s %d %6.2f %6.2f\n", c, a, d, b) 
        }

    }

