
BEGIN {

    FS=" "

    // keyboard layout effort 
    // file with "weight key key key ... key"

    file = ARGV[1]

    while ((getline < file) > 0) {
    
        if (!(/^#/)) {

            print "# " $0

            w = $1 + 0

            for (i = 2; i <= NF; i++) {
                
                c = $i

                ws[c] = w ;

                }
            }
        }

    close (file)

    # don't use it as stdin

    delete ARGV[1]

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

    print "# = " file " word ppm " wds " keys ppm " cvs " uses " qss " " qss/cvs 
    print "# = keys ppms ppm% eff% "
    for (c in cv) {
        printf (" %c %7ld %7.4lf %7.4lf\n", c, cv[c], cv[c]/cvs * 100.00, qs[c]/qss * 100.00)
        }

}
