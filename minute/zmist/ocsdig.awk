#
# maps each key in sequence
# input (no csv) : lemma percent
#
#   ocrs lists which 
#           '= letter order line'
#   then 
#           '~ letter frequency% counter'
#
BEGIN {
    m = 1
    md = 1
    q = 0
    }

{
# no comments
    
    if ($1 == "#") {   
       
       next
       
       }

# count lines

    q++

# count first event

    word = $1

    n = split (word, chars, "");

    for ( i in chars) {
        c = chars[i];
        if (ocrs[c] == "") {
            ocrs[c] = m;
            print "= " c " " m " " q
            m++
            }
        suma[c] += $2
        cnts[c] += 0 + 1
        }

# count digraphs        

    word = " " $1 " "

    n = split (word, chars, "")

    for (i=1; i < n; i++) {
            dig = chars[i] chars[i+1]
            
            print "> [" dig "] "

            if (digs[dig] == "") {
                digs[dig] = md;
                print "# " dig " " md " " q
                md++
                }
            sumd[dig] += $2
            cntd[dig] += 0 + 1
            }
}

END {
    sum = 0
    
    for ( c in suma ) {
        sum += 0 + suma[c]
        }
    
    for ( c in suma ) {
        suma[c] =  suma[c]/sum*100.0 
        printf ("~ %c %7.4f %7d\n", c, suma[c], cnts[c]) 
        }

    sum = 0
    
    for ( c in sumd ) {
        sum += 0 + sumd[c]
        }
    
    for ( c in sumd ) {
        sumd[c] =  sumd[c]/sum*100.0 
        printf (": %c %7.4f %7d\n", c, sumd[c], cntd[c]) 
        }

    }

