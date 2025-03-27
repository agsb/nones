cat $1 | \
# do not use
grep -v 'X' | \
# do not confuse with prefix
grep -v '[87654321]P[PQRSTYU].' | \
# do not allow repeats
sed -e '/\([A-Z]\)\1./d; /\([A-Z]\).\1/d; /.\([A-Z]\)\1/d; ' | \
# then list
cat > $1.0s
