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

        # make frequencies

        for ( w in words) {

                # letters
                n = split(w, its, "")
                for ( i = 1; i < n; i++ ) {
                        k = its[i]
                        sums[k] += 0.0 + words[w]
                        }
                
                # count Spaces before and after     
                ws = "S" w "S"
                n = split(ws, its, "")

                # digraphs
                for ( i = 1; i < n; i++ ) {
                        k = its[i] its[i+1]
                        sumd[k] += 0.0 + words[w]
                        }

                # trigraphs
                for ( i = 1; i < n - 1; i++ ) {
                        k = its[i] its[i+1] its[i+2]
                        sumt[k] += 0.0 + words[w]
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
                
        # no exists
        for ( i in sums ) {
                for ( j in sums ) {
                        k = i j
                        if (sumd[k] > 0.0) continue;
                        print "* " k " 0.0"
                        
                        for ( k in sums ) {
                                w = i j k
                                if (sumt[w] > 0.0) continue;
                                print "~ " w " 0.0"
                                }

                        }
                }

        }
        
