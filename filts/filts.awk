#!/usr/bin/awk

BEGIN {
    FS=" "
    while ( getline < ARGV[1] ) {
        if (NF == 0) continue
        if ($1 ==  "") continue 
        words[$1] = 0
        print "# " $1 ", " words[$1]
        }
    close (ARGV[1])
    lines = 0
}

{
    # print "line " ++lines " NF " NF

    if (NF == 0 || $1 == "#") next

    once = 0
    some = ""

    for (it=1; it < NF; it++) {
        for ( is in words ) {
            if (is == $it) {
                printf " ( %s ) ", $it 
                words[is]++
                once++
                some = some " " is
                }
            }
        }    

    if (once > 0) {
        printf "\n"
        words[some]++
        }
}

END {
    for ( is in words) {
            print "# " is ", " words[is]
            }
}

