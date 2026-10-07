#!/usr/bin/bash

# grep -f $1 < $2 > $3

echo -n " sed -i 's/^\\(" > $1.mm

for word in `cat $1` ;
do
    echo -n " $word " >> $1.mm
    echo -n "|" >> $1.mm
done;

echo -n " # \\)/ # /' " >> $1.mm

cat $2 | sh $1.mm | tee $3
