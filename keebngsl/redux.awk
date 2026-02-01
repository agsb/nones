#!/usr/bin/awk
# agsb@ 2026/02
# frequencies from NGSL 1.2 list.csv converted to 'lemma fppm'

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

        # wise
        $0 = tolower ($0)

        words[$1] = $2
        
        # sum all fppms

        sum += 0 + $2

        }

END {

        # make percents
        for ( w in words) {
                
                perc = words[w]*100.0/sum
                
                print "% " w " " perc

                }

        # make frequencies from ppm 

        for ( w in words) {

                # letters
                m = split(w, its, "")
                for ( i = 1; i <= m; i++ ) {
                        k = its[i]
                        sums[k] += 0.0 + words[w]
                        }
                
                # counts with Spaces before and after     
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

                # quadgraphs
                for ( i = 1; i < n - 2; i++ ) {
                        k = its[i] its[i+1] its[i+2] its[i+3]
                        sumq[k] += 0.0 + words[w]
                        }

                }

        # percent frequencies        

        qts = 0
        for ( k in sums) {
                qts += sums[k]
                }
        
        qtd = 0        
        for ( k in sumd) {
                qtd += sumd[k]
                }
        
        qtt = 0        
        for ( k in sumt) {
                qtt += sumt[k]
                }
                
        qtq = 0        
        for ( k in sumq) {
                qtq += sumq[k]
                }
                
        # show frequencies        
                
        for ( k in sums) {
                print "- " k " " (sums[k] * 100.0 / qts)
                }
                
        for ( k in sumd) {
                print "= [" k "] " (sumd[k] * 100.0 / qtd)
                }
                
        for ( k in sumt) {
                print "+ [" k "] " (sumt[k] * 100.0 / qtt)
                }
                
        for ( k in sumq) {
                print "# [" k "] " (sumq[k] * 100.0 / qtq)
                }
                
        # digraphs that no exists
        for ( i in sums ) {
                m = 0.0
                for ( j in sums ) {
                        k = i j
                        if (sumd[k] > 0.0) continue;
                        print "~ [" k "] 0.0"
                        m++
                        }
                # how many
                print "? " i " " m
                }

        }
        
