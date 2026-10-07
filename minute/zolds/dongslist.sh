#
#
# this is not for extended continous use, is not optimized in any way, just to run few times
#
# the input must be "rank lemma sfi ufm"
#	rank, sfi, ufm are integers and lemma is a ascii lowercase word
#

# for f in ngsls.v ngslp.v ngslf.v ; do

f=$1

# echo "[$1] [$f]"

# wise for rules

cat $f | tr '[:upper:]' '[:lower:]' | tr 'ñáéíóúàèìòùãõç' 'naeiouaeiouaoc' | tr -d '-' > $f.p0

# does all place counts
./ngslist < $f.p0 > $f.p1

# in any place
grep "= 0 " $f.p1 | sed -e 's/= 0//' | sort -nr -t' ' -k 2 | awk -f ngslsts.awk > $f.q0

# first letter
grep "= 1 " $f.p1 | sed -e 's/= 1//' | sort -nr -t' ' -k 2 | awk -f ngslsts.awk > $f.q1

# second letter
grep "= 2 " $f.p1 | sed -e 's/= 2//' | sort -nr -t' ' -k 2 | awk -f ngslsts.awk > $f.q2

# thirth letter
grep "= 3 " $f.p1 | sed -e 's/= 3//' | sort -nr -t' ' -k 2 | awk -f ngslsts.awk > $f.q3

# fourth letter
grep "= 4 " $f.p1 | sed -e 's/= 4//' | sort -nr -t' ' -k 2 | awk -f ngslsts.awk > $f.q4

# last letter
grep "= 5 " $f.p1 | sed -e 's/= 5//' | sort -nr -t' ' -k 2 | awk -f ngslsts.awk > $f.q5

## note z1 and z5 are also bigrams with space, the most used letter ever

# sum any place, first and last
# cat $f.z0 $f.z1 $f.z5 | ./ngsccs | sort -nr -t' ' -k 3 > $f.z6

# sum first and last
# cat $f.z1 $f.z5 | ./ngsccs | sort -nr -t' ' -k 3 | sed -e 's/= 6/= 7/' > $f.z7

# take the bigrams

cat $f.p0 | ./bigrams > $f.p2

grep '=' $f.p2 | sort -nr -t' ' -k 3 | sed -e 's/=/= 8/' > $f.z8

grep '+' $f.p2 | sort -nr -t' ' -k 3 > $f.p3

cp $f.z8 $f.z9

cat $f.z9 | sed -e '1d' > $f.z8

# list in sequence

> $f.p4

for n in 0 1 2 3 4 5 6 7 8; do

	echo -n "=" > zzz

	cut -d' ' -f 7 < $f.z$n | tr -d '\n' >> zzz

	cat zzz >> $f.p4

	echo '' >> $f.p4

done

# cat $f.t0 >> $f.p4

echo "X " >> $f.p4

cat $f.p4 $f.p0 | ./ngscns > $f.p5


cat $f.p3 | grep -v '{' | grep -v ' 0.0000 ' | tr -d ' 0123456789.[]' > zzz

cat << EndOfLine >$f.p6
#
# most frequent digrams
# first letter is fixed and next letters compose bigrams, in order of ocurrency
#
EndOfLine

for c in e t o a h n i l u r s b y d w f c g m p k v j x q z ; do

echo -n "$c" >> $f.p6

grep "+$c" zzz | sed -e "s/+$c//" | tr -d '$c\r\n' >> $f.p6

echo "" >> $f.p6

done

rm zzz

# relative bigrams

cat $f.p3 | grep -v ' 0.0000 ' > $f.bi

# only with space
grep '{' $f.bi > $f.bic

# only without space
grep -v '{' $f.bi > $f.bid

# just with vowels
grep -E 'a|e|i|o|u|y' $f.bid > $f.bie

# just without vowels
grep -Ev 'a|e|i|o|u|y' $f.bid > $f.bif

done



