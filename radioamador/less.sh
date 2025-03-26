cat $1 | \
grep -v 'N' | \
grep -v 'X' | \
grep -v '1PU' | \
grep -v '1PY' | \
sed -e '/\([A-Z]\)\1/d' > $1.lst
#sed -e '/\([A-Z]\)\1/--/' | \
#grep -v '\-\-' > $1.lst
