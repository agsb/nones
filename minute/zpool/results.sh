
cat $1 | cut -f 1,2,4 -d ',' | sed -e '1s/^/# /' > $1.t1

awk -f percents.awk $1.t1 | tr -s ' ' > $1.t2

awk -f ngrams.awk $1.t2 > $1.t3

grep -a '^- ' $1.t3 | cat -n > $1.t4
grep -a '^= ' $1.t3 | cat -n > $1.t5
grep -a '^# ' $1.t3 | cat -n > $1.t6

grep -a '^n ' $1.t3  | sort -n -r -k 3 | cat -n > $1.t7
grep -a '^b ' $1.t3  | sort -n -r -k 3 | cat -n > $1.t8
grep -a '^t ' $1.t3  | sort -n -r -k 3 | cat -n > $1.t9

grep -a '_' $1.t8 | cat > $1.ta
grep -a '_' $1.t9 | cat > $1.tb

cat $1.t4 | tr  '\t\v' '  ' | tr -s ' ' | \
    cut -f 4 -d ' ' | tr '\n' ' ' > $1.ev

cat $1.t7 | tr  '\t\v' '  ' | tr -s ' ' | \
    cut -f 4 -d ' ' | tr '\n' ' ' > $1.fv

