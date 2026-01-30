#! /bin/bash

# clean lines
cat NGSL_12_stats.csv | cut -f 1,4 -d',' | tr ',' ' ' > z0

# frequencies
awk -f redux.awk < z0 > z1

# percents
cat z1 | grep '%' | sort -nr -k 3 -t' ' > z2

# letters
cat z1 | grep '-' | sort -nr -k 3 -t' ' > z3

# digraphs
cat z1 | grep '=' | sort -nr -k 3 -t' ' > z4

# trigraphs
cat z1 | grep '+' | sort -nr -k 3 -t' ' > z5

# quadgraphs
cat z1 | grep '#' | sort -nr -k 3 -t' ' > z6

# digraphs that no exists
cat z1 | grep '?' | sort -k 2 -t' ' > z7

# how many by first letter
cat z1 | grep '~' | sort -nr -k 3 -t' ' > z8

