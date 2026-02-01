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

        ws[$2] = $3

        }

END {

        n = split ("etoanhirslducbfymwpgvkxjqz", qq, "")

        # complement the list with no shows

        for (i = 1; i <= 8; i++) {
        
                for (j = 9; j <= 16; j++) {
                        
                        w = qq[i] qq[j]
                        
                        if (ws[w] > 0.0) continue;

                        ws[w]= 0.0
                        }       
                }

        # calculate the sums in either order
        for (i = 1; i <= 8; i++) {
        
                for (j = 9; j <= 16; j++) {
                        
                        a = qq[i] qq[j]
                        b = qq[j] qq[i]
                        
                        vs[a] = ws[a] + ws[b] + 0.0 

                        }       
                }

        # lists the digraphs and sums

        for (w in vs) {

                print "* " w " " vs[w] + 0.0

                }

      }
