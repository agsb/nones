
grep 'Inkscape' $1 | tee inks.lst | wc > inks.cnt
grep 'DOCTYPE' $1 | tee doct.lst | wc > doct.cnt
grep 'Corel' $1 | tee corel.lst | wc > corel.cnt
grep 'Esri' $1 | tee esri.lst | wc > esri.cnt

