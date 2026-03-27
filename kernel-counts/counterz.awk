#!/usr/bin/awk
# agsb@ 2026/02
#
#

BEGIN {
        
        sum = 0
        cnt = 0
        cc = ""
        }

{
        if (cc != $1) {
                print " " cc " " sum " " cnt " "
                cc = $1
                sum = 0
                cnt = 0
                }
        sum += $2
        cnt++
        
        }

END {
                print " " cc " " sum " " cnt " "

      }

      
