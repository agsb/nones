 cat $1 | awk -f ngram.awk > $1.va
 grep '^n ' $1.va | sed -e 's/^n //' | sort -n -r -k 3 | awk -f cumus.awk > $1.vn
 grep '^d ' $1.va | sed -e 's/^d //' | sort -n -r -k 3 | awk -f cumus.awk > $1.vd
 grep '^t ' $1.va | sed -e 's/^t //' | sort -n -r -k 3 | awk -f cumus.awk > $1.vt

