#!/usr/bin/awk

# some frequencies from converted NGSL list.csv as 'lemma fppm'

BEGIN {

        # count lines
        lines = 0

        # sum of counts
        sum = 0.0
                
        }

{
        lines++
        
        # skip header at first line
        if (lines == 1) next;

        # skip comments
        if ($1 == "#") next;

        words[$1] = $2
        
        sum += 0 + $2

        }

END {

        # make percents
        for ( w in words) {
                
                perc = words[w]*100.0/sum
                
                print "% " w " " perc

                # uncomment for use percents
                # words[w] = perc
                
                }

        # make frequencies from ppm or perc

        for ( w in words) {

                # letters
                m = split(w, its, "")
                for ( i = 1; i <= m; i++ ) {
                        k = its[i]
                        sums[k] += 0.0 + words[w]
                        }
                
                # count with Spaces before and after     
                ws = "S" w "S"
                n = split(ws, its, "")

                # digraphs
                if (m < 2) continue;
                for ( i = 1; i <= n; i++ ) {
                        k = its[i] its[i+1]
                        sumd[k] += 0.0 + words[w]
                        }

                # trigraphs
                if (m < 3) continue;
                for ( i = 1; i <= n - 1; i++ ) {
                        k = its[i] its[i+1] its[i+2]
                        sumt[k] += 0.0 + words[w]
                        }

                # quadgraphs
                if (m < 4) continue;
                for ( i = 1; i <= n - 2; i++ ) {
                        k = its[i] its[i+1] its[i+2] its[i+3]
                        sumq[k] += 0.0 + words[w]
                        }


                }

        # show frequencies        
                
        for ( k in sums) {
                print "- " k " " sums[k]
                }
                
        for ( k in sumd) {
                print "= [" k "] " sumd[k]
                }
                
        for ( k in sumt) {
                print "+ [" k "] " sumt[k]
                }
                
        for ( k in sumq) {
                print "# [" k "] " sumq[k]
                }
                
        # no exists
        for ( i in sums ) {
                w = 0.0
                for ( j in sums ) {
                        k = i j
                        if (sumd[k] > 0.0) continue;
                        print "? " k " 0.0"
                        w++
                        }
                print "~ " i " " w
                }

        }
        
