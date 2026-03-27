#! /bin/bash
# agsb@2026

# generic wrapper for clean lines and convert to 'lemma fppm'

case $1 in

        "NGSL") # from NGSL 1.2 list
        cat $2 | sed '1d;' | cut -f 1,4 -d',' | \
        tr ',[:upper:]\t' ' [:lower:] ' |  \
        tr -s ' '
        ;;

        "NTSL") # from TFL 1.2 list
        cat $2 | sed '1d;' | cut -f 1,4 -d',' | \
        grep -v '#N/A' | sed -e 's/\([a-z]\) \([a-z]\)/\1\2/' | \
        tr ',[:upper:]\t' ' [:lower:] ' |  \
        tr -s ' ' | sed -e 's/\..*$//'
        ;;

        "NAWL") # from NAWL 1.2 list
        cat $2 | sed '1d;' | cut -f 1,6 -d',' | \
        tr ',[:upper:]\t' ' [:lower:] ' |  \
        tr -s ' '
        ;;

        "GOOG") # from Google word frequency list
        # convert values to fppm and use those bigger than 0
        cat $2 | cut -f 1,3,4 -d',' | \
        tr '"[:upper:]' ' [:lower:]' | \
        sed -e 's/,/ /; s/  / /g; s/\,/./; s/ *//; s/ *$//;' | \
        awk ' { v = int( $2 * 10000); if (v > 0) print " " $1 " " v " "; } '
        ;;

        *)
        echo " Do not know about it. "
        ;;
esac

