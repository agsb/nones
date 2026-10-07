
awk -f ngramsts.awk $1.t1 > $1.t2

grep -a '^- ' $1.t2  | sort -n -r -k 3 | cat > $1.t3

cat $1.t3 | sed -e 's/[^-]*-//;s/_//;' | cat > $1.t31

cat $1.t31 | head -12 | cut -f 2 -d' ' | tr -d '\n ' > $1.fst

TOS=`cat $1.fst`

echo ">>>>$TOS<<<<<"

# bigrams

grep -a '^= ' $1.t2  | sort -n -r -k 3 | cat -n > $1.t4

grep -v -E "[$TOS]" $1.t4 | cat > $1.t41

grep -a '_' $1.t41 | \
sed -e 's/[^=]*=//;s/_//;' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t42

grep -a -v '_' $1.t41 | \
sed -e 's/[^=]*=//;s/_//;' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t43

cat $1.t43 | sed -e 's/. //' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t431

cat $1.t43 | sed -e 's/ .//' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t432

# trigrams

grep -a '^# ' $1.t2  | sort -n -r -k 3 | cat -n > $1.t5

grep -v -E "[$TOS]" $1.t5 | cat > $1.t51

grep -a '_' $1.t51 | \
sed -e 's/[^#]*#//;s/_//;' | \
cat > $1.t52

cat $1.t52 | sed -e 's/. //' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t521

cat $1.t52 | sed -e 's/ .//' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t522

grep -a -v '_' $1.t51 | \
sed -e 's/[^#]*#//;s/_//;' | \
cat > $1.t53

cat $1.t53 | sed -e 's/.. //' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t531

cat $1.t53 | sed -e 's/ .\(.\). /\1/' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t532

cat $1.t53 | sed -e 's/ ..//' | \
awk -f sums.awk | \
sort -n -r -k 2 | \
cat > $1.t533


 echo " full stats " >> $1.lst
 cat $1.t31  >> $1.lst
 echo " bigrams with space " >> $1.lst
 cat $1.t42  >> $1.lst
 echo " bigrams firt letter " >> $1.lst
 cat $1.t431  >> $1.lst
 echo " bigrams last letter " >> $1.lst
 cat $1.t432  >> $1.lst
 echo " trigrams with space first letter" >> $1.lst
 cat $1.t521  >> $1.lst
 echo " trigrams firt letter last letter" >> $1.lst
 cat $1.t522  >> $1.lst
 echo " trigrams firt letter " >> $1.lst
 cat $1.t531  >> $1.lst
 echo " trigrams middle letter " >> $1.lst
 cat $1.t532  >> $1.lst
 echo " trigrams last letter " >> $1.lst
 cat $1.t533  >> $1.lst

#sed -e 's/[^=]*=//;s/_//;' | \
#awk -f sums.awk | sort -n -r -k 2 | cat -n $1.t8

#grep -a '^# ' $1.t2  | sort -n -r -k 3 | cat -n > $1.t5
#grep -a '_' $1.t5 | cat > $1.t7
#grep -v -E '[etoanhir]' $1.t7 | \
#sed -e 's/[^=]*=//;s/_//;' > $1.t9


