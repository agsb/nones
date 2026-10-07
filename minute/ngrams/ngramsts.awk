#
# maps each key in sequence
# input : lemma, order, ppm
#
#   lists which 
#           '= letter order line'
#           '~ letter frequency% counter'
#
BEGIN {
    FS=","
    m = 1
    md = 1
    q = 0
    }

{
# no comments
    
    if (/^#/) next

    gsub(/ /,"",$0)

# count lines

    word = $1
    rank = $2
    ppms = $3/1000

# count letters

    n = split (word, chars, "");

    for (i=1; i <= n; i++) {
        c = chars[i]
        suma[c] += 0 + ppms
        cnta += 1
        } 

# expand with spaces         

    word = "_" $1 "_"

# and count bigrams        

    n = split (word, chars, "")

    for (i=1; i < n; i++) {
        dig = chars[i] chars[i+1]
        sumb[dig] += 0 + ppms
        cntb += 1
        }

# and count trigraphs        

    for (i=1; i < (n - 1); i++) {
        dig = chars[i] chars[i+1] chars[i+2]
        sumc[dig] += 0 + ppms
        cntc += 1
        }
}

END {
    sum = 0
    for ( c in suma ) {
        sum += 0 + suma[c]
        }
    
    for ( c in suma ) {
        suma[c] =  suma[c]/sum*100.0 
        printf ("- %s %7.4f\n", c, suma[c]) 
        }

    sum = 0
    for ( c in sumb ) {
        sum += 0 + sumb[c]
        }
    
    for ( c in sumb ) {
        sumb[c] =  sumb[c]/sum*100.0
        printf ("= %s %7.4f\n", c, sumb[c]) 
        }

    sum = 0
    for ( c in sumc ) {
        sum += 0 + sumc[c]
        }
    
    for ( c in sumc ) {
        sumc[c] =  sumc[c]/sum*100.0
        tot += sumc[c]
        printf ("# %s %7.4f\n", c, sumc[c]) 
        }

    }

