
BEGIN {

    FS=" "

    # keyboard layout effort 
    # file with "weight key key key ... key"

    file = ARGV[2]
     
    getline seed < file

    close (file)

    delete ARGV[2]

    srand (seed)

    file = ARGV[1]

    while ((getline < file) > 0) {
    
        if (!(/^#/)) {

            w = $1 + 0

            for (i = 2; i <= NF; i++) {
                
                c = $i

                ws[c] = w ;

                ct[i-1] = c; 

                }
            }
        }

    close (file)

    # don't use it as stdin

    delete ARGV[1]

    # suffle keys
    # hard way no chr function
    
    for (i = 1; i < 27; i++) {
        c = ct[i]
        ws[c] = 2
        }
        
    k = 0
    while (k  < 12) {
        i = int (rand() * 26) + 1
        c = ct[i]
        if (ws[c] == 2) {
            ws[c] = 1
            k++
            }
        }
    
    qss = 0
    wds = 0
    cvs = 0
}


{

        # line with "word ppm "

        if (/^#/) next

        # total ppm words

        wds += $2 

        # total ppm keys

        m = split ($1, keys, "")

        for (i = 1; i <= m; i++) {
            
            c = keys[i]
            
            # count key ppm
            cv[c] += $2
            
            # count key effort by ppm
            qs[c] += $2 * ws[c]

            # total key ppm
            cvs += $2

            # total effort by ppm
            qss += $2 * ws[c]

            }
}

END {

    ORS = " "
    print "# " qss/cvs " " 

    for (i = 1; i < 27; i++) {
        c = ct[i]
        d = ws[c]
        print " " c " " d 
        }
    
    print "\n"

    #print "# = keys ppms ppm% eff% "
    #for (c in cv) {
    #    printf (" %c %7ld %7.4lf %7.4lf\n", c, cv[c], cv[c]/cvs * 100.00, qs[c]/qss * 100.00)
    #    }
        
}
