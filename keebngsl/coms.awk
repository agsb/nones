#!/usr/bin/awk
# agsb@ 2026/02
# cumulatives of a numeric 12 keyboard
# input: - letter count

BEGIN {

        
        # sum of counts
        s = 0.0
         
        # counts
        m = 0

        }

{
        # skip comments
        if ($1 == "#") next;

        # clean to lemma value
        gsub (/[\[\]]/,"");

        $0 = $0

        m++

        w[m] = $2
        v[m] = $3

        s += 0 + $3

        }

END {

        n = split ("etoanhirslducbfymwpgvkxjqz", qq, "")

        for (i = 1; i <= 8; i++) {
        
                for (j = 9; j <= 16; j++) {
                
                        
                        ws = qq[i] qq[j]

                        vs = v[ws]
                        
                        if (vs > 0.0) continue;

                        m++
                        w[m] = ws
                        v[m] = 0.0
                        }
                 }       

        for (i=1; i <= m; i++) {

                print "= (" w[i] ") (" v[i] ") "

                }

      }
