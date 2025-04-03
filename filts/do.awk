#!/usr/bin/awk

# get the vocabulary
BEGIN {
    FS=" "
    while ( getline < ARGV[1] ) {
        if (NF == 0 || $1 == "#") continue
        words[$1] = 0
        }
    close (ARGV[1])
    lines = 0
}

{

    # skip empty and comments
    if (NF == 0 || $1 == "#") next

    # clean line
    lines++
    once = 0
    some = ""

    for (it=1; it <= NF; it++) {
        for ( is in words ) {
            # print "= " lines " : " $it " = " is
            if ($it == is) {
                # print " ( " $is " ) " 
                words[is]++
                once++
                some = some " " is
                break
                }
            }
        }    

    if (once < 2) {
        print "? " $0 
        }

    if (once > 1) {
        $0 = some
        # printf "\n"
        print "((" $0 "))"
        for (it=1; it < NF; it++) {
                some = $(it) " " $(it+1) 
                pairs[some]++
                }
            }    
}

END {
    
    for ( is in words ) {
            print "#w " is ", " words[is]
            }
    
    for ( is in pairs) {
            print "#p " is ", " pairs[is]
            }
}

