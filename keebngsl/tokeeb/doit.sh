#! /bin/bash

# clean lines
cat NGSL_12_stats.csv | \
cut -f 1,4 -d',' | \
tr ',[:upper:]' ' [:lower:]' > e0

# frequencies
awk -f redux.awk < e0 > e1

# percents
cat e1 | grep '%' | sort -nr -k 3 -t' ' > e2

# letters
cat e1 | grep '-' | sort -nr -k 3 -t' ' > e3

# digraphs
cat e1 | grep '=' | sort -nr -k 3 -t' ' > e4

# trigraphs
cat e1 | grep '+' | sort -nr -k 3 -t' ' > e5

# no exists

cat e1 | grep '*' | sort -k 2 -t' ' > e6

