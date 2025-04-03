#!/usr/bin/bash

awk -f do.awk $1 $2 > $3

grep "#w" $3 | sort -r -n -k 2 -t, > $3.ws

grep "#p" $3 | sort -r -n -k 2 -t, > $3.ps

