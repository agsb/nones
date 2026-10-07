


awk -f keyslays.awk $1 < $2 > $3.o0

#cat $3.o0 | tr '.' ',' | sort -n -r -k 3 > $3.o3
#cat $3.o0 | tr '.' ',' | sort -n -r -k 4 > $3.o4

cat $3.o0 | sort -n -r -k 3 > $3.o3
cat $3.o0 | sort -n -r -k 4 > $3.o4
