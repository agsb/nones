#
# counts n-grams (1,2,3) for a list of words
# show those are in a list of letters and with no count words
#
# list: etaoinrshldu 
#
BEGIN {

}


{

        if (/^#/) next

        m = split ($1, chars, "")

        d = "S"
        
        b = "S"

        for (i = 1; i <= m; i++) {
            
            c = chars[i]
            
            if (i == m) {
                b = c
                c = "S"
                }

            cts[c] += 1
            ctb[b c] += 1
            ctd[d b c] += 1

            d = b
            b = c

            }
}

END {

    for (c in cts) {
        print "- " c " " cts[c]
        }
    
    for (c in ctb) {
        print "= " c " " ctb[c]
        }
    
    for (c in ctd) {
        print "# " c " " ctd[c]
        }

    for (a in cts) {
        if (a ~ /[^ etaoinrshldu]/) { continue } 
        for (b in cts) { 
            if (b ~ /[^ etaoinrshldu]/) { continue }
            c = a b
            # 2-grams not found
            if (ctb[c] == 0) {
                print "?? " c 
                }
            for (c in cts) { 
                if (c ~ /[^ etaoinrshldu]/) { continue }
                d = a b c
            # 3-grams not found
                if (ctb[d] == 0) {
                    print "??? " d 
                    }
                }
            }
        }
}

