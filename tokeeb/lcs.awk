

BEGIN {

        # count lines
        lines = 0
                
        }

{
        # skip header at first line
        lines = lines + 1
        if (lines == 1) next;

        # skip comments
        if ($1 == "#") next;

        # split in chars
        n = split ($1, chars, "");

        # count sums
        for ( i in chars) {
                c = chars[i];
                sums[c] += 0 + $2;
                }
        }

END {
        print "# " lines " lines "  

        sum = 0

        # sum all
        for ( c in sums ) {
                sum += 0 + sums[c]
                }

        # make percents
        for ( c in sums ) {
                print c " " sums[c]/sum*100.0
                }

        }
        
