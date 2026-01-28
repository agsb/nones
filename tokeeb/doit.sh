#! /bin/bash

cut -f 1,4 -d',' < NGSL_1.2_stats.csv > a

tr [:upper:] [:lower:] < a > b 

tr ',' ' ' < b > c 

awk -f lcs.awk < c > d

sort -nr -k 2 < d > e 
