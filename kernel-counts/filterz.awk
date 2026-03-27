#!/usr/bin/awk
# agsb@ 2026/02
#
#

BEGIN {
        
        sum = 0
        ws = ""

        }

{
        m = split($0, w, "")
        cnt["\\n"]++
        for (n=1; n <= m; n++ ) {
                c = w[n]
                if (c == "\t") c = "\\t"
                if (c < " " || c > "~") continue
                cnt[c]++
                }
        
        }

END {
        for (c in cnt) {
                print " " c " " cnt[c] " "
                }

      }

      
