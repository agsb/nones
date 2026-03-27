#!/usr/bin/awk
# agsb@ 2026/02
#
#

BEGIN {
        
        FS = " "

        cc[""] = ""

        }

{
        if ($1 == "==") next

        cc[$1] = cc[$1] + $2 + 0
        
        all = all + $2

        }

END {
        for (w in cc) {
                print " " w " " cc[w]/all * 100 " "
                }

      }

      
