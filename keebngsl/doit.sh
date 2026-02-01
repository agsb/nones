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
cat z1 | grep '~' | sort -k 2 -t' ' > z7

# how many ino exists by first letter
cat z1 | grep '?' | sort -nr -k 3 -t' ' > z8

# select order for letters

cat z3 | tr -d '\n[:digit:]-.' | tr -s ' ' >  z9

cat z9 | sed -e "s/ //g; s/\(........\)/@\1/g;" > z10

# try for digraphs
# grep '\[[etoanhir][slducbfy]' z4 > t4

cat z10 | sed -e "s/@/grep '\\\[\[/; s/@/\]\[/; s/@.*/\]' z4 | sort -nr -k 3 -t' ' > tdv /;"  > z11

#cat z10 | sed -e "s/@/grep '\\\[\[/; s/@/\]\[/; s/@.*/\]' z7 | sort -nr -k 3 -t' ' > tdn /;"  > z12

sh z11

#sh z12

# try for trigraphs
# grep '\[[etoanhir][slducbfy][mwpgvkxj]' z5 > t5

cat z10 | sed -e "s/@/grep '\\\[\[/; s/@/\]\[/; s/@/\]\[/; s/$/\]' z5 | sort -nr -k 3 -t' ' > ttv /;"  > z13

# cat z10 | sed -e "s/@/grep '\\\[\[/; s/@/\]\[/; s/@/\]\[/; s/$/\]' z7 | sort -nr -k 3 -t' ' > ttn /;"  > z14

sh z13
#sh z14

