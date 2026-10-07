
cat $1 | cut -f 1,2,4 -d ',' | sed -e '1s/^/# /' > $1.t1

awk -f percents.awk $1.t1 | tr -s ' ' > $1.t2

awk -f ngrams.awk $1.t2 > $1.t3

grep -a '^- ' $1.t3 | cat -n > $1.t4
grep -a '^= ' $1.t3 | cat -n > $1.t5
grep -a '^# ' $1.t3 | cat -n > $1.t6

grep -a '^1 ' $1.t3  | sort -n -r -k 3 | cat -n > $1.t7
grep -a '^2 ' $1.t3  | sort -n -r -k 3 | cat -n > $1.t8
grep -a '^3 ' $1.t3  | sort -n -r -k 3 | cat -n > $1.t9

grep -a '_' $1.t8 | cat -n > $1.ta
grep -a '_' $1.t9 | cat -n > $1.tb


