
for f in ` ls layout*.v ` ; do
    for g in ` ls ng*.v `; do
        echo " $f $g "
        sh ./doit.sh $f $g $f.$g
        done
    done

grep " word " *.v.o0 > all

grep "ngsl" < all | cut -f 3,11,12 -d ' ' | sort -n -k 2 > ngsl.lst
grep "ngrp" < all | cut -f 3,11,12 -d ' ' | sort -n -k 2 > ngrp.lst
grep "ngrm" < all | cut -f 3,11,12 -d ' ' | sort -n -k 2 > ngrm.lst
grep "ngrf" < all | cut -f 3,11,12 -d ' ' | sort -n -k 2 > ngrf.lst

