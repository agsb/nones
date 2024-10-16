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

    q++

# count first event of letters

    word = $1

    n = split (word, chars, "");

    for ( i in chars) {
        c = chars[i]
        if (ocrs[c] == "") {
            ocrs[c] = m;
            print "- " c " " m " " q
            m++
            }
        
        suma[c] += $3
        cnta[c] += 1

        # positional ?
        #
        # if (i > 3) continue;
        #
        # sump[i][c] += $3
        # cntp[i][c] += 1

        }

# expand with spaces         

    word = "_" $1 "_"

# and count digraphs        

    n = split (word, chars, "")

    for (i=1; i < n; i++) {
            
        dig = chars[i] chars[i+1]
            
        if (digs[dig] == "") {
            digs[dig] = md;
            print "= [" dig "] " md " " q
            md++
            }
        sumd[dig] += $3
        cntd[dig] += 1
        }

# and count trigraphs        

    for (i=1; i < (n - 1); i++) {
            
        dig = chars[i] chars[i+1] chars[i+2]
            
        if (digs[dig] == "") {
            digs[dig] = md;
            print "# (" dig ") " md " " q
            md++
            }
        sumt[dig] += $3
        cntt[dig] += 1
        }
}

END {
    sum = 0
    
    for ( c in suma ) {
        sum += 0 + suma[c]
        }
    
    for ( c in suma ) {
        suma[c] =  suma[c]/sum*100.0 
        printf ("n %s %7.4f %7d\n", c, suma[c], cnta[c]) 
        }

    sum = 0
    
    for ( c in sumd ) {
        sum += 0 + sumd[c]
        }
    
    for ( c in sumd ) {
        sumd[c] =  sumd[c]/sum*100.0 
        printf ("b %s %7.4f %7d\n", c, sumd[c], cntd[c]) 
        }

    sum = 0
    
    for ( c in sumt ) {
        sum += 0 + sumt[c]
        }
    
    for ( c in sumt ) {
        sumt[c] =  sumt[c]/sum*100.0 
        printf ("t %s %7.4f %7d\n", c, sumt[c], cntt[c]) 
        }

    }

